//
//  SecurityManager.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityManager : NSObject

+ (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt;

+ (BOOL)storeUserName:(NSString *)name;
+ (NSString *)loadUserName;

+ (BOOL)storePassword:(NSString *)password forUser:(NSString *)user;
+ (NSString *)loadPasswordForUser:(NSString *)user;

+ (BOOL)storeRestorationFlag:(BOOL)restore;
+ (BOOL)loadRestorationFlag;
@end
