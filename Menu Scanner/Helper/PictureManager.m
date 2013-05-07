//
//  PictureManager.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 04.04.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "PictureManager.h"

@interface PictureManager ()
@property (strong, nonatomic) NSMutableDictionary *pictureCache;
@end

@implementation PictureManager

static PictureManager *_instance;

@synthesize pictureCache;
@synthesize defaultImage;

+ (id)alloc
{
    @synchronized([PictureManager class])
    {
        NSAssert(_instance == nil, @"Error allocating second PictureManager.");
        _instance = [super alloc];
        return _instance;
    }
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        pictureCache = [NSMutableDictionary new];
        defaultImage = [UIImage imageNamed:@"vader.jpg"];
    }
    return self;
}

+ (PictureManager *)sharedInstance
{
    @synchronized([PictureManager class])
    {
        if (!_instance)
            _instance = [[self alloc] init];
        return _instance;
    }
    return nil;
}

- (void)initImageView:(UIImageView *)imageView withImageFromURL:(NSString *)url
{
    UIImage *imageFromURL = [pictureCache objectForKey:url];
    if (imageFromURL) {
        [imageView setImage:imageFromURL];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:url]];
            UIImage *image = data ? [UIImage imageWithData:data] : defaultImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:image];
                [pictureCache setValue:image forKey:url];
            });
        });
    }
}

@end
