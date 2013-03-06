//
//  OrderRef.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderRef.h"

@implementation OrderRef
@synthesize orderId;
@synthesize orderHash;
@synthesize orderTime;

- (id) initWithHash:(NSString *)oHash id:(NSString *)oId time:(NSDate *)oTime
{
    if (self = [super init]) {
        orderId = oId;
        orderHash = oHash;
        orderTime = oTime;
    }
    return self;
}

@end
