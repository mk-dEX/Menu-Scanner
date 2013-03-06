//
//  StringFormatter.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "StringFormatter.h"

@interface StringFormatter ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic) NSNumberFormatter *priceFormatter;
@end

@implementation StringFormatter

@synthesize dateFormatter;
@synthesize timeFormatter;
@synthesize priceFormatter;

- (id)init
{
    if (self = [super init])
    {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        timeFormatter = [NSDateFormatter new];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        
        priceFormatter = [NSNumberFormatter new];
        [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return self;
}


- (NSString *)currencyString:(NSNumber *)original
{
    return [priceFormatter stringFromNumber:original];
}

- (NSString *)timeString:(NSDate *)original
{
    return [timeFormatter stringFromDate:original];
}

- (NSString *)dateString:(NSDate *)original
{
    return [dateFormatter stringFromDate:original];
}

- (NSDate *)dateFromString:(NSString *)date
{
    return [dateFormatter dateFromString:date];
}

@end
