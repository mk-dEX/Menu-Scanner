//
//  CategoryUpdater.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@interface CategoryUpdater : SecureRESTConnection
- (BOOL)addCategory:(Category *)newCategory;
- (BOOL)updateCategoryWithID:(NSNumber *)categoryID withPatchedCategory:(Category *)patchedCategory;
@end
