//
//  OrderManager.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoDownloader.h"
#import "OrderCollectionDownloader.h"

@class OrderManager;
@protocol OrderManagerDelegate
- (void)modelDidUpdate;
@end


@interface OrderManager : NSObject <ProductInfoDownloaderDelegate, OrderCollectionDownloaderDelegate>

@property (weak) id<OrderManagerDelegate> delegate;

+ (OrderManager *)getInstance;

- (void)addOrder:(Order *)newOrder;
- (void)updateOrders;
- (NSArray *)orders;
- (Order *)orderAtIndex:(NSUInteger)index;

- (void)setFilter:(NSString *)filter;
- (void)resetFilter;
@end
