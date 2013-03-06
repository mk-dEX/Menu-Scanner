//
//  OrderCollectionDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderCollectionDownloader.h"
#import "OrderRef.h"

NSString const *ORDER_ID    = @"id";
NSString const *ORDER_HASH  = @"hash";
NSString const *ORDER_TIME  = @"orderTime";

@implementation OrderCollectionDownloader

@synthesize delegate;

- (void) startDownload
{
    NSURL *url = [NSURL URLWithString:@"http://api.codingduck.de/orders/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [self executeRequest:request];
}

- (void) processData:(id)json
{
    NSMutableArray *orderRefs = [NSMutableArray new];
    
    for (NSDictionary *order in json) {
        
        NSString *timestamp = [order objectForKey:ORDER_TIME];
        
        OrderRef *or = [[OrderRef alloc]
                        initWithHash:[order objectForKey:ORDER_HASH]
                        id:[order objectForKey:ORDER_ID]
                        time:[NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]]
                        ];
        [orderRefs addObject:or];
    }
    
    if (self.delegate)
    {   
        [self.delegate download:self didFinishWithOrderCollection:orderRefs];
    }
}

@end
