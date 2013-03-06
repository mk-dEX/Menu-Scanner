//
//  Product.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 05.12.12.
//  Copyright (c) 2012 Marc Kirchmann. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize name;
@synthesize descr;
@synthesize unit;
@synthesize price;
@synthesize count;
@synthesize imageURL;

- (id) initWithName:(NSString *)productName price:(NSNumber *)productPrice count:(NSNumber *)productCount
{
    self = [super init];
    if (self) {
        self.name = productName;
        self.price = productPrice;
        self.count = productCount;
    }
    return self;
}
@end
