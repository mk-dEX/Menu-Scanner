//
//  ProductInfoDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductInfoDownloader.h"
#import "Product.h"
#import "StringFormatter.h"
#import "MenuScannerConstants.h"


@implementation ProductInfoDownloader

@synthesize delegate;

- (BOOL)downloadOrderWithHash:(NSString *)hash
{
    NSURL *requestedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", REST_ORDERS, hash]
                                 relativeToURL:self.baseURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestedURL
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:REQUEST_TIMEOUT];
    return request && [self executeRequest:request];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSMutableDictionary *products = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    for (NSDictionary *product in [JSONMapper productListFromJson:json])
    {
        Product *scannedProduct;
        
        if ((scannedProduct = [JSONMapper productFromJson:product]) != nil) {
            NSString *scannedCategory = scannedProduct.category.name;
            if (![categories containsObject:scannedCategory]) {
                [categories addObject:scannedCategory];
                [products setObject:[NSMutableArray new] forKey:scannedCategory];
            }
            [[products objectForKey:scannedCategory] addObject:scannedProduct];
        }        
    }
    
    if (delegate)
    {
        Order *scannedOrder = [JSONMapper orderFromJson:json];
        if (scannedOrder) {
            scannedOrder.categories = categories;
            scannedOrder.products = products;
            [self.delegate download:self didFinishWithOrder:scannedOrder];
        }
        else {
            [delegate download:self didReceiveInvalidData:json];
        }
    }
}

@end
