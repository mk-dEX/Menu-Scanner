//
//  OrderViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"
#import "OrderViewController.h"

@class OrderCollectionViewController;
@protocol OrderDetailDelegate
- (void)viewController:(OrderCollectionViewController *)vc didSelectOrder:(Order *)order;
@end

@interface OrderCollectionViewController : UITableViewController <UISearchBarDelegate, OrderManagerDelegate>
@property (strong, nonatomic) id<OrderDetailDelegate> detailDelegate;
- (void)addOrderByHash:(NSString *)hash;
- (void)reloadOrderCollection:(id)sender;
- (IBAction)logout:(id)sender;
@end
