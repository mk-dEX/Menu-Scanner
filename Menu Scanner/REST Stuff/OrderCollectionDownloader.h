//
//  OrderCollectionDownloader.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 06.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecureRESTConnection.h"

@class OrderCollectionDownloader;
@protocol OrderCollectionDownloaderDelegate
- (void)download:(OrderCollectionDownloader *)download didFinishWithOrderCollection:(NSArray *)orders;
@end

@interface OrderCollectionDownloader : SecureRESTConnection
@property (weak, nonatomic) id<OrderCollectionDownloaderDelegate> delegate;
- (BOOL)downloadOrderCollectionWithHashes:(NSArray *)orderHashes;
@end
