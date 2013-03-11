//
//  StringFormatter.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFormatter : NSObject

+ (NSNumberFormatter *)numberFormatter;
+ (NSNumberFormatter *)currencyFormatter;
+ (NSDateFormatter *)timeFormatter;
+ (NSDateFormatter *)dateFormatter;

@end
