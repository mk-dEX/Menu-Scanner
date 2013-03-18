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
#import "MenuScannerConstants.h"
#import "CategoryPickerViewController.h"
#import "Category.h"

@interface ItemViewController ()
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverController *imagePickerOptionsPopover;
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
@synthesize imagePickerOptionsPopover;

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
        NSString *msg = ALRT_INFO_TEXTFIELD_NOT_FILLED;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALRT_TITLE_WARNING message:msg delegate:nil cancelButtonTitle:ALRT_BTN_ACCEPT otherButtonTitles:nil];
        return [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ImagePickerOptions"]) {
        imagePickerOptionsPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (imagePickerPopover.isPopoverVisible) {
        [self.imagePickerPopover presentPopoverFromRect:self.picture.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    if (imagePickerOptionsPopover && imagePickerOptionsPopover.isPopoverVisible) {
        [self.imagePickerOptionsPopover presentPopoverFromRect:self.picture.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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

#pragma mark - Input validation

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
    if (testPrice) {
        [self.price setText:[[StringFormatter currencyFormatter] stringFromNumber:testPrice]];
    }
    return testPrice != nil;
}

#pragma mark - Input validation UI feedback

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

#pragma mark - Image picker delegates

- (IBAction)unwindFromImageOptionPickerUsingLibrary:(UIStoryboardSegue *)segue
{
    imagePickerOptionsPopover = nil;
    [self presentImagePickerType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)unwindFromImageOptionPickerUsingCamera:(UIStoryboardSegue *)segue
{
    imagePickerOptionsPopover = nil;
    [self presentImagePickerType:UIImagePickerControllerSourceTypeCamera];
}

- (void)presentImagePickerType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = sourceType;
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.imagePickerPopover presentPopoverFromRect:self.picture.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = sourceType;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = ALRT_INFO_CAM_NOT_AVAILABLE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALRT_TITLE_ERROR message:msg delegate:nil cancelButtonTitle:ALRT_BTN_ACCEPT otherButtonTitles:nil];
        return [alert show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.picture setImage:selectedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [imagePickerPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - Category picker delegates

- (IBAction)unwindFromCategoryPicker:(UIStoryboardSegue *)segue
{
    Category *selectedCategory = [((CategoryPickerViewController *)segue.sourceViewController) selectedCategory];
    [category setText:selectedCategory.name];
    [self textFieldIsValid:category];
}

@end
