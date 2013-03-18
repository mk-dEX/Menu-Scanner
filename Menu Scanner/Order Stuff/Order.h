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
@property (strong, nonatomic) NSNumber *orderId;
@property (strong, nonatomic) NSDate *timestamp;

- (NSInteger) numberOfCategories;
- (NSInteger) numberOfProductsInCategory:(NSString *)category;
- (Product *) productAtIndex:(NSInteger)index inCategory:(NSString *)category;

@end
