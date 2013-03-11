//
//  ImagePickerOptionsViewController.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ImagePickerLibrary,
    ImagePickerCamera
} ImagePickerOption;

@class ImagePickerOptionsViewController;
@protocol ImagePickerOptionsViewControllerDelegate
- (void)optionPickerController:(ImagePickerOptionsViewController *)picker didSelectOption:(ImagePickerOption)option;
@end

@interface ImagePickerOptionsViewController : UIViewController

@property (weak) id<ImagePickerOptionsViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *optionButtonLibrary;
@property (strong, nonatomic) IBOutlet UIButton *optionButtonCamera;

- (IBAction)selectOption:(id)sender;

@end
