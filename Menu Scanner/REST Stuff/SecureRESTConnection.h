//
//  SecureRESTConnection.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@interface SecureRESTConnection : RESTConnection
- (NSURLRequest *)secureRequestForUrl:(NSURL *)requestedUrl method:(NSString *)httpMethod withName:(NSString *)user andPassword:(NSString *)password;
@end