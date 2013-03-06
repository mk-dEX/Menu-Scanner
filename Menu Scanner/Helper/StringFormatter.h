//
//  StringFormatter.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 27.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFormatter : NSObject

- (NSString *)currencyString:(NSNumber *)original;
- (NSString *)timeString:(NSDate *)original;
- (NSString *)dateString:(NSDate *)original;

- (NSDate *)dateFromString:(NSString *)date;

@end
