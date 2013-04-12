//
//  CategoryPickerViewController.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "CategoryCollectionDownloader.h"

@interface CategoryPickerViewController : UITableViewController <CategoryCollectionDownloaderDelegate>
@property (strong, nonatomic) Category *selectedCategory;
@end
