//
//  OrderManager.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoDownloader.h"
#import "OrderRefCollectionDownloader.h"
#import "OrderCollectionDownloader.h"
#import "OrderUpdater.h"

@class OrderManager;
@protocol OrderManagerDelegate
- (void)modelDidUpdate;
- (void)selectedOrderDidChange:(Order *)newSelectedOrder atIndex:(NSUInteger)newSelectedIndex;
@end

@interface OrderManager : NSObject <ProductInfoDownloaderDelegate, OrderRefCollectionDownloaderDelegate, OrderCollectionDownloaderDelegate>

@property (weak) id<OrderManagerDelegate> delegate;

+ (OrderManager *)sharedInstance;

- (void)addOrder:(Order *)order;
- (void)addOrderByHash:(NSString *)orderHash;
- (void)removeOrder:(Order *)order;
- (void)resetManager;
- (void)updateOrders;

- (NSArray *)orders;
- (Order *)orderAtIndex:(NSUInteger)index;
- (BOOL)didScanOrderWithID:(NSNumber *)orderID;

- (void)setFilter:(NSString *)filter;
- (void)resetFilter;
@end
