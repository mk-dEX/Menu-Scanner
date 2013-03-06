//
//  ItemViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 05.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (IBAction)closeForm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeFormAndSaveItem:(id)sender
{
    NSLog(@"Send Item");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
