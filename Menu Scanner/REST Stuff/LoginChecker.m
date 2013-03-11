//
//  LoginChecker.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "LoginChecker.h"
#import "SecurityManager.h"

@implementation LoginChecker
@synthesize delegate;

- (void)authenticateWithPassword:(NSString *)password forName:(NSString *)user
{
    NSURL *url = [NSURL URLWithString:@"http://api.codingduck.de/login/check"];
    NSURLRequest *secureRequest = [self secureRequestForUrl:url withName:user andPassword:password];
    
    if (secureRequest) {
        [self executeRequest:secureRequest];
    }
    else {
        [self notifySuccess:NO];
    }
}

- (void)authenticate
{
    NSURL *url = [NSURL URLWithString:@"http://api.codingduck.de/login/check"];
    NSURLRequest *secureRequest = [self secureRequestForUrl:url];

    if (secureRequest) {
        [self executeRequest:secureRequest];
    }
    else {
        [self notifySuccess:NO];
    }
}

- (void)notifySuccess:(BOOL)isValid
{
    if (delegate) {
        [delegate loginIsValid:isValid];
    }
}

- (void)processData:(id)json
{
    NSDictionary *error = [(NSDictionary *)json objectForKey:@"error"];
    NSNumber *code = (NSNumber *)[error objectForKey:@"code"];
    
    int value = [code intValue];
    [self notifySuccess:(value == 200)];
}

@end
