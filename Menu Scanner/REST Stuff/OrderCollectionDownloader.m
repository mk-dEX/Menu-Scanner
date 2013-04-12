//
//  OrderCollectionDownloader.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 06.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderCollectionDownloader.h"
#import "MenuScannerConstants.h"
#import "Order.h"

@implementation OrderCollectionDownloader

@synthesize delegate;

- (BOOL)downloadOrderCollectionWithHashes:(NSArray *)orderHashes
{
    NSDictionary *hashRequestDict = @{@"hashes": orderHashes};
    NSError *error;
    NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:hashRequestDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest *secureRequest = (NSMutableURLRequest *)[self secureRequestUsingKeychainForURL:[REST_ORDERS stringByAppendingString:@"/multiple"] method:@"POST"];
    if (secureRequest && jsonBody) {
        [secureRequest setHTTPBody:jsonBody];
        [secureRequest setValue:@"application/json"
             forHTTPHeaderField:@"Content-Type"];
        return [self executeRequest:secureRequest];
    }
    
    return NO;
}

- (void)processData:(id)json
{
    NSMutableArray *orders = [NSMutableArray array];
    
    for (NSDictionary *jsonOrder in json)
    {    
        NSMutableDictionary *products = [NSMutableDictionary new];
        NSMutableArray *categories = [NSMutableArray new];
        
        for (NSDictionary *product in [JSONMapper productListFromJson:jsonOrder])
        {
            Product *scannedProduct = [JSONMapper productFromJson:product];
            if (scannedProduct)
            {
                NSString *scannedCategory = scannedProduct.category.name;
                if (![categories containsObject:scannedCategory])
                {
                    [categories addObject:scannedCategory];
                    [products setObject:[NSMutableArray new] forKey:scannedCategory];
                }
                [[products objectForKey:scannedCategory] addObject:scannedProduct];
            }
        }
        
        Order *order = [JSONMapper orderFromJson:jsonOrder];
        order.categories = categories;
        order.products = products;
        
        [orders addObject:order];
    }
    
    if (delegate) {
        [delegate download:self didFinishWithOrderCollection:orders];
    }
}


@end
