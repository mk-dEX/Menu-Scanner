//
//  OrderRef.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderRef : NSObject
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *orderHash;
@property (strong, nonatomic) NSDate *orderTime;
- (id) initWithHash:(NSString *)oHash id:(NSString *)oId time:(NSDate *)oTime;
@end
