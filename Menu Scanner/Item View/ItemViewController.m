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
#import "PictureManager.h"
#import "MenuScannerConstants.h"
#import "CategoryPickerViewController.h"
#import "Category.h"
#import "ProductPickerViewController.h"
#import "Product.h"
#import "ProductUpdater.h"

@interface ItemViewController ()
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverController *imagePickerOptionsPopover;
@property (strong, nonatomic) UIPopoverController *productPickerController;
@property (strong, nonatomic) UIPopoverController *categoryPickerController;

@property (strong, nonatomic) Category *selectedCategory;
@property (strong, nonatomic) Product *selectedProduct;

@property (nonatomic) BOOL pictureIsDefault;
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

@synthesize categoryPicker;
@synthesize productPicker;

@synthesize imagePickerPopover;
@synthesize imagePickerOptionsPopover;
@synthesize productPickerController;
@synthesize categoryPickerController;

@synthesize selectedCategory;
@synthesize selectedProduct;

@synthesize pictureIsDefault;

- (void)viewDidLoad
{
    [price setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    CALayer *layer = descr.layer;
    [layer setCornerRadius:10.0];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [layer setBorderWidth:1.5f];
    descr.textColor = [UIColor blackColor];
    
    pictureIsDefault = YES;
}

- (IBAction)closeForm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeFormAndSaveItem:(id)sender
{
    if ([self allFieldsValid]) {
        [self uploadProduct];
    }
    else {
        NSString *msg = ALRT_INFO_TEXTFIELD_NOT_FILLED;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALRT_TITLE_WARNING message:msg delegate:nil cancelButtonTitle:ALRT_BTN_ACCEPT otherButtonTitles:nil];
        return [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    
    if ([identifier isEqualToString:@"ImagePickerOptions"]) {
        imagePickerOptionsPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    if ([identifier isEqualToString:@"Names"])
    {
        if (selectedCategory) {
            ProductPickerViewController *picker = segue.destinationViewController;
            picker.categoryID = selectedCategory.categoryID;
        }
        productPickerController = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    if ([identifier isEqualToString:@"CategoryNames"])
    {
        categoryPickerController = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resetPopover:imagePickerPopover
               toFrame:self.picture.frame
                inView:self.view
             direction:UIPopoverArrowDirectionLeft];
    
    [self resetPopover:imagePickerOptionsPopover
               toFrame:self.picture.frame
                inView:self.view
             direction:UIPopoverArrowDirectionLeft];
    
    [self resetPopover:productPickerController
               toFrame:self.productPicker.frame
                inView:self.view
             direction:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
    
    [self resetPopover:categoryPickerController
               toFrame:self.categoryPicker.frame
                inView:self.view
             direction:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
}

- (void)resetPopover:(UIPopoverController *)pc
             toFrame:(CGRect)frame
              inView:(UIView *)view
           direction:(UIPopoverArrowDirection)direction
{
    if (pc && pc.isPopoverVisible)
    {
        [pc presentPopoverFromRect:frame
                            inView:view
          permittedArrowDirections:direction
                          animated:YES];
    }
}

#pragma mark - Text Field Delegates

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkField:textField];
}

- (BOOL)textFielsShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Input validation

- (BOOL)allFieldsValid
{
    return [self checkField:name] & [self checkField:category] & [self checkField:price];
}

- (BOOL)checkField:(UITextField *)field
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
    NSString *rawNumber = [self.price.text stringByReplacingOccurrencesOfString:@"€" withString:@""];
    NSNumber *formattedNumber = [[StringFormatter numberFormatter] numberFromString:rawNumber];
    if (formattedNumber) {
        [self.price setText:[[StringFormatter currencyFormatter] stringFromNumber:formattedNumber]];
    }
    return formattedNumber != nil;
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
        [self.imagePickerPopover presentPopoverFromRect:self.picture.frame
                                                 inView:self.view
                               permittedArrowDirections:UIPopoverArrowDirectionLeft
                                               animated:YES];
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
    pictureIsDefault = NO;
    
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
    self.selectedCategory = [((CategoryPickerViewController *)segue.sourceViewController) selectedCategory];
    [category setText:selectedCategory.name];
    [self checkField:category];
}

#pragma mark - Product picker delegates

- (IBAction)unwindFromProductPicker:(UIStoryboardSegue *)segue
{
    self.selectedProduct = [((ProductPickerViewController *)segue.sourceViewController) selectedProduct];
    [name setText:selectedProduct.name];
    [self checkField:name];
    
    if ([category.text isEqualToString:@""]) {
        [category setText:selectedProduct.category.name];
        [self checkField:category];
        self.selectedCategory = nil;
    }
    
    if ([price.text isEqualToString:@""]) {
        [price setText:[[selectedProduct.price stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","]];
        [self checkField:price];
    }
    
    if ([descr.text isEqualToString:@""]) {
        [descr setText:selectedProduct.descr];
    }
    
    if (pictureIsDefault) {
        [[PictureManager sharedInstance] initImageView:picture withImageFromURL:selectedProduct.imageURL];
        pictureIsDefault = NO;
    }
}


#pragma mark - Product Upload

- (void)uploadProduct
{
    [uploadIndicator startAnimating];
    
    ProductUpdater *productUpdater = [ProductUpdater new];
    productUpdater.httpDelegate = self;
    
    
//    BOOL hasBeenEdited = YES; //..........
//    
//    if (selectedProduct)
//    {
//        [productUpdater patchProductWithID:selectedProduct.productID withPatchedProduct:selectedProduct];
//    }
//    else
//    {
        Product *createdProduct = [Product new];
        createdProduct.name = self.name.text;
        NSString *descrString = self.descr.text;
        createdProduct.descr = ([descrString length] == 0) ? @"." : descrString;
        createdProduct.unit = @".";
        NSString *priceString = [self.price.text stringByReplacingOccurrencesOfString:@"€" withString:@""];
        createdProduct.price = [[StringFormatter numberFormatter] numberFromString:priceString];
        
        Category *createdCategory = [Category new];
        createdCategory.name = self.category.text;
        createdProduct.category = createdCategory;
        
        [productUpdater addProduct:createdProduct withImage:self.picture.image];
//    }
}

- (void)endUploadWithSuccess:(BOOL)uploadIsSuccesful
{
    [uploadIndicator stopAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - REST

- (void)connection:(RESTConnection *)connection didFinishWithCode:(HttpCode)code
{
    [self endUploadWithSuccess:(code == HttpCodeSuccessful)];
}

- (void)connection:(RESTConnection *)connection didFailWithError:(NSError *)error
{
    [self endUploadWithSuccess:NO];
}




@end
