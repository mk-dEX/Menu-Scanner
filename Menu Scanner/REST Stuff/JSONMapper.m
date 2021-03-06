//
//  JSONMapper.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 06.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "JSONMapper.h"

#import "MenuScannerConstants.h"
#import "StringFormatter.h"

@implementation JSONMapper

+ (NSArray *)productListFromJson:(NSDictionary *)jsonProductList
{
    NSArray *products;
    @try {
        products = [jsonProductList objectForKey:ORDER_PRODUCTS];
    }
    @catch (NSException *exception) {
        products = @[];
    }
    @finally {
        return products;
    }
}

+ (Product *)productFromJson:(NSDictionary *)jsonProduct
{
    Product *product = [Product new];
    
    NSNumberFormatter *floatFormatter = [StringFormatter numberFormatter];
    [floatFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    @try {
        product.productID = [jsonProduct objectForKey:PRODUCT_ID];
        product.name = [jsonProduct objectForKey:PRODUCT_NAME];
        product.descr = [jsonProduct objectForKey:PRODUCT_DESCR];
        product.unit = [jsonProduct objectForKey:PRODUCT_UNIT];
        product.imageURL = [jsonProduct objectForKey:PRODUCT_IMAGE];
        product.count = [[StringFormatter numberFormatter] numberFromString:[jsonProduct objectForKey:PRODUCT_COUNT]];
        
        NSString *priceString;
        if ((priceString = [jsonProduct objectForKey:PRODUCT_PRICE_DEFAULT]) != nil) {
            product.price = [floatFormatter numberFromString:priceString];
        }
        else if ((priceString = [jsonProduct objectForKey:PRODUCT_PRICE]) != nil) {
            product.price = [floatFormatter numberFromString:priceString];
        }
        
        Category *category = [Category new];
        category.name = [jsonProduct objectForKey:PRODUCT_CATEGORY];
        
        @try {
            category.categoryID = [[StringFormatter numberFormatter] numberFromString:[jsonProduct objectForKey:PRODUCT_CATEGORY_ID]];
        }
        @catch (NSException *exception) {
        }
        @finally {
            if (category) {
                product.category = category;
            }
        }
    }
    @catch (NSException *exception) {
        product = nil;
    }
    @finally {
        return product;
    }
}

+ (Category *)categoryFromJson:(NSDictionary *)jsonCategory
{
    Category *category = [Category new];
    
    @try {
        category.name = [jsonCategory valueForKey:CATEGORY_COLLECTION_NAME];
        category.categoryID = [[StringFormatter numberFormatter] numberFromString:[jsonCategory valueForKey:CATEGORY_COLLECTION_ID]];
    }
    @catch (NSException *exception) {
        category = nil;
    }
    @finally {
        return category;
    }
}

+ (OrderRef *)orderReferenceFromJson:(NSDictionary *)jsonOrderRef
{
    OrderRef *orderRef = [OrderRef new];
    
    @try {
        orderRef.orderHash = [jsonOrderRef objectForKey:ORDER_COLLECTION_HASH];
        orderRef.orderTime = [NSDate dateWithTimeIntervalSince1970:[[jsonOrderRef objectForKey:ORDER_COLLECTION_TIME] floatValue]];
        orderRef.orderID = [[StringFormatter numberFormatter] numberFromString:[jsonOrderRef objectForKey:ORDER_COLLECTION_ID]];
    }
    @catch (NSException *exception) {
        orderRef = nil;
    }
    @finally {
        return orderRef;
    }
}

+ (Order *)orderFromJson:(NSDictionary *)jsonOrder
{
    Order *order = [Order new];
    
    @try {
        order.totalCosts = [jsonOrder objectForKey:ORDER_TOTAL_COSTS];
        order.orderID = [[StringFormatter numberFormatter] numberFromString:[jsonOrder objectForKey:ORDER_ID]];
        order.timestamp = [NSDate dateWithTimeIntervalSince1970:[[jsonOrder objectForKey:ORDER_TIME] floatValue]];
    }
    @catch (NSException *exception) {
        order = nil;
    }
    @finally {
        return order;
    }
}

@end
