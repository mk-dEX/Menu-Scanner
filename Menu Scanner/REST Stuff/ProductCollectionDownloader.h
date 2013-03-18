//
//  NameCollectionDownloader.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@class ProductCollectionDownloader;
@protocol ProductCollectionDownloaderDelegate
- (void)download:(ProductCollectionDownloader *)download didFinishWithProductCollection:(NSDictionary *)products;
@end

@interface ProductCollectionDownloader : RESTConnection
@property (weak, nonatomic) id<ProductCollectionDownloaderDelegate> delegate;
- (BOOL)downloadProductCollection;
- (BOOL)downloadProductCollectionWithId:(NSNumber *)categoryId;
@end
