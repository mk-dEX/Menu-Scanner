//
//  ItemViewController.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 05.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ItemViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StringFormatter.h"

@interface ItemViewController ()
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@end

@implementation ItemViewController

@synthesize name;
@synthesize category;
@synthesize price;
@synthesize descr;
@synthesize picture;
@synthesize checkName;
@synthesize checkCategory;
@synthesize checkPrice;
@synthesize uploadIndicator;

@synthesize imagePickerPopover;

- (void)viewDidLoad
{
    [price setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    CALayer *layer = descr.layer;
    [layer setCornerRadius:10.0];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [layer setBorderWidth:1.5f];
}

- (IBAction)closeForm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeFormAndSaveItem:(id)sender
{
    if ([self allFieldsValid]) {
        [uploadIndicator startAnimating];
        NSLog(@"Send Item");
        [uploadIndicator stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSString *msg = @"Einige Felder sind nicht korrekt ausgefüllt.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warnung" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ImagePickerOptions"]) {
        ImagePickerOptionsViewController *optionsViewController = (ImagePickerOptionsViewController *)segue.destinationViewController;
        optionsViewController.delegate = self;
    }
}

#pragma mark - Text Field Delegates

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldIsValid:textField];
}

- (BOOL)textFielsShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)allFieldsValid
{
    return [self textFieldIsValid:name] & [self textFieldIsValid:category] & [self textFieldIsValid:price];
}

- (BOOL)textFieldIsValid:(UITextField *)field
{
    BOOL isValid = NO;
    UIImageView *correspondingCheckView;
    
    if (field == name)
    {
        correspondingCheckView = checkName;
        isValid = [self nameIsValid];
    }
    else if (field == category)
    {
        correspondingCheckView = checkCategory;
        isValid = [self categoryIsValid];
    }
    else if (field == price)
    {
        correspondingCheckView = checkPrice;
        isValid = [self priceIsValid];
    }
    
    [self toggleField:field correct:isValid];
    [self toggleImage:correspondingCheckView correct:isValid];
    
    return isValid;
}

- (BOOL)nameIsValid
{
    return [self.name.text length] > 0;
}

- (BOOL)categoryIsValid
{
    return [self.category.text length] > 0;
}

- (BOOL)priceIsValid
{
    NSNumber *testPrice = [[StringFormatter numberFormatter] numberFromString:self.price.text];
    return testPrice != nil;
}

- (void)toggleImage:(UIImageView *)image correct:(BOOL)isCorrect
{
    float newAlpha = isCorrect ? 1.0 : 0.3;
    [image setAlpha:newAlpha];
}

- (void)toggleField:(UITextField *)field correct:(BOOL)isCorrect
{
    UIColor *newColor = isCorrect ? [UIColor greenColor] : [UIColor redColor];
    newColor = [newColor colorWithAlphaComponent:0.2];
    [field setBackgroundColor:newColor];
}

#pragma mark - Image Picker Delegates

- (void)optionPickerController:(ImagePickerOptionsViewController *)picker didSelectOption:(ImagePickerOption)option
{        
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    
    if (option == ImagePickerLibrary && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (option == ImagePickerCamera && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSString *msg = @"Die Funktion ist zurzeit leider nicht verfügbar.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return [alert show];
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [self.imagePickerPopover presentPopoverFromRect:self.picture.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.picture setImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
    [self.imagePickerPopover dismissPopoverAnimated:YES];
}

@end
