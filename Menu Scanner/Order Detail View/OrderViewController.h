//
//  NavigationViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "OrderCollectionViewController.h"
#import "Order.h"
#import "LoginChecker.h"

@interface OrderViewController : UIViewController
<UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, ReaderViewDelegate, RESTConnectionDelegate>
@property (strong, nonatomic) IBOutlet UILabel *orderInfo;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (void)showOrder:(Order *)order;
- (void)showEmpty;
- (void)presentAuthenticationView;
@end
