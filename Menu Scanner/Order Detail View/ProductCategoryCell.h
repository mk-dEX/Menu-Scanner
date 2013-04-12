//
//  ProductCategoryCell.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 05.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)reloadData;
@end
