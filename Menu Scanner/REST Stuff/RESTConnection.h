//
//  RESTConnection.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 17.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONMapper.h"

typedef enum {
    HttpCodeSuccessful,
    HttpCodeNotAuthorized,
    HttpCodeServiceNotAvailable,
    HttpCodeUnknown,
    NoCode
} HttpCode;

@class RESTConnection;
@protocol RESTConnectionDelegate
- (void)connection:(RESTConnection *)connection didFinishWithCode:(HttpCode)code;
- (void)connection:(RESTConnection *)connection didFailWithError:(NSError *)error;
@end

@interface RESTConnection : NSObject <NSURLConnectionDelegate>
@property (weak, nonatomic) id<RESTConnectionDelegate>httpDelegate;
@property (strong, nonatomic) NSURL *baseURL;
- (BOOL)executeRequest:(NSURLRequest *)request;
@end
