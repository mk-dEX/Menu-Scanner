//
//  ItemViewController.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 05.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic) IBOutlet UITextField *price;
@property (strong, nonatomic) IBOutlet UITextView *descr;
@property (strong, nonatomic) IBOutlet UIImageView *picture;

@property (strong, nonatomic) IBOutlet UIImageView *checkName;
@property (strong, nonatomic) IBOutlet UIImageView *checkCategory;
@property (strong, nonatomic) IBOutlet UIImageView *checkPrice;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *uploadIndicator;

- (IBAction)closeForm:(id)sender;
- (IBAction)closeFormAndSaveItem:(id)sender;
@end
