//
//  OrderCollectionDownloader.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@class OrderRefCollectionDownloader;
@protocol OrderRefCollectionDownloaderDelegate
- (void) download:(OrderRefCollectionDownloader *)download didFinishWithOrderRefCollection:(NSArray *)orderRefs;
@end

@interface OrderRefCollectionDownloader : SecureRESTConnection
@property (weak) id<OrderRefCollectionDownloaderDelegate> delegate;
- (BOOL)downloadOrderRefCollection;
@end
