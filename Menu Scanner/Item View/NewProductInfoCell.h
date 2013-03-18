//
//  CategoryCell.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@class NewProductInfoCell;
@protocol NewProductInfoDelegate
- (void)cell:(NewProductInfoCell *)cell didSelect:(id)property;
@end

@interface NewProductInfoCell : UITableViewCell
@property (weak, nonatomic) id<NewProductInfoDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *name;
@property (strong, nonatomic) id productProperty;
@end
