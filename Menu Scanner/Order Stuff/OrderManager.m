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
@property (strong, nonatomic) NSMutableDictionary *registeredOrders;
@property (strong, nonatomic) NSMutableArray *filteredOrderIDs;
@property (strong, nonatomic) NSMutableArray *scannedOrderIDs;

@property (strong, nonatomic) NSString *filterString;
@property (assign, nonatomic) BOOL isFiltered;

@property (strong, nonatomic) OrderRefCollectionDownloader *orderRefCollectionDownloader;
@property (strong, nonatomic) OrderCollectionDownloader *orderCollectionDownloader;
@property (strong, nonatomic) OrderUpdater *orderUpdater;
@property (strong, nonatomic) ProductInfoDownloader *productInfoDownloader;
@end

@implementation OrderManager
static OrderManager *_instance;

@synthesize delegate;

@synthesize registeredOrders;
@synthesize filteredOrderIDs;
@synthesize scannedOrderIDs;

@synthesize filterString;
@synthesize isFiltered;

@synthesize orderRefCollectionDownloader;
@synthesize orderCollectionDownloader;
@synthesize productInfoDownloader;
@synthesize orderUpdater;

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
        registeredOrders = [NSMutableDictionary new];
        filteredOrderIDs = [NSMutableArray new];
        scannedOrderIDs = [NSMutableArray new];
        
        isFiltered = false;
        
        orderRefCollectionDownloader = [OrderRefCollectionDownloader new];
        orderRefCollectionDownloader.delegate = self;
        orderCollectionDownloader = [OrderCollectionDownloader new];
        orderCollectionDownloader.delegate = self;
        productInfoDownloader = [ProductInfoDownloader new];
        productInfoDownloader.delegate = self;
        orderUpdater = [OrderUpdater new];
    }
    return self;
}

+ (OrderManager *)sharedInstance
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

- (void)addOrder:(Order *)order
{
    NSNumber *orderID = order.orderID;
    [registeredOrders setObject:order forKey:orderID];
    if (isFiltered && [self order:order appliesToFilter:filterString])
    {
        [filteredOrderIDs addObject:orderID];
    }
}

- (void)addOrderByHash:(NSString *)orderHash
{
    [productInfoDownloader downloadOrderWithHash:orderHash];
}

- (void)removeOrder:(Order *)order
{
    NSNumber *orderID = order.orderID;
    [registeredOrders removeObjectForKey:orderID];
    [filteredOrderIDs removeObject:orderID];
    [scannedOrderIDs removeObject:orderID];
    
    [orderUpdater removeOrderWithID:orderID];
    [self notifyDelegate];
}

- (void)resetManager
{
    [registeredOrders removeAllObjects];
    [filteredOrderIDs removeAllObjects];
    [scannedOrderIDs removeAllObjects];
    
    [self notifyDelegate];
}

- (NSArray *)orders
{
    NSMutableArray *unsortedOrders;
    if (!isFiltered) {
        unsortedOrders = [NSMutableArray arrayWithArray:[registeredOrders allValues]];
    }
    else {
        unsortedOrders = [[NSMutableArray alloc] initWithCapacity:filteredOrderIDs.count];
        for (NSNumber *filteredOrderID in filteredOrderIDs) {
            Order *o;
            if ((o = [registeredOrders objectForKey:filteredOrderID]) != nil) {
                [unsortedOrders addObject:o];
            }
        }
    }
    return [unsortedOrders sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Order *)a timestamp];
        NSDate *second = [(Order *)b timestamp];
        return [second compare:first];
    }];
}

- (Order *)orderAtIndex:(NSUInteger)index
{
    NSArray *orderList = [self orders];
    
    if (index >= orderList.count) {
        return nil;
    }
    
    return [orderList objectAtIndex:index];
}

- (NSUInteger)indexOfOrder:(Order *)order
{
    NSNumber *orderID = order.orderID;
    NSArray *allOrdersSorted = [self orders];
    NSUInteger currentIndex = 0;
    for (Order *o in allOrdersSorted) {
        if ([o.orderID isEqualToNumber:orderID]) {
            return currentIndex;
        }
        currentIndex += 1;
    }
    return 0;
}

- (BOOL)didScanOrderWithID:(NSNumber *)orderID
{
    return [scannedOrderIDs containsObject:orderID] && [[registeredOrders allKeys] containsObject:orderID];
}

- (void)updateOrders
{
    [orderRefCollectionDownloader downloadOrderRefCollection];
}


#pragma mark - Order Search

