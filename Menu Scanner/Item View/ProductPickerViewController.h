//
//  NamePickerViewController.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCollectionDownloader.h"
#import "Product.h"

@interface ProductPickerViewController : UITableViewController <ProductCollectionDownloaderDelegate>
@property (strong, nonatomic) Product *selectedProduct;
@property (weak, nonatomic) NSNumber *categoryID;
@end
