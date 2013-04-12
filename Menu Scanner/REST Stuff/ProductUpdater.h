//
//  ItemUpdater.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@interface ProductUpdater : SecureRESTConnection
- (BOOL)addProduct:(Product *)newProduct withImage:(UIImage *)newProductImage;
- (BOOL)patchProductWithID:(NSNumber *)productID withPatchedProduct:(Product *)patchedProduct;
@end
