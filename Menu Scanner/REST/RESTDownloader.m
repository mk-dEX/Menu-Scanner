//
//  RESTDownloader.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 30.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTDownloader.h"
#import "SecurityManager.h"
#import "MenuScannerConstants.h"
#import "RESTAuthentication.h"

@interface RESTDownloader ()
@property (strong, nonatomic) RKObjectManager *objectManager;
@end

@implementation RESTDownloader

@synthesize objectManager;

- (id)init
{
    if (self = [super init]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:REST_BASE]];
        [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        RKLogConfigureByName("RestKit/Network*", RKLogLevelOff);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    }
    return self;
}

#pragma mark - Login

- (BOOL)loginWithUser:(NSString *)user
             password:(NSString *)password
              success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:REST_LOGIN];
    if ([self updateSecurityHeadersForURL:url withUser:user password:password])
    {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RESTAuthentication class]];
        [mapping addAttributeMappingsFromArray:@[@"code", @"message"]];
        
        RKResponseDescriptor *authenticationDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                                 pathPattern:nil
                                                                                                     keyPath:@"error"
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        [objectManager addResponseDescriptor:authenticationDescriptor];
        [objectManager postObject:nil path:REST_LOGIN parameters:nil success:success failure:failure];
        
        return YES;
    }
    return NO;
}

#pragma mark - Security

- (BOOL)updateSecurityHeadersForURL:(NSURL *)relativeURL
                           withUser:(NSString *)user
                           password:(NSString *)password
{
    if (user == nil || password == nil) {
        return NO;
    }
    
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    NSString *signature = [NSString stringWithFormat:@"%@.%@.%ld", relativeURL, user, timestamp];
    NSString *signatureHash = [SecurityManager hashString:signature withSalt:password];
    
    [objectManager.HTTPClient setDefaultHeader:SECURE_REST_CONNECTION_TIMESTAMP value:[NSString stringWithFormat:@"%ld", timestamp]];
    [objectManager.HTTPClient setDefaultHeader:SECURE_REST_CONNECTION_SIGNATURE value:signatureHash];
    [objectManager.HTTPClient setDefaultHeader:SECURE_REST_CONNECTION_USERNAME value:user];
    return YES;
}

- (BOOL)updateSecurityHeadersWithKeychainForURL:(NSURL *)relativeURL
{
    NSString *user;
    NSString *password;
    if ((user = [SecurityManager loadUserName]) == nil || (password = [SecurityManager loadPasswordForUser:user]) == nil) {
        return NO;
    }
    
    return [self updateSecurityHeadersForURL:relativeURL withUser:user password:password];
}

@end
