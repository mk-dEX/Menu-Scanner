//
//  NameCollectionDownloader.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductCollectionDownloader.h"
#import "MenuScannerConstants.h"
#import "Product.h"
#import "StringFormatter.h"

@implementation ProductCollectionDownloader

@synthesize delegate;

- (BOOL)downloadProductCollectionWithId:(NSNumber *)categoryId
{
    NSString *relativUrlString = [categoryId isEqualToNumber:@-1] ? @"" : [NSString stringWithFormat:@"/%@/items", [[StringFormatter numberFormatter] stringFromNumber:categoryId]];
    NSURL *targetURL = [NSURL URLWithString:[PRODUCT_COLLECTION_DOWNLODER_URL stringByAppendingString:relativUrlString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    return request && [self executeRequest:request];
}

- (BOOL)downloadProductCollection;
{
    return [self downloadProductCollectionWithId:@-1];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSMutableDictionary *products = [NSMutableDictionary new];
    
    for (NSDictionary *product in json)
    {
        Product *scannedProduct = [self productFromJson:product];
        
        if (scannedProduct) {
            NSString *key = scannedProduct.category;
            if (![products objectForKey:key]) {
                [products setValue:[NSMutableArray new] forKey:key];
            }
            [[products objectForKey:key] addObject:scannedProduct];
        }
    }
    
    if (delegate)
    {
        [delegate download:self didFinishWithProductCollection:products];
    }
}

- (Product *)productFromJson:(NSDictionary *)jsonProduct
{
    Product *product = [Product new];
    
    NSNumberFormatter *floatFormatter = [StringFormatter numberFormatter];
    [floatFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    @try {
        product.productId = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_ID];
        product.name = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_NAME];
        product.descr = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_DESCR];
        product.unit = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_UNIT];
        product.categoryId = [[StringFormatter numberFormatter] numberFromString:[jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_CATEGORY_ID]];
        product.category = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_CATEGORY];
        product.imageURL = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_IMAGE];
        product.price = [floatFormatter numberFromString:[jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_PRICE_DEFAULT]];
    }
    @catch (NSException *exception) {
        product = nil;
    }
    @finally {
        return product;
    }
}
@end
