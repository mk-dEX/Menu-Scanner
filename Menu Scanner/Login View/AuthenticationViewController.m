//
//  BaseSliderViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()
@property (strong, nonatomic) UITextField *loginId;
@property (strong, nonatomic) UITextField *password;
@end

@implementation AuthenticationViewController

@synthesize tableView;
@synthesize loginButton;
@synthesize activityIndicator;

@synthesize loginId;
@synthesize password;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableView setBackgroundView:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row == 0) {
        loginId = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        loginId .placeholder = @"Login Name";
        loginId.text = @"";
        loginId .autocorrectionType = UITextAutocorrectionTypeNo;
        [loginId setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = loginId ;
        loginId.delegate = self;
        
        [self.tableView addSubview:loginId];
    }
    if (indexPath.row == 1) {
        password = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        password.placeholder = @"Passwort";
        password.text = @"";
        password.secureTextEntry = YES;
        password.autocorrectionType = UITextAutocorrectionTypeNo;
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = password;
        password.delegate = self;
        
        [self.tableView addSubview:password];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == loginId && [password.text isEqualToString:@""]) {
        [password becomeFirstResponder];
    }
    else if (textField == password && [loginId.text isEqualToString:@""]) {
        [loginId becomeFirstResponder];
    }
    else {
        [self authenticateUser:textField];
    }
    
    return YES;
}

- (IBAction)authenticateUser:(id)sender
{
    [self animateLogin:YES];
    
    NSString *name = loginId.text;
    NSString *key = password.text;
    
    LoginChecker *loginChecker = [LoginChecker new];
    loginChecker.delegate = self;
    [loginChecker authenticateWithUserName:name andPassword:key];
}

- (void)loginIsValid:(BOOL)valid
{
    [self animateLogin:NO];
    
    if (!valid)
    {
        NSString *msg = @"Das von dir eingegebene Passwort stimmt nicht. Bitte versuche es noch einmal.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Falsches Passwort"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }
        
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
    }
}

- (void)animateLogin:(BOOL)doAnimate
{
    if (doAnimate) {
        [activityIndicator startAnimating];
        [loginButton setTitle:@"Anmeldung erfolgt …" forState:UIControlStateNormal];
    }
    else {
        [activityIndicator stopAnimating];
        [loginButton setTitle:@"Anmelden" forState:UIControlStateNormal];
    }
}

@end
