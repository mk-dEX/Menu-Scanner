//
//  BaseSliderViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "SecurityManager.h"

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

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITextField *other = textField == loginId ? password : loginId;
    if ([other.text length] == 0) {
        [textField setReturnKeyType:UIReturnKeyNext];
    }
    else {
        [textField setReturnKeyType:UIReturnKeyGo];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *other = textField == loginId ? password : loginId;
    if ([other.text length] == 0) {
        [other becomeFirstResponder];
    }
    else {
        [self authenticateUser:textField];
    }
    
    return YES;
}

#pragma mark - Authentication Actions

- (IBAction)authenticateUser:(id)sender
{
    [self animateLogin:YES];
    
    [loginId resignFirstResponder];
    [password resignFirstResponder];
    
    NSString *name = loginId.text;
    NSString *key = password.text;
        
    LoginChecker *loginChecker = [LoginChecker new];
    loginChecker.delegate = self;
    [loginChecker authenticateWithPassword:key forName:name];
}

- (void)loginIsValid:(BOOL)valid
{
    [self animateLogin:NO];
    
    if (!valid)
    {
        NSString *msg = @"Das von dir eingegebene Passwort stimmt nicht. Bitte versuche es noch einmal.";
        [self presentInfo:msg withTitle:@"Fehler"];
    }
    else
    {
        BOOL successfullyStored = [self storeLoginData];
        if (successfullyStored) {
            [self presentOrderView];
        }
        else {
            NSString *msg = @"Fehler beim Abspeichern des Passworts.";
            [self presentInfo:msg withTitle:@"Achtung!"];
        }
    }
}

- (BOOL)storeLoginData
{
    NSString *selectedUser = loginId.text;
    NSString *selectedPassword = password.text;
    return [SecurityManager storeUserName:selectedUser] & [SecurityManager storePassword:selectedPassword forUser:selectedUser];
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
    [loginId setUserInteractionEnabled:!doAnimate];
    [password setUserInteractionEnabled:!doAnimate];
}

- (void)presentInfo:(NSString *)infoText withTitle:(NSString *)infoTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:infoTitle
                                                    message:infoText
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)presentOrderView
{
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
}

@end
