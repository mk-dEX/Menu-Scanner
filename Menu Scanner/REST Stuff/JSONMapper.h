//
//  JSONMapper.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 06.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Product.h"
#import "Order.h"
#import "Category.h"
#import "OrderRef.h"

@interface JSONMapper : NSObject
+ (NSArray *)productListFromJson:(NSDictionary *)jsonProductList;
+ (Product *)productFromJson:(NSDictionary *)jsonProduct;
+ (Category *)categoryFromJson:(NSDictionary *)jsonCategory;
+ (OrderRef *)orderReferenceFromJson:(NSDictionary *)jsonOrderRef;
+ (Order *)orderFromJson:(id)jsonOrder;
@end
