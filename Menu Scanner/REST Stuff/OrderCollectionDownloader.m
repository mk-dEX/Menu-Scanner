//
//  OrderCollectionDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderCollectionDownloader.h"
#import "OrderRef.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"
#import "StringFormatter.h"

@implementation OrderCollectionDownloader

@synthesize delegate;

- (BOOL)downloadOrderCollection
{
    NSURLRequest *secureRequest = [self secureRequestUsingKeychainForURL:REST_ORDERS method:@"POST"];
    return secureRequest && [self executeRequest:secureRequest];
}

- (void)processData:(id)json
{
    NSMutableArray *orderRefs = [NSMutableArray new];
    
    for (NSDictionary *orderReference in json) {
        OrderRef *scannedOrderReference = [self orderReferenceFromJson:orderReference];
        if (scannedOrderReference) {
            [orderRefs addObject:scannedOrderReference];
        }
    }
    
    if (delegate) {
        [delegate download:self didFinishWithOrderCollection:orderRefs];
    }
}
                        
- (OrderRef *)orderReferenceFromJson:(NSDictionary *)jsonOrderRef
{
    OrderRef *orderRef = [OrderRef new];
    
    @try {
        orderRef.orderHash = [jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_HASH];
        orderRef.orderTime = [NSDate dateWithTimeIntervalSince1970:[[jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_TIME] floatValue]];
        orderRef.orderID = [[StringFormatter numberFormatter] numberFromString:[jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_ID]];
    }
    @catch (NSException *exception) {
        orderRef = nil;
    }
    @finally {
        return orderRef;
    }
}

@end
