//
//  ProductInfoDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductInfoDownloader.h"
#import "Product.h"
#import "StringFormatter.h"
#import "MenuScannerConstants.h"


@implementation ProductInfoDownloader

@synthesize delegate;

- (BOOL)downloadOrderWithHash:(NSString *)hash
{
    NSURL *requestedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", REST_ORDERS, hash]
                                 relativeToURL:self.baseURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestedURL
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:REQUEST_TIMEOUT];
    return request && [self executeRequest:request];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSMutableDictionary *products = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    for (NSDictionary *product in [self productListFromJson:json])
    {
        NSString *scannedCategory;
        Product *scannedProduct;
        
        if ((scannedCategory = [self categoryFromJson:product]) && (scannedProduct = [self productFromJson:product])) {
            if (![categories containsObject:scannedCategory]) {
                [categories addObject:scannedCategory];
                [products setObject:[NSMutableArray new] forKey:scannedCategory];
            }
            [[products objectForKey:scannedCategory] addObject:scannedProduct];
        }        
    }
    
    if (delegate)
    {
        Order *scannedOrder = [self orderFromJson:json];
        if (scannedOrder) {
            scannedOrder.categories = categories;
            scannedOrder.products = products;
            [self.delegate download:self didFinishWithOrder:scannedOrder];
        }
        else {
            [delegate download:self didReceiveInvalidData:json];
        }
    }
}

- (Order *)orderFromJson:(id)jsonResponse
{
    Order *order = [Order new];
    
    @try {
        order.totalCosts = [jsonResponse objectForKey:PRODUCT_INFO_DOWNLOADER_TOTAL_COSTS];
        order.orderID = [[StringFormatter numberFormatter] numberFromString:[jsonResponse objectForKey:PRODUCT_INFO_DOWNLOADER_ID]];
        order.timestamp = [NSDate dateWithTimeIntervalSince1970:[[jsonResponse objectForKey:PRODUCT_INFO_DOWNLOADER_TIME] floatValue]];
    }
    @catch (NSException *exception) {
        order = nil;
    }
    @finally {
        return order;
    }
}

- (NSArray *)productListFromJson:(id)jsonResponse
{
    NSArray *products;
    @try {
        products = [jsonResponse objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCTS];
    }
    @catch (NSException *exception) {
        products = @[];
    }
    @finally {
        return products;
    }
}

- (NSString *)categoryFromJson:(NSDictionary *)jsonProduct
{
    NSString *category;
    
    @try {
        category = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_CATEGORY];
    }
    @catch (NSException *exception) {
        category = nil;
    }
    @finally {
        return category;
    }
}

- (Product *)productFromJson:(NSDictionary *)jsonProduct
{
    Product *product = [Product new];
    
    NSNumberFormatter *floatFormatter = [StringFormatter numberFormatter];
    [floatFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    @try {
        product.name = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_NAME];
        product.price = [floatFormatter numberFromString:[jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_PRICE]];
        product.count = [[StringFormatter numberFormatter] numberFromString:[jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_COUNT]];
        product.descr = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_DESCR];
        product.unit = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_UNIT];
        product.imageURL = [jsonProduct objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_IMAGE];
    }
    @catch (NSException *exception) {
        product = nil;
    }
    @finally {
        return product;
    }
}
@end
