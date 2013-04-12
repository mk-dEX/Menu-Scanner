//
//  NavigationViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderViewController.h"
#import "Product.h"
#import "ProductInfoCell.h"
#import "ProductCategoryCell.h"
#import "StringFormatter.h"
#import "PictureManager.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface OrderViewController ()
@property (strong, nonatomic) Order *selectedOrder;
@property (strong, nonatomic) NSMutableDictionary *pictureManager;
@property (strong, nonatomic) UIPopoverController *masterPopover;
@end

@implementation OrderViewController

@synthesize orderInfo;
@synthesize tableView;

@synthesize selectedOrder;
@synthesize pictureManager;
@synthesize masterPopover;

- (void)viewDidLoad
{
    self.pictureManager = [NSMutableDictionary new];
    
    UIBarButtonItem *showCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                target:self
                                                                                action:@selector(showCamera:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:NAV_BTN_REGISTER_NEW_PRODUCT
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(addNewItem:)];
    
    self.navigationItem.rightBarButtonItems = @[showCamera, addItem];
    [self.orderInfo.layer setCornerRadius:5.0];
    [self.orderInfo setAlpha:0.5];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self presentAuthenticationView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReaderView"]) {
        ReaderViewController *rvc = segue.destinationViewController;
        rvc.delegate = self;
    }
}


#pragma mark - Authentication

- (void)presentAuthenticationView
{
    UIAlertView *authenticationView = [[UIAlertView alloc] initWithTitle:@"Anmeldung"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Abbrechen"
                                                       otherButtonTitles:@"Anmelden", nil];
    [authenticationView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    if ([self shouldRestoreCredentials]) {
        NSString *user;
        NSString *password;
        if ((user = [SecurityManager loadUserName]) != nil && (password = [SecurityManager loadPasswordForUser:user]) != nil)
        {
            [[authenticationView textFieldAtIndex:0] setText:user];
            [[authenticationView textFieldAtIndex:1] setText:password];
        }
    }
    
    [authenticationView show];
}

- (void)presentSaveCredentialsView
{
    UIAlertView *credentialsView = [[UIAlertView alloc] initWithTitle:@"Anmeldung erfolgreich!"
                                                              message:@"Sollen die Benutzerdaten sicher gespeichert werden?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Nein!"
                                                    otherButtonTitles:@"Jep", nil];
    [credentialsView setAlertViewStyle:UIAlertViewStyleDefault];
    [credentialsView show];
}

- (void)authenticationWasSuccesful:(BOOL)success
{
    if (success) {
        [self presentSaveCredentialsView];
    }
    else {
        [self presentAuthenticationView];
    }
}

- (void)setApplicationActive
{
    [[self orderMasterView] reloadOrderCollection:self];
}


#pragma mark - Alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
    {
        if (buttonIndex == 0) {
            [self authenticationWasSuccesful:NO];
        }
        else {
            NSString *user = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            if ([SecurityManager storeUserName:user] && [SecurityManager storePassword:password forUser:user]) {
                [self checkPassword:password forUser:user];
            }
            else {
                [self authenticationWasSuccesful:NO];
            }
        }
    }
    else if (alertView.alertViewStyle == UIAlertViewStyleDefault)
    {
        [self setCredentialsRestorationFlag:(buttonIndex == 1)];
        [self setApplicationActive];
    }
}

- (BOOL)checkPassword:(NSString *)password forUser:(NSString *)user
{
    if (!user || !password) {
        [self authenticationWasSuccesful:NO];
        return NO;
    }

    LoginChecker *authenticator = [LoginChecker new];
    authenticator.httpDelegate = self;
    [authenticator authenticateWithPassword:password forName:user];
    return YES;
}

- (void)setCredentialsRestorationFlag:(BOOL)shouldRestore
{
    [SecurityManager storeRestorationFlag:shouldRestore];
}

- (BOOL)shouldRestoreCredentials
{
    return [SecurityManager loadRestorationFlag];
}


#pragma mark - HTTP Authentication

- (void)connection:(RESTConnection *)connection didFinishWithCode:(HttpCode)code
{
    [self authenticationWasSuccesful:(code == HttpCodeSuccessful)];
}

