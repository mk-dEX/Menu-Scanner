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

- (NSURLRequest *)secureRequestForUrl:(NSURL *)requestedUrl method:(NSString *)httpMethod withName:(NSString *)user andPassword:(NSString *)password
{
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    NSString *relativeUrl = [[requestedUrl absoluteString] stringByReplacingOccurrencesOfString:SECURE_REST_CONNECTION_BASE_URL withString:@""];
    
    NSString *signature = [NSString stringWithFormat:@"%@.%@.%ld", relativeUrl, user, timestamp];
    NSString *signatureHash = [SecurityManager hashString:signature withSalt:password];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestedUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"%ld", timestamp] forHTTPHeaderField:SECURE_REST_CONNECTION_TIMESTAMP];
    [request setValue:signatureHash forHTTPHeaderField:SECURE_REST_CONNECTION_SIGNATURE];
    [request setValue:user forHTTPHeaderField:SECURE_REST_CONNECTION_USERNAME];
    [request setHTTPMethod:httpMethod];
    
    return request;
}

@end
