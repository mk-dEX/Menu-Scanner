//
//  OrderRef.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderRef : NSObject
@property (strong, nonatomic) NSNumber *orderId;
@property (strong, nonatomic) NSString *orderHash;
@property (strong, nonatomic) NSDate *orderTime;
@end