- (void)connection:(RESTConnection *)connection didFailWithError:(NSError *)error
{
    [self authenticationWasSuccesful:NO];
}


#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return selectedOrder ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!selectedOrder) {
        return 0;
    }
    NSString *category = [[self.selectedOrder categories] objectAtIndex:[self absoluteIndexOfCollectionView:collectionView]];
    NSArray *products = [self.selectedOrder productsOfCategory:category];
    return [products count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProductInfoCell";
    
    ProductInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSUInteger absoluteIndex = [self absoluteIndexOfCollectionView:collectionView];
    NSString *category = [[self.selectedOrder categories] objectAtIndex:absoluteIndex];
    Product *product = [[self.selectedOrder productsOfCategory:category] objectAtIndex:indexPath.row];

    NSNumber *totalPrice = [NSNumber numberWithFloat:([product.count floatValue] * [product.price floatValue])];
    NSString *count = [product.count stringValue];
    NSString *descr = [count stringByAppendingFormat:@" %@", product.name];
    
    [cell.descr setText:descr];
    [cell.price setText:[NSString stringWithFormat:@"@ %@", [[StringFormatter currencyFormatter] stringFromNumber:product.price]]];
    [cell.total setText:[[StringFormatter currencyFormatter] stringFromNumber:totalPrice]];
    
    [[PictureManager sharedInstance] initImageView:cell.picture withImageFromURL:product.imageURL];
    
    CALayer *layer = cell.layer;
    [layer setMasksToBounds:NO];
    [layer setShadowOffset:CGSizeMake(0, 2)];
    [layer setShadowRadius:2.0];
    [layer setShadowColor:[UIColor blackColor].CGColor] ;
    [layer setShadowOpacity:0.8];
    [layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
    
    return cell;
}

- (NSUInteger)absoluteIndexOfCollectionView:(UICollectionView *)collectionView
{
    //1. Superview = UITableViewCellContentView
    //2. Superview = UITableViewCell
    UITableViewCell *parentCell = (UITableViewCell *)[((UIView *)collectionView.superview) superview];
    UITableView *parentTableView = (UITableView *)parentCell.superview;
    NSIndexPath *indexPath = [parentTableView indexPathForCell:parentCell];
    NSUInteger section = [indexPath section];
    return section;
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    if (!selectedOrder) {
        [self.orderInfo setText:@"Keine Bestellung ausgewählt…"];
        return 0;
    }
    return [[selectedOrder categories] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCategoryCell";
    ProductCategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell reloadData];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[selectedOrder categories] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Master view

- (OrderCollectionViewController *)orderMasterView
{
    return (OrderCollectionViewController *)[[self.splitViewController.viewControllers objectAtIndex:0] topViewController];
}

- (void)showOrder:(Order *)order
{
    if (selectedOrder != order)
    {
        selectedOrder = order;
        
        [self.orderInfo setText:[NSString stringWithFormat:@"%@%@", ORDER_COSTS_PRE_CLAUSE, [[StringFormatter currencyFormatter] stringFromNumber:self.selectedOrder.totalCosts]]];
        
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@%@", ORDER_DATE_PRE_CLAUSE, [[StringFormatter dateFormatter] stringFromDate:self.selectedOrder.timestamp]]];
        
        [self.tableView reloadData];
    }
    
    if (masterPopover) {
        [masterPopover dismissPopoverAnimated:YES];
    }
}

- (void)showEmpty
{
    selectedOrder = nil;
    [self.navigationItem setTitle:@""];
    [self.tableView reloadData];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Überblick";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    masterPopover = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    masterPopover = nil;
}


#pragma mark - QR Reader

- (void)reader:(ReaderViewController *)reader didFinishWithHash:(NSString *)hash
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    [[self orderMasterView] addOrderByHash:hash];
}

#pragma mark - Bar button actions

- (IBAction)showCamera:(id)sender
{
    [self performSegueWithIdentifier:@"ReaderView" sender:self];
}

- (IBAction)addNewItem:(id)sender
{
    [self performSegueWithIdentifier:@"ItemView" sender:self];
}

@end
