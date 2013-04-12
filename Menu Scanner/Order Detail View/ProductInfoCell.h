//
//  ProductInfoCell.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 22.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *descr;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@end
