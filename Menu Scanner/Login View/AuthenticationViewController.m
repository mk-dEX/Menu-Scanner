//
//  BaseSliderViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 06.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "LoginInfoCell.h"

@implementation AuthenticationViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableView setBackgroundView:nil];
    [self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LoginInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.info.placeholder = @"Login Name";
    }
    else {
        cell.info.placeholder = @"Passwort";
        cell.info.secureTextEntry = YES;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self authenticateUser:textField];
    return YES;
}

- (IBAction)authenticateUser:(id)sender
{    
    LoginInfoCell *nameCell = (LoginInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginInfoCell *keyCell = (LoginInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [nameCell.info resignFirstResponder];
    [keyCell.info resignFirstResponder];
    
    NSString *name = nameCell.info.text;
    NSString *key = keyCell.info.text;
    
    LoginChecker *loginChecker = [LoginChecker new];
    loginChecker.delegate = self;
    [loginChecker authenticateWithUserName:name andPassword:key];
}

- (void)loginIsValid:(BOOL)valid
{
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

@end
