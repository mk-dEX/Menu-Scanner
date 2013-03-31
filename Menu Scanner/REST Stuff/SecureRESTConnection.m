//
//  SecureRESTConnection.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"

@implementation SecureRESTConnection

- (NSURLRequest *)secureRequestForURL:(NSString *)relativeURL
                               method:(NSString *)httpMethod
                                 name:(NSString *)user
                             password:(NSString *)password
{
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];    
    NSString *signature = [NSString stringWithFormat:@"%@.%@.%ld", relativeURL, user, timestamp];
    NSString *signatureHash = [SecurityManager hashString:signature withSalt:password];
    
    NSURL *requestedURL = [NSURL URLWithString:relativeURL relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestedURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:REQUEST_TIMEOUT];
    [request setValue:[NSString stringWithFormat:@"%ld", timestamp] forHTTPHeaderField:SECURE_REST_CONNECTION_TIMESTAMP];
    [request setValue:signatureHash forHTTPHeaderField:SECURE_REST_CONNECTION_SIGNATURE];
    [request setValue:user forHTTPHeaderField:SECURE_REST_CONNECTION_USERNAME];
    [request setHTTPMethod:httpMethod];
    
    return request;
}

- (NSURLRequest *)secureRequestUsingKeychainForURL:(NSString *)relativeURL
                                            method:(NSString *)httpMethod
{
    NSString *user;
    NSString *password;
    if ((user = [SecurityManager loadUserName]) == nil || (password = [SecurityManager loadPasswordForUser:user]) == nil) {
        return nil;
    }
    
    return [self secureRequestForURL:relativeURL method:httpMethod name:user password:password];
}

@end
