//
//  OrderInfoCell.h
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 24.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *costs;
@property (strong, nonatomic) Order *order;
@end
