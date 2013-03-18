//
//  CategoryCell.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize delegate;
@synthesize name;
@synthesize category;

- (IBAction)didSelectCategory:(id)sender
{
    if (delegate) {
        [delegate cell:self didSelectCategory:category];
    }
}
@end
