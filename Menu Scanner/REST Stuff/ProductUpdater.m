//
//  ItemUpdater.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductUpdater.h"
#import "MenuScannerConstants.h"
#import "Base64.h"

@implementation ProductUpdater


- (NSDictionary *)dictionaryForProduct:(Product *)product withImage:(UIImage *)image
{
    
    NSString *imageKey = (image != nil) ? @"image" : @"imageURL";
    NSString *imageValue = (image != nil) ? [Base64 encode:UIImagePNGRepresentation(image)] : product.imageURL;
    
    return @{
             @"name": product.name,
             @"description": product.descr,
             @"unit": product.unit,
             @"defaultPrice": product.price,
             imageKey: imageValue,
             @"categoryID": product.category.name
             };
}


- (BOOL)addProduct:(Product *)newProduct withImage:(UIImage *)newProductImage
{
    NSDictionary *jsonData = [self dictionaryForProduct:newProduct withImage:newProductImage];
    if (!jsonData) {
        return NO;
    }
    
    NSError *error;
    NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:jsonData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *relativeURL = REST_ITEMS;
    
    return [self createRequestForURL:relativeURL withProductInfos:jsonBody method:@"POST"];
}


- (BOOL)patchProductWithID:(NSNumber *)productID withPatchedProduct:(Product *)patchedProduct
{
    NSDictionary *jsonData = [self dictionaryForProduct:patchedProduct withImage:nil];
    
    NSError *error;
    NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:jsonData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *relativeURL = [NSString stringWithFormat:@"%@/%@", REST_ITEMS, productID];

    
    return [self createRequestForURL:relativeURL withProductInfos:jsonBody method:@"PUT"];
}


- (BOOL)createRequestForURL:(NSString *)relativeURL
           withProductInfos:(NSData *)productInfoDictionaryData
                     method:(NSString *)httpMethod
{
    NSMutableURLRequest *secureRequest = (NSMutableURLRequest *)[self secureRequestUsingKeychainForURL:relativeURL method:httpMethod];
    if (secureRequest && productInfoDictionaryData) {
        [secureRequest setHTTPBody:productInfoDictionaryData];
        [secureRequest setValue:@"application/json"
             forHTTPHeaderField:@"Content-Type"];
        return [self executeRequest:secureRequest];
    }
    
    return NO;
}

@end
