//
//  OrderViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderCollectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderRef.h"
#import "OrderInfoCell.h"
#import "StringFormatter.h"
#import "MenuScannerConstants.h"


@interface OrderCollectionViewController ()
@property (strong, nonatomic) OrderManager *orderManager;
@end

@implementation OrderCollectionViewController

@synthesize detailDelegate;
@synthesize orderManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadOrderCollection:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    
    orderManager = [OrderManager sharedInstance];
    orderManager.delegate = self;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.contentOffset = CGPointMake(0.0, 44.0);
}

- (IBAction)logout:(id)sender
{
    [orderManager resetManager];
    [[self orderDetailView] showEmpty];
    [[self orderDetailView] presentAuthenticationView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[orderManager orders] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderInfoCell";
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Order *o = [[orderManager orders] objectAtIndex:indexPath.row];
    
    [cell.date setText:[[StringFormatter dateFormatter] stringFromDate:o.timestamp]];
    [cell.time setText:[[StringFormatter timeFormatter] stringFromDate:o.timestamp]];
    [cell.costs setText:[[StringFormatter currencyFormatter] stringFromNumber:o.totalCosts]];
    
    [cell.checkScanned setAlpha:([orderManager didScanOrderWithID:o.orderID] ? 1.0 : 0.2)];
    
    cell.order = o;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int numberOfItems = [[orderManager orders] count];
    NSString *info = numberOfItems == 1 ? ORDER_COUNT_ONE : ORDER_COUNT_MANY;
    
    return [NSString stringWithFormat:@"%d %@", numberOfItems, info];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        OrderInfoCell *removedCell = (OrderInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
        Order *removedOrder = removedCell.order;
        [orderManager removeOrder:removedOrder];
    }     
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoCell *selectedCell = (OrderInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    Order *selectedOrder = selectedCell.order;
    
    OrderViewController *detailView = [self orderDetailView];
    [detailView showOrder:selectedOrder];
}

#pragma mark - Search Bar Delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length == 0) {
        [orderManager resetFilter];
    }
    else {
        [orderManager setFilter:text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Order Manager Delegate

- (void)reloadOrderCollection:(id)sender
{
    [orderManager updateOrders];
}

- (void)modelDidUpdate
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)selectedOrderDidChange:(Order *)newSelectedOrder atIndex:(NSUInteger)newSelectedIndex
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [[self orderDetailView] showOrder:newSelectedOrder];
}

#pragma mark - Detail view

- (OrderViewController *)orderDetailView
{
    return (OrderViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)addOrderByHash:(NSString *)hash
{
    [self.orderManager addOrderByHash:hash];
}

@end
