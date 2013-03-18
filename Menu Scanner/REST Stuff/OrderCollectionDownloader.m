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

- (BOOL)startDownload
{
    NSURL *url = [NSURL URLWithString:ORDER_COLLECTION_DOWNLOADER_URL];
    
    NSString *user;
    NSString *password;
    if ((user = [SecurityManager loadUserName]) == nil || (password = [SecurityManager loadPasswordForUser:user]) == nil) {
        return NO;
    }
    
    NSURLRequest *secureRequest = [self secureRequestForUrl:url method:@"POST"withName:user andPassword:password];
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
    
    if (self.delegate) {   
        [self.delegate download:self didFinishWithOrderCollection:orderRefs];
    }
}
                        
- (OrderRef *)orderReferenceFromJson:(NSDictionary *)jsonOrderRef
{
    OrderRef *orderRef = [OrderRef new];
    
    @try {
        orderRef.orderHash = [jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_HASH];
        orderRef.orderTime = [NSDate dateWithTimeIntervalSince1970:[[jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_TIME] floatValue]];
        orderRef.orderId = [[StringFormatter numberFormatter] numberFromString:[jsonOrderRef objectForKey:ORDER_COLLECTION_DOWNLOADER_ID]];
    }
    @catch (NSException *exception) {
        orderRef = nil;
    }
    @finally {
        return orderRef;
    }
}

@end
