//
//  OrderCollectionDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderRefCollectionDownloader.h"
#import "OrderRef.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"
#import "StringFormatter.h"

@implementation OrderRefCollectionDownloader

@synthesize delegate;

- (BOOL)downloadOrderRefCollection
{
    NSURLRequest *secureRequest = [self secureRequestUsingKeychainForURL:REST_ORDERS method:@"POST"];
    return secureRequest && [self executeRequest:secureRequest];
}

- (void)processData:(id)json
{
    NSMutableArray *orderRefs = [NSMutableArray new];
    
    for (NSDictionary *orderReference in json) {
        OrderRef *scannedOrderReference = [JSONMapper orderReferenceFromJson:orderReference];
        if (scannedOrderReference) {
            [orderRefs addObject:scannedOrderReference];
        }
    }
    
    if (delegate) {
        [delegate download:self didFinishWithOrderRefCollection:orderRefs];
    }
}

@end
