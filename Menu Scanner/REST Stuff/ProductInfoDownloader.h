//
//  ProductInfoDownloader.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import "RESTConnection.h"

@class ProductInfoDownloader;
@protocol ProductInfoDownloaderDelegate
- (void)download:(ProductInfoDownloader *)download didFinishWithOrder:(Order *)order;
- (void)download:(ProductInfoDownloader *)download didReceiveInvalidData:(id)data;
@end

@interface ProductInfoDownloader : RESTConnection
@property (weak) id<ProductInfoDownloaderDelegate> delegate;
- (BOOL) startDownloadForOrderHash:(NSString *)hash;
@end
