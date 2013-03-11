//
//  LoginChecker.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@class LoginChecker;
@protocol LoginCheckerDelegate
- (void)loginIsValid:(BOOL)valid;
@end

@interface LoginChecker : SecureRESTConnection
@property (weak) id<LoginCheckerDelegate> delegate;
- (void)authenticate;
- (void)authenticateWithPassword:(NSString *)password forName:(NSString *)user;
@end
