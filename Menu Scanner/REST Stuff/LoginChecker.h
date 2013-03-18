//
//  LoginChecker.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@interface LoginChecker : SecureRESTConnection
- (BOOL)authenticateWithPassword:(NSString *)password forName:(NSString *)user;
@end
