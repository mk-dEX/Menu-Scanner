//
//  Order.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Order : NSObject
@property (strong, nonatomic) NSDictionary *products;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSNumber *totalCosts;
@property (strong, nonatomic) NSNumber *orderID;
@property (strong, nonatomic) NSDate *timestamp;

- (NSArray *)categories;
- (NSArray *)productsOfCategory:(NSString *)category;
@end
