//
//  LoginChecker.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 04.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "LoginChecker.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation LoginChecker
@synthesize delegate;

- (void)authenticateWithUserName:(NSString *)name andPassword:(NSString *)key
{
    NSURL *url = [NSURL URLWithString:@"http://api.codingduck.de/login/check"];
    
    long timestamp = 1360711772;//(long)[[NSDate date] timeIntervalSince1970];
    NSString *signature = [NSString stringWithFormat:@"%@.%@.%ld", @"/login/check", name, timestamp];
    NSString *signatureHash = [self hashString:signature withSalt:key];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"%ld", timestamp] forHTTPHeaderField:@"QRAuth_timestamp"];
    [request setValue:signatureHash forHTTPHeaderField:@"QRAuth_signature"];
    [request setValue:name forHTTPHeaderField:@"QRAuth_username"];
    [request setHTTPMethod:@"POST"];
    
    [self executeRequest:request];
}

- (void) processData:(id)json
{
    NSDictionary *error = [(NSDictionary *)json objectForKey:@"error"];
    NSNumber *code = (NSNumber *)[error objectForKey:@"code"];
    
    if (self.delegate)
    {
        int value = [code intValue];
        if (value == 200) {
            [self.delegate loginIsValid:YES];
        }
        else if (value == 401) {
            [self.delegate loginIsValid:NO];
        }
    }
}

- (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt
{
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    return hash;
    
}

@end
