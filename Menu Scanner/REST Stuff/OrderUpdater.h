//
//  OrderUpdater.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 13.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@interface OrderUpdater : SecureRESTConnection
- (BOOL)removeOrderWithID:(NSNumber *)orderID;
@end
