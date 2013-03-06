//
//  BaseSliderViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "LoginChecker.h"

@interface AuthenticationViewController : ECSlidingViewController <UITableViewDataSource, UITextFieldDelegate, LoginCheckerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)authenticateUser:(id)sender;
@end
