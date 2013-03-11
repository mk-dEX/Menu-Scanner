//
//  StringFormatter.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "StringFormatter.h"

@implementation StringFormatter

+ (NSNumberFormatter *)numberFormatter
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return formatter;
}

+ (NSNumberFormatter *)currencyFormatter
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return formatter;
}

+ (NSDateFormatter *)timeFormatter
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    return formatter;
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    return formatter;
}

@end
