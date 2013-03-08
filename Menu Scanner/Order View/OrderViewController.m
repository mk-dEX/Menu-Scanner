//
//  NavigationViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderViewController.h"
#import "ECSlidingViewController.h"
#import "OrderManager.h"
#import "Order.h"
#import "Product.h"
#import "ProductInfoCell.h"
#import "ProductInfoHeader.h"
#import "StringFormatter.h"

@interface OrderViewController ()
@property (strong, nonatomic) Order *currentOrder;
@property (strong, nonatomic) NSMutableDictionary *pictureManager;
@property (strong, nonatomic) StringFormatter *formatter;
@end

@implementation OrderViewController

@synthesize navigationItem;
@synthesize collectionView;

@synthesize currentOrder;
@synthesize pictureManager;
@synthesize formatter;

#pragma mark - View Handling

- (void) viewDidLoad
{
    UIBarButtonItem *showCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Neues Produkt" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewItem:)];
    
    self.navigationItem.rightBarButtonItems = @[showCamera, addItem];
    
    self.currentOrder = [Order new];
    self.pictureManager = [NSMutableDictionary new];
    

    [self.currentOrder setCategories:@[@"Keine Bestellungen hinterlegt"]];
    [self.currentOrder setProducts:@{@"Keine Bestellungen hinterlegt": @[]}];
    [self.currentOrder setTotalCosts:@0];
    [self.currentOrder setTimestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    formatter = [StringFormatter new];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[OrderCollectionViewController class]])
    {
        OrderCollectionViewController *orderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderCollection"];
        orderViewController.delegate = self;
        self.slidingViewController.underLeftViewController = orderViewController;
    }
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.shouldAllowPanningPastAnchor = NO;
    
    [self.collectionView setBackgroundColor:[UIColor underPageBackgroundColor]];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReaderView"])
    {
        ReaderViewController *reader = segue.destinationViewController;
        reader.delegate = self;
    }
}

#pragma mark - Collection View Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.currentOrder numberOfCategories];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *category = [currentOrder.categories objectAtIndex:section];
    return [self.currentOrder numberOfProductsInCategory:category];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProductCollectionCell";
    
    ProductInfoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *category = [currentOrder.categories objectAtIndex:indexPath.section];
    Product *product = [self.currentOrder productAtIndex:indexPath.row inCategory:category];

    
    NSNumber *totalPrice = [NSNumber numberWithFloat:([product.count floatValue] * [product.price floatValue])];
    
    NSString *count = [product.count stringValue];
    NSString *descr = [count stringByAppendingFormat:@" %@", product.name];
    
    [cell.descr setText:descr];
    [cell.price setText:[NSString stringWithFormat:@"@ %@", [formatter currencyString:product.price]]];
    [cell.total setText:[formatter currencyString:totalPrice]];
    
    UIImage *cachedImage = [self.pictureManager objectForKey:product.imageURL];
    if (cachedImage != nil) {
        cell.picture.image = cachedImage;
    }
    else {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: product.imageURL]];
            if (data == nil)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                cell.picture.image = image;
                [self.pictureManager setValue:image forKey:product.imageURL];
            });
        });
    }
    
    CALayer *layer = cell.layer;
    [layer setMasksToBounds:NO];
    [layer setShadowOffset:CGSizeMake(0, 2)];
    [layer setShadowRadius:2.0];
    [layer setShadowColor:[UIColor blackColor].CGColor] ;
    [layer setShadowOpacity:0.8];
    [layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ProductInfoHeader *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductCollectionHeader" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        NSNumber *orderCosts = currentOrder.totalCosts;
        if ([orderCosts longValue] == 0) {
            [headerView.headerTitle setText:@"Bestellung ist leer"];
        }
        else
        {
            NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
            [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [headerView.headerTitle setText:[@"Gesamt: " stringByAppendingString:[priceFormatter stringFromNumber:orderCosts]]];
        }
        
        [headerView.headerTitle setTextColor:[UIColor darkGrayColor]];
    }
    else
    {        
        [headerView.headerTitle setText:[currentOrder.categories objectAtIndex:indexPath.section]];
        [headerView.headerTitle setTextColor:[UIColor grayColor]];
    }
    
    return headerView;
}

#pragma mark - Collection View Management

- (void) displayProductInfos:(Order *)order
{
    currentOrder = order;
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Bestellung vom %@", [formatter dateString:currentOrder.timestamp]]];
    
    [self.collectionView reloadData];
}

#pragma mark - Button Action Handlers

- (IBAction)showOrders:(id)sender
{
    if ([self.slidingViewController underLeftShowing])
        [self.slidingViewController resetTopView];
    else
        [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)showCamera:(id)sender
{
    [self performSegueWithIdentifier:@"ReaderView" sender:self];
}

- (IBAction)addNewItem:(id)sender
{
    [self performSegueWithIdentifier:@"ItemView" sender:self];
}

#pragma mark - Reader Delegates

- (void) reader:(ReaderViewController *)reader didFinishWithHash:(NSString *)hash
{
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    ProductInfoDownloader *downloader = [ProductInfoDownloader new];
    downloader.delegate = self;
    [downloader startDownloadForOrderHash:hash];
}

#pragma mark - Order Collection View Delegates

- (void) orderView:(OrderCollectionViewController *)sender didSelectOrder:(Order *)order
{
    [self.slidingViewController resetTopView];
    [self displayProductInfos:order];
}

#pragma mark - REST Delegates

- (void) download:(ProductInfoDownloader *)download didFinishWithOrder:(Order *)order
{
    OrderManager *manager = [OrderManager getInstance];
    [manager addOrder:order];
    
    [self displayProductInfos:order];
}



@end
