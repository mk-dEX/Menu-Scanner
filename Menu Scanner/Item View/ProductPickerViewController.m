//
//  NamePickerViewController.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductPickerViewController.h"
#import "NewProductInfoCell.h"

@interface ProductPickerViewController ()
@property (strong, nonatomic) NSDictionary *availableProducts;
@property (strong, nonatomic) ProductCollectionDownloader *productDownloader;
@end

@implementation ProductPickerViewController

@synthesize selectedProduct;
@synthesize categoryID;

@synthesize availableProducts;
@synthesize productDownloader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    availableProducts = @{};
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    productDownloader = [ProductCollectionDownloader new];
    productDownloader.delegate = self;
    [self refresh:nil];
}

- (void)returnWithProduct:(Product *)product
{
    selectedProduct = product;
    [self performSegueWithIdentifier:@"UnwindProductPicker" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self productsAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self sections] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewProductCell";
    NewProductInfoCell *cell = (NewProductInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Product *product = [[self productsAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell.name setText:product.name];
    cell.productProperty = product;
    
    if (indexPath.row%2 == 1) {
        [cell.contentView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
    }
    
    return cell;
}

- (NSArray *)sections
{
    return [availableProducts allKeys];
}

- (NSArray *)productsAtIndex:(NSUInteger)section
{
    return [availableProducts objectForKey:[[self sections] objectAtIndex:section]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self returnWithProduct:(Product *)[((NewProductInfoCell *)[tableView cellForRowAtIndexPath:indexPath]) productProperty]];
}


#pragma mark - Product collection downloader delegate

- (void)download:(ProductCollectionDownloader *)download didFinishWithProductCollection:(NSDictionary *)products
{
    [self.refreshControl endRefreshing];
    
    self.availableProducts = products;
    
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender
{
    if (categoryID) {
        [productDownloader downloadProductCollectionWithID:categoryID];
    }
    else {
        [productDownloader downloadProductCollection];
    }
}

@end
