//
//  SecureRESTConnection.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@interface SecureRESTConnection : RESTConnection
- (NSURLRequest *)secureRequestForURL:(NSString *)relativeURL
                               method:(NSString *)httpMethod
                                 name:(NSString *)user
                             password:(NSString *)password;
- (NSURLRequest *)secureRequestUsingKeychainForURL:(NSString *)relativeURL
                                            method:(NSString *)httpMethod;
@end