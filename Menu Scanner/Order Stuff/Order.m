//
//  Order.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "Order.h"

@implementation Order

@synthesize categories;
@synthesize products;
@synthesize totalCosts;
@synthesize orderID;
@synthesize timestamp;

- (id) init {
    self = [super init];
    if (self) {
        categories = [NSArray new];
        products = [NSDictionary new];
        totalCosts = @0;
        orderID = @0;
    }
    return self;
}

- (NSInteger) numberOfCategories
{
    return categories.count;
}

- (NSInteger) numberOfProductsInCategory:(NSString *)category
{
    NSArray *catProducts = [products objectForKey:category];
    return [catProducts count];
}

- (Product *) productAtIndex:(NSInteger)index inCategory:(NSString *)category
{
    return [[products objectForKey:category] objectAtIndex:index];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.orderID isEqualToNumber:((Order *)other).orderID];
}

@end
