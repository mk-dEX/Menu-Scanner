//
//  ProductInfoDownloader.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductInfoDownloader.h"
#import "Product.h"

NSString const *SERVER_URL          = @"http://api.codingduck.de/orders/";
NSString const *TOTAL_COSTS         = @"total";
NSString const *PRODUCT_ITEMS       = @"items";
NSString const *CATEGORY_NAME       = @"category";
NSString const *PRODUCT_NAME        = @"name";
NSString const *PRODUCT_DESCRIPTION = @"desc";
NSString const *PRODUCT_COUNT       = @"count";
NSString const *PRODUCT_UNIT        = @"unit";
NSString const *PRODUCT_PRICE       = @"price";
NSString const *PRODUCT_TIME        = @"orderTime";
NSString const *PRODUCT_IMAGE       = @"imageURL";


@implementation ProductInfoDownloader

@synthesize delegate;

- (void) startDownloadForOrderHash:(NSString *)hash
{
    NSURL *targetURL = [NSURL URLWithString:[SERVER_URL stringByAppendingString:hash]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [self executeRequest:request];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSNumber *totalCosts = @0;
    NSMutableDictionary *products = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    totalCosts = [json objectForKey:TOTAL_COSTS];
    [categories addObject:[totalCosts stringValue]];
    [products setObject:[NSMutableArray new] forKey:[totalCosts stringValue]];
    
    NSString *timestamp = [json objectForKey:PRODUCT_TIME];
    NSArray *jsonProducts = [json objectForKey:PRODUCT_ITEMS];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    
    NSNumberFormatter *floatFormatter = [[NSNumberFormatter alloc] init];
    [floatFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [floatFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *category;
    for (NSDictionary *product in jsonProducts)
    {
        category = [product objectForKey:CATEGORY_NAME];
        
        if (![categories containsObject:category])
        {
            [categories addObject:category];
            [products setObject:[NSMutableArray new] forKey:category];
        }
        
        NSString *price = [product objectForKey:PRODUCT_PRICE];
        NSString *count = [product objectForKey:PRODUCT_COUNT];
                
        Product *p = [[Product alloc]
                      initWithName:[product objectForKey:PRODUCT_NAME]
                      price:[floatFormatter numberFromString:price]
                      count:[numberFormatter numberFromString:count]];

        p.descr = [product objectForKey:PRODUCT_DESCRIPTION];
        p.unit = [product objectForKey:PRODUCT_UNIT];
        p.imageURL = [product objectForKey:PRODUCT_IMAGE];
        
        [[products objectForKey:category] addObject:p];
    }
    
    if (self.delegate)
    {
        Order *o = [Order new];
        o.totalCosts = totalCosts;
        o.categories = categories;
        o.products = products;
        o.timestamp = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
        [self.delegate download:self didFinishWithOrder:o];
    }
}

@end
