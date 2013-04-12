//
//  RESTDownloader.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 30.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RESTDownloader : NSObject

- (BOOL)loginWithUser:(NSString *)user
             password:(NSString *)password
              success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)loadOrders;

@end
