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


@interface OrderCollectionViewController ()
@property (strong, nonatomic) OrderManager *orderManager;
@property (strong, nonatomic) StringFormatter *formatter;
@end

@implementation OrderCollectionViewController

@synthesize delegate;

@synthesize orderManager;
@synthesize formatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View did load");
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadTableData:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    
    formatter = [StringFormatter new];
    orderManager = [OrderManager new];
    orderManager.delegate = self;
    
    [self reloadTableData:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTableViewWidthTo:280];
    self.tableView.contentOffset = CGPointMake(0.0, 44.0);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setTableViewWidthTo:280];
}

- (void) setTableViewWidthTo:(CGFloat)width
{
    CGRect frame = self.view.frame;
    frame.size.width = width;
    self.view.frame = frame;
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
    
    [cell.date setText:[formatter dateString:o.timestamp]];
    [cell.time setText:[formatter timeString:o.timestamp]];
    [cell.costs setText:[formatter currencyString:o.totalCosts]];
    
    cell.order = o;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int numberOfItems = [[orderManager orders] count];
    NSString *info = numberOfItems == 1 ? @"Bestellung" : @"Bestellungen";
    
    return [NSString stringWithFormat:@"%d %@", numberOfItems, info];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoCell *selectedCell = (OrderInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    Order *selectedOrder = selectedCell.order;
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (delegate)
    {
        [delegate orderView:self didSelectOrder:selectedOrder];
    }
}

#pragma mark - Search Bar Delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length == 0)
    {
        [orderManager resetFilter];
    }
    else
    {
        [orderManager setFilter:text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Order Manager Delegate

- (void)reloadTableData:(id)sender
{
    [orderManager updateOrders];
}

- (void)modelDidUpdate
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
