//
//  NavigationViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "ProductInfoDownloader.h"
#import "OrderCollectionViewController.h"

@interface OrderViewController : UIViewController
<ReaderViewDelegate, ProductInfoDownloaderDelegate, OrderCollectionViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)showOrders:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
