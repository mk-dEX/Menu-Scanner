//
//  OrderViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCollectionDownloader.h"
#import "ProductInfoDownloader.h"
#import "OrderManager.h"
#import "OrderUpdater.h"

@class OrderCollectionViewController;
@protocol OrderCollectionViewControllerDelegate
- (void) orderView:(OrderCollectionViewController *)sender didSelectOrder:(Order *)order;
@end

@interface OrderCollectionViewController : UITableViewController <UISearchBarDelegate, OrderManagerDelegate>
@property (weak) id<OrderCollectionViewControllerDelegate> delegate;
@end
