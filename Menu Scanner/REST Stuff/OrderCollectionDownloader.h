//
//  OrderCollectionDownloader.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@class OrderCollectionDownloader;
@protocol OrderCollectionDownloaderDelegate
- (void) download:(OrderCollectionDownloader *)download didFinishWithOrderCollection:(NSArray *)orderRefs;
@end

@interface OrderCollectionDownloader : RESTConnection
@property (weak) id<OrderCollectionDownloaderDelegate> delegate;
- (void) startDownload;
@end