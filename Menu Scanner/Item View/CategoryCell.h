//
//  CategoryCell.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@class CategoryCell;
@protocol CategoryCellCollectionDelegate
- (void)cell:(CategoryCell *)cell didSelectCategory:(Category *)category;
@end

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) id<CategoryCellCollectionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *name;
@property (strong, nonatomic) Category *category;
@end
