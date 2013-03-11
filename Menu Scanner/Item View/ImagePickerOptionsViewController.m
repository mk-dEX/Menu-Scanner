//
//  ImagePickerOptionsViewController.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ImagePickerOptionsViewController.h"

@implementation ImagePickerOptionsViewController

@synthesize delegate;
@synthesize optionButtonLibrary;
@synthesize optionButtonCamera;

- (IBAction)selectOption:(id)sender
{
    ImagePickerOption selectedOption;
    
    if (sender == optionButtonLibrary) {
        selectedOption = ImagePickerLibrary;
    }
    else if (sender == optionButtonCamera) {
        selectedOption = ImagePickerCamera;
    }
    
    if (delegate) {
        [delegate optionPickerController:self didSelectOption:selectedOption];
    }
}
@end
