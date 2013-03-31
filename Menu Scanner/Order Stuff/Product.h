//
//  Product.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 05.12.12.
//  Copyright (c) 2012 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Category;

@interface Product : NSObject
@property (strong, nonatomic) NSNumber *productID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descr;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *imageURL;

@property (strong, nonatomic) Category *category;
@end
