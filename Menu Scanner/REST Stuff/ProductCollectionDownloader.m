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
#import "Category.h"
#import "StringFormatter.h"

@implementation ProductCollectionDownloader

@synthesize delegate;

- (BOOL)downloadProductCollectionWithID:(NSNumber *)categoryID;
{
    if (!categoryID) return NO;
    
    NSURL *requestedURL;
    if ([categoryID isEqualToNumber:@-1]) {
        requestedURL = [NSURL URLWithString:REST_ITEMS relativeToURL:self.baseURL];
    }
    else {
        requestedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@", REST_CATEGORIES, categoryID, REST_ITEMS] relativeToURL:self.baseURL];
    }
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestedURL
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:REQUEST_TIMEOUT];
    return request && [self executeRequest:request];
}

- (BOOL)downloadProductCollection;
{
    return [self downloadProductCollectionWithID:@-1];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSMutableDictionary *products = [NSMutableDictionary new];
    
    for (NSDictionary *product in json)
    {
        Product *scannedProduct = [JSONMapper productFromJson:product];
        
        if (scannedProduct) {
            NSString *key = scannedProduct.category.name;
            if (![products objectForKey:key]) {
                [products setValue:[NSMutableArray new] forKey:key];
            }
            [[products objectForKey:key] addObject:scannedProduct];
        }
    }
    
    if (delegate) {
        [delegate download:self didFinishWithProductCollection:products];
    }
}

@end
