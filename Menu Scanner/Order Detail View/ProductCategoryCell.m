//
//  ProductCategoryCell.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 05.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "ProductCategoryCell.h"

@implementation ProductCategoryCell

@synthesize collectionView;

- (void)reloadData
{
    [collectionView reloadData];
}

@end
