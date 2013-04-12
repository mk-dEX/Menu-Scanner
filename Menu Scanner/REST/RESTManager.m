//
//  RESTManager.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 31.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTManager.h"
#import "RESTDownloader.h"

@interface RESTManager ()
@property (strong, nonatomic) RESTDownloader *downloader;
@end

@implementation RESTManager

@synthesize authenticationDelegate;
@synthesize downloader;

- (id)initWithBaseURL:(NSURL *)baseURL
{
    if (self = [super init]) {
        downloader = [[RESTDownloader alloc] initWithBaseURL:baseURL];
    }
    return self;
}

static RESTManager *_instance;
+ (RESTManager *)sharedInstance
{
    if (_instance == nil) {
        _instance = [[RESTManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.codingduck.de"]];
    }
    return _instance;
}

- (BOOL)loginWithUser:(NSString *)user
             password:(NSString *)password
{
    return [downloader loginToURL:@"/login/check"
                         withUser:user
                         password:password
                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                              if (authenticationDelegate) {
                                  [authenticationDelegate loginWithUser:user password:password hasResult:YES];
                              }
                          } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              if (authenticationDelegate) {
                                  [authenticationDelegate loginWithUser:user password:password hasResult:NO];
                              }
                          }];
}

@end
