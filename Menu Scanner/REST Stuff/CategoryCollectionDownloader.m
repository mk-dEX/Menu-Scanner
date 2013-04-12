//
//  CategoryCollectionDownloader.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "CategoryCollectionDownloader.h"
#import "MenuScannerConstants.h"
#import "Category.h"
#import "StringFormatter.h"

@implementation CategoryCollectionDownloader

@synthesize delegate;

- (BOOL)downloadCategoryCollection
{
    NSURL *requestedURL = [NSURL URLWithString:REST_CATEGORIES
                                 relativeToURL:self.baseURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestedURL
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:REQUEST_TIMEOUT];
    return request && [self executeRequest:request];
}

#pragma mark - JSON Processing

- (void) processData:(id)json
{
    NSMutableArray *categories = [NSMutableArray new];
    
    for (NSDictionary *category in json)
    {   
        Category *scannedCategory = [JSONMapper categoryFromJson:category];
        
        if (scannedCategory) {
            [categories addObject:scannedCategory];
        }
    }
    
    if (delegate) {
        [delegate download:self didFinishWithCategoryCollection:categories];
    }
}

@end
