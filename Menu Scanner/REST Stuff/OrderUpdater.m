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

- (BOOL)removeOrderWithId:(NSNumber *)orderId
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ORDER_UPDATER_URL, orderId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *user;
    NSString *password;
    if ((user = [SecurityManager loadUserName]) == nil || (password = [SecurityManager loadPasswordForUser:user]) == nil) {
        return NO;
    }
    
    NSURLRequest *secureRequest = [self secureRequestForUrl:url method:ORDER_UPDATER_METHOD withName:user andPassword:password];
    return secureRequest && [self executeRequest:secureRequest];
}

@end
