//
//  LoginChecker.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "LoginChecker.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"

@implementation LoginChecker

- (BOOL)authenticateWithPassword:(NSString *)password forName:(NSString *)user
{
    NSURL *url = [NSURL URLWithString:LOGIN_CHECKER_URL];
    NSURLRequest *secureRequest = [self secureRequestForUrl:url method:@"POST" withName:user andPassword:password];
    return secureRequest && [self executeRequest:secureRequest];
}

@end
