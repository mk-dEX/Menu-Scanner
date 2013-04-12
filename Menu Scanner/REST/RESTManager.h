//
//  RESTManager.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 31.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class RESTManager;
@protocol RESTManagerAuthenticationDelegate
- (void)loginWithUser:(NSString *)user password:(NSString *)password hasResult:(BOOL)isValid;
@end

@interface RESTManager : NSObject

@property (weak, nonatomic) id<RESTManagerAuthenticationDelegate> authenticationDelegate;

+ (RESTManager *)sharedInstance;

- (BOOL)loginWithUser:(NSString *)user
             password:(NSString *)password;

@end
