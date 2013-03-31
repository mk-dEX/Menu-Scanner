//
//  OrderUpdater.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 13.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderUpdater.h"
#import "MenuScannerConstants.h"
#import "SecurityManager.h"

@implementation OrderUpdater

- (BOOL)removeOrderWithID:(NSNumber *)orderID;
{
    NSString *requestedURL = [NSString stringWithFormat:@"%@/%@", REST_ORDERS, orderID];
    NSURLRequest *secureRequest = [self secureRequestUsingKeychainForURL:requestedURL method:@"DELETE"];
    return secureRequest && [self executeRequest:secureRequest];
}

@end
