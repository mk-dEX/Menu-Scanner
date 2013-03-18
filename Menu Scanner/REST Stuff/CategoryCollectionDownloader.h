//
//  CategoryCollectionDownloader.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 18.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@class CategoryCollectionDownloader;
@protocol CategoryCollectionDownloaderDelegate
- (void)download:(CategoryCollectionDownloader *)download didFinishWithCategoryCollection:(NSArray *)categories;
@end

@interface CategoryCollectionDownloader : RESTConnection
@property (weak, nonatomic) id<CategoryCollectionDownloaderDelegate> delegate;
- (BOOL)downloadCategoryCollection;
@end
