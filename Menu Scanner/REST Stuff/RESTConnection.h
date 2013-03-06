//
//  RESTConnection.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 17.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTConnection : NSObject <NSURLConnectionDelegate>
- (Boolean) executeRequest:(NSURLRequest *)request;
@end
