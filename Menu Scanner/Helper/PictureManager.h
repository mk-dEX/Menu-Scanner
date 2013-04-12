//
//  PictureManager.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 04.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureManager : NSObject
+ (PictureManager *)sharedInstance;
- (void)initImageView:(UIImageView *)imageView withImageFromURL:(NSString *)url;
@property (strong, nonatomic) UIImage *defaultImage;
@end
