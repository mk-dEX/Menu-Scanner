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

- (NSArray *)categories
{
    return [categories sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray *)productsOfCategory:(NSString *)category
{
    NSArray *productsOfCategory = [products objectForKey:category];
    return [productsOfCategory sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
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
