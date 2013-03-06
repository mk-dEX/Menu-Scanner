//
//  LoginChecker.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@class LoginChecker;
@protocol LoginCheckerDelegate
- (void)loginIsValid:(BOOL)valid;
@end

@interface LoginChecker : RESTConnection
@property (weak) id<LoginCheckerDelegate> delegate;
- (void)authenticateWithUserName:(NSString *)name andPassword:(NSString *)key;
@end
