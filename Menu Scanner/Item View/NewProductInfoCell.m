//
//  CategoryCell.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "NewProductInfoCell.h"

@implementation NewProductInfoCell

@synthesize delegate;
@synthesize name;
@synthesize productProperty;

- (IBAction)didSelectCategory:(id)sender
{
    if (delegate) {
        [delegate cell:self didSelect:productProperty];
    }
}
@end
