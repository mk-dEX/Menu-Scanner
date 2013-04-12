//
//  RESTAuthorization.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 30.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTAuthentication.h"

@implementation RESTAuthentication
@synthesize code;
@synthesize message;

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@] %@", code, message];
}

@end