- (void)setFilter:(NSString *)filter
{
    if ([filter length] == 0) {
        [self resetFilter];
    }
    else
    {
        filterString = filter;
        isFiltered = YES;
    
        [self filterOrders];
        [self notifyDelegate];
    }
}

- (void)resetFilter
{
    isFiltered = NO;
    [self notifyDelegate];
}

- (void)filterOrders
{
    filteredOrderIDs = [NSMutableArray array];
    for (Order *o in [registeredOrders allValues])
    {
        if ([self order:o appliesToFilter:filterString])
        {
            [filteredOrderIDs addObject:o.orderID];
        }
    }
}

- (BOOL)order:(Order *)order appliesToFilter:(NSString *)filter
{
    return [self filterIsDateFilter:filter] ? [self order:order appliesToDateFilter:filter] : [self order:order appliesToProductFilter:filter];
}

- (BOOL)filterIsDateFilter:(NSString *)filter
{
    return ([filterString rangeOfString:@"."].location != NSNotFound) || ([filterString rangeOfString:@"/"].location != NSNotFound);
}

- (BOOL)order:(Order *)order appliesToDateFilter:(NSString *)filterDate
{
    NSDate *date = [[StringFormatter dateFormatter] dateFromString:filterDate];
    return date && [self order:order checkDate:date];
}

- (BOOL)order:(Order *)order appliesToProductFilter:(NSString *)productName
{
    return [self order:order checkItems:productName];
}


#pragma mark - Search filter comparisons

- (BOOL)order:(Order *)order checkDate:(NSDate *)date
{
    return [self isSameDay:date otherDay:order.timestamp];
}

- (BOOL)order:(Order *)order checkItems:(NSString *)productName
{
    for (NSString *category in [order categories])
    {
        for (Product *product in [order productsOfCategory:category])
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

- (BOOL)isSameDay:(NSDate *)date1 otherDay:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}


#pragma mark - Order reference downloader

- (void)download:(OrderRefCollectionDownloader *)download didFinishWithOrderRefCollection:(NSArray *)orderRefs
{
    NSMutableSet *localOrderIDs = [[NSMutableSet alloc] initWithArray:[registeredOrders allKeys]];
    NSMutableSet *downloadOrderIDs = [[NSMutableSet alloc] initWithCapacity:orderRefs.count];
    for (OrderRef *remoteOrderRef in orderRefs) {
        [downloadOrderIDs addObject:remoteOrderRef.orderID];
    }
    
    //Lösche später nur die IDs aus der lokalen Menge, die nicht in der aktuellsten Menge vorhanden sind
    NSMutableSet *obsoleteLocalOrderIDs = [[NSMutableSet alloc] initWithSet:localOrderIDs copyItems:YES];
    [obsoleteLocalOrderIDs minusSet:downloadOrderIDs];
    
    //Entferne alle IDs aus der Menge derer, die heruntergeladen werden sollen, aber bereits in der lokalen Menge vorhanden sind
    [downloadOrderIDs minusSet:localOrderIDs];
    
    //Aktualisiere die lokalen IDs
    [registeredOrders removeObjectsForKeys:[obsoleteLocalOrderIDs allObjects]];
    
    //Sammle die Hashes zu den IDs die heruntergeladen werden sollen
    NSMutableArray *downloadHashes = [NSMutableArray new];
    NSUInteger maxDownloads = [downloadOrderIDs count];
    for (OrderRef *remoteOrder in orderRefs)
    {
        if ([downloadHashes count] >= maxDownloads) {
            break;
        }
        if ([downloadOrderIDs containsObject:remoteOrder.orderID]) {
            [downloadHashes addObject:remoteOrder.orderHash];
        }
    }
    
    [orderCollectionDownloader downloadOrderCollectionWithHashes:downloadHashes];
}


#pragma mark - Order collection downloader

- (void)download:(OrderCollectionDownloader *)download didFinishWithOrderCollection:(NSArray *)orders
{
    for (Order *downloadedOrder in orders) {
        [self addOrder:downloadedOrder];
    }
    
    [self notifyDelegate];
}


#pragma mark - Product info downloader

- (void)download:(ProductInfoDownloader *)download didFinishWithOrder:(Order *)order
{
    [self addOrder:order];
    [scannedOrderIDs addObject:order.orderID];
    
    [self notifyDelegate];
    if (delegate) {
        [delegate selectedOrderDidChange:order atIndex:[self indexOfOrder:order]];
    }
}

- (void)download:(ProductInfoDownloader *)download didReceiveInvalidData:(id)data
{
}


#pragma mark - Notifications

- (void)notifyDelegate
{
    if (delegate) {
        [delegate modelDidUpdate];
    }
}

@end
