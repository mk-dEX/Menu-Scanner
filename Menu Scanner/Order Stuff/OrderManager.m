//
//  OrderManager.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "OrderManager.h"
#import "StringFormatter.h"
#import "OrderRef.h"

@interface OrderManager ()
@property (strong) NSMutableArray *registeredOrders;
@property (strong) NSMutableArray *filteredOrders;
@property (strong) NSString *filterString;
@property (assign) BOOL isFiltered;
@property (assign) unsigned int downloadsLeft;
@property (strong) OrderCollectionDownloader *orderCollectionDownloader;
@property (strong) ProductInfoDownloader *productInfoDownloader;
@property (strong) StringFormatter *formatter;
@end

@implementation OrderManager
static OrderManager *_instance;

@synthesize delegate;

@synthesize registeredOrders;
@synthesize filteredOrders;
@synthesize filterString;
@synthesize isFiltered;
@synthesize downloadsLeft;
@synthesize orderCollectionDownloader;
@synthesize productInfoDownloader;
@synthesize formatter;

#pragma mark - Singleton Management

+ (id)alloc
{
    @synchronized([OrderManager class])
    {
        NSAssert(_instance == nil, @"Error allocating second OrderManager.");
        _instance = [super alloc];
        return _instance;
    }
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        registeredOrders = [NSMutableArray new];
        isFiltered = false;
        downloadsLeft = 0;
        formatter = [StringFormatter new];
        
        orderCollectionDownloader = [OrderCollectionDownloader new];
        orderCollectionDownloader.delegate = self;
        productInfoDownloader = [ProductInfoDownloader new];
        productInfoDownloader.delegate = self;
    }
    return self;
}

+ (OrderManager *)getInstance
{
    @synchronized([OrderManager class])
    {
        if (!_instance)
            _instance = [[self alloc] init];
        return _instance;
    }
    return nil;
}

#pragma mark - Order Management

- (void)addOrder:(Order *)newOrder
{
    [registeredOrders addObject:newOrder];
    if (isFiltered && [self order:newOrder appliesToFilter:filterString])
    {
        [filteredOrders addObject:newOrder];
    }
}

- (NSArray *)orders
{
    return isFiltered ? filteredOrders : registeredOrders;
}

- (Order *)orderAtIndex:(NSUInteger)index
{
    NSArray *orderList = [self orders];
    
    if (index >= orderList.count) {
        return nil;
    }
    
    return [orderList objectAtIndex:index];
}

- (void)updateOrders
{
    [orderCollectionDownloader startDownload];
}

- (void)sortOrders
{    
    NSArray *sortedRegisteredOrders = [registeredOrders sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Order *)a timestamp];
        NSDate *second = [(Order *)b timestamp];
        return [second compare:first];
    }];
    
    registeredOrders = [NSMutableArray arrayWithArray:sortedRegisteredOrders];
    
    NSArray *sortedFilteredOrders = [filteredOrders sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Order *)a timestamp];
        NSDate *second = [(Order *)b timestamp];
        return [second compare:first];
    }];
    
    filteredOrders = [NSMutableArray arrayWithArray:sortedFilteredOrders];
}

#pragma mark - Order Search

- (void)setFilter:(NSString *)filter
{
    filterString = filter;
    isFiltered = YES;
    
    filteredOrders = [NSMutableArray new];
    
    [self filterOrders];
    [self notifyDelegate];
}

- (void)resetFilter
{
    isFiltered = NO;
    [self notifyDelegate];
}

- (void)filterOrders
{
    Boolean isDate = ([filterString rangeOfString:@"."].location != NSNotFound) || ([filterString rangeOfString:@"/"].location != NSNotFound);
    NSDate *filterDate;
    
    if (isDate) {
        filterDate = [formatter dateFromString:filterString];
        if (!filterDate) {
            return;
        }
    }
    
    for (Order *o in registeredOrders) {
        
        if (isDate ? [self order:o checkDate:filterDate] : [self order:o checkItems:filterString]) {
            [filteredOrders addObject:o];
        }
    }
}

- (Boolean)order:(Order *)order appliesToFilter:(NSString *)filter
{
    Boolean isDate = ([filter rangeOfString:@"."].location != NSNotFound);
    
    if (!isDate) {
        return [self order:order checkItems:filter];
    }

    NSDate *filterDate = [formatter dateFromString:filter];
    return filterDate != nil && [self order:order checkDate:filterDate];
}

- (Boolean)order:(Order *)order checkDate:(NSDate *)date
{
    return [self isSameDay:date otherDay:order.timestamp];
}

- (Boolean)order:(Order *)order checkItems:(NSString *)productName
{
    for (NSString *category in order.categories)
    {
        for (Product *product in [order.products objectForKey:category])
        {
            NSRange nameRange = [product.name rangeOfString:productName options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (Boolean)isSameDay:(NSDate *)date1 otherDay:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}

#pragma mark - OrderCollectionDownloader Delegate

- (void) download:(OrderCollectionDownloader *)download didFinishWithOrderCollection:(NSArray *)orderRefs
{
    downloadsLeft = [orderRefs count];
        
    for (OrderRef *or in orderRefs)
    {
        [productInfoDownloader startDownloadForOrderHash:or.orderHash];
    }
}

#pragma mark - ProductInfoDownloader Delegate

- (void) download:(ProductInfoDownloader *)download didFinishWithOrder:(Order *)order
{
    @synchronized(order)
    {
        if (![registeredOrders containsObject:order])
        {
            [self addOrder:order];
        }
        downloadsLeft -= 1;
    }
    
    if (downloadsLeft <= 0)
    {
        [self sortOrders];
        [self notifyDelegate];
    }
}

#pragma mark - Notifications

- (void)notifyDelegate
{
    if (delegate) {
        [delegate modelDidUpdate];
    }
}

@end
