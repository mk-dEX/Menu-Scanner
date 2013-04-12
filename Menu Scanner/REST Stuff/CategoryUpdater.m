//
//  CategoryUpdater.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "CategoryUpdater.h"
#import "MenuScannerConstants.h"
#import "StringFormatter.h"

@implementation CategoryUpdater

- (BOOL)addCategory:(Category *)newCategory
{
    NSString *requestedURL = REST_CATEGORIES;
    return [self createRequestForURL:requestedURL withCategory:newCategory method:@"POST"];
}


- (BOOL)updateCategoryWithID:(NSNumber *)categoryID
         withPatchedCategory:(Category *)patchedCategory
{
    NSString *requestedURL = [NSString stringWithFormat:@"%@/%@", REST_CATEGORIES, [[StringFormatter numberFormatter] stringFromNumber:categoryID]];
    return [self createRequestForURL:requestedURL withCategory:patchedCategory method:@"PUT"];
}


- (BOOL)createRequestForURL:(NSString *)relativeURL
               withCategory:(Category *)category
                     method:(NSString *)httpMethod
{
    NSDictionary *categoryName = @{@"name": category.name};
    NSError *error;
    NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:categoryName
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest *secureRequest = (NSMutableURLRequest *)[self secureRequestUsingKeychainForURL:relativeURL method:httpMethod];
    if (secureRequest && jsonBody) {
        [secureRequest setHTTPBody:jsonBody];
        [secureRequest setValue:@"application/json"
             forHTTPHeaderField:@"Content-Type"];
        return [self executeRequest:secureRequest];
    }
    
    return NO;
}

@end
