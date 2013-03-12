//
//  SecureRESTConnection.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"
#import "SecurityManager.h"

@implementation SecureRESTConnection

- (NSURLRequest *)secureRequestForUrl:(NSURL *)requestedUrl
{
    NSString *user;
    NSString *password;
    
    if ((user = [self fetchUserName]) == nil || (password = [self fetchPasswordForUser:user]) == nil) {
        return nil;
    }
    
    return [self secureRequestForUrl:requestedUrl withName:user andPassword:password];
}

- (NSURLRequest *)secureRequestForUrl:(NSURL *)requestedUrl withName:(NSString *)user andPassword:(NSString *)password
{
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    NSString *relativeUrl = [[requestedUrl absoluteString] stringByReplacingOccurrencesOfString:@"http://api.codingduck.de" withString:@""];
    
    NSString *signature = [NSString stringWithFormat:@"%@.%@.%ld", relativeUrl, user, timestamp];
    NSString *signatureHash = [SecurityManager hashString:signature withSalt:password];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestedUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"%ld", timestamp] forHTTPHeaderField:@"QRAuth_timestamp"];
    [request setValue:signatureHash forHTTPHeaderField:@"QRAuth_signature"];
    [request setValue:user forHTTPHeaderField:@"QRAuth_username"];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

- (NSString *)fetchUserName
{
    return [SecurityManager loadUserName];
}

- (NSString *)fetchPasswordForUser:(NSString *)userName
{
    return [SecurityManager loadPasswordForUser:userName];
}

@end
