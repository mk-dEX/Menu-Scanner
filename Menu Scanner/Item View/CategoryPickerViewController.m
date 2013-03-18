//
//  CategoryPickerViewController.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "CategoryPickerViewController.h"

@interface CategoryPickerViewController ()
@property (strong, nonatomic) NSArray *availableCategories;
@property (strong, nonatomic) CategoryCollectionDownloader *categoryDownloader;
@end

@implementation CategoryPickerViewController

@synthesize selectedCategory;

@synthesize availableCategories;
@synthesize categoryDownloader;

- (void)viewDidLoad
{
    [super viewDidLoad];

    availableCategories = @[];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    categoryDownloader = [CategoryCollectionDownloader new];
    categoryDownloader.delegate = self;
    [self refresh:nil];
}

- (void)returnWithCategory:(Category *)category
{
    selectedCategory = category;
    [self performSegueWithIdentifier:@"UnwindCategoryPicker" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [availableCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewProductCell";
    NewProductInfoCell *cell = (NewProductInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Category *category = [availableCategories objectAtIndex:indexPath.row];
    
    [cell.name setTitle:category.name forState:UIControlStateNormal];
    cell.productProperty = category;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self returnWithCategory:(Category *)[((NewProductInfoCell *)[tableView cellForRowAtIndexPath:indexPath]) productProperty]];
}

#pragma mark - Category cell delegate

- (void)cell:(NewProductInfoCell *)cell didSelect:(id)property;
{
    [self returnWithCategory:(Category *)property];
}


#pragma mark - Category collection downloader delegate

- (void)download:(CategoryCollectionDownloader *)download didFinishWithCategoryCollection:(NSArray *)categories
{
    [self.refreshControl endRefreshing];
    
    self.availableCategories = categories;
    
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender
{
    [categoryDownloader downloadCategoryCollection];
}

@end
