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

- (void) startDownloadForOrderHash:(NSString *)hash
{
    NSURL *targetURL = [NSURL URLWithString:[PRODUCT_INFO_DOWNLOADER_URL stringByAppendingString:hash]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [self executeRequest:request];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSNumber *totalCosts = @0;
    NSNumber *orderId;
    NSMutableDictionary *products = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    totalCosts = [json objectForKey:PRODUCT_INFO_DOWNLOADER_TOTAL_COSTS];
    orderId = [json objectForKey:PRODUCT_INFO_DOWNLOADER_ID];
    [categories addObject:[totalCosts stringValue]];
    [products setObject:[NSMutableArray new] forKey:[totalCosts stringValue]];
    
    NSString *timestamp = [json objectForKey:PRODUCT_INFO_DOWNLOADER_TIME];
    NSArray *jsonProducts = [json objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCTS];
    
    NSNumberFormatter *floatFormatter = [StringFormatter numberFormatter];
    [floatFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *category;
    for (NSDictionary *product in jsonProducts)
    {
        category = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_CATEGORY];
        
        if (![categories containsObject:category])
        {
            [categories addObject:category];
            [products setObject:[NSMutableArray new] forKey:category];
        }
        
        NSString *price = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_PRICE];
        NSString *count = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_COUNT];
                
        Product *p = [[Product alloc]
                      initWithName:[product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_NAME]
                      price:[floatFormatter numberFromString:price]
                      count:[[StringFormatter numberFormatter] numberFromString:count]];

        p.descr = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_DESCR];
        p.unit = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_UNIT];
        p.imageURL = [product objectForKey:PRODUCT_INFO_DOWNLOADER_PRODUCT_IMAGE];
        
        [[products objectForKey:category] addObject:p];
    }
    
    if (self.delegate)
    {
        Order *o = [Order new];
        o.totalCosts = totalCosts;
        o.orderId = orderId;
        o.categories = categories;
        o.products = products;
        o.timestamp = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
        [self.delegate download:self didFinishWithOrder:o];
    }
}

@end
