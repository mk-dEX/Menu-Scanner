//
//  SecurityManager.m
//  Menu Scanner
//
//  Created by Marc Kirchmann on 11.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "SecurityManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import "MenuScannerConstants.h"

@implementation SecurityManager

#pragma mark - Hash value calculation

+ (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt
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

#pragma mark - User name store

+ (BOOL)storeUserName:(NSString *)name
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:name forKey:KEYCHAIN_KEY];
    [prefs synchronize];
    return YES;
}

#pragma mark - User name load

+ (NSString *)loadUserName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:KEYCHAIN_KEY];
}

#pragma mark - User password store

+ (BOOL)storePassword:(NSString *)password forUser:(NSString *)user
{
    return [self createKeychainValue:password forIdentifier:user];
}

#pragma mark - User password load

+ (NSString *)loadPasswordForUser:(NSString *)user
{
    return [self keychainValueForIdentifier:user];
}

#pragma mark - Keychain init

+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDictionary setObject:@"Menu Scanner" forKey:(__bridge id)kSecAttrService];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    
    return searchDictionary;
}

#pragma mark - Keychain load

+ (NSData *)searchKeychainForIdentifier:(NSString *)identifier
{
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    NSData *result = nil;
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);
    
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    }
    
    return result;
}

+ (NSString *)keychainValueForIdentifier:(NSString *)user
{
    NSData *valueData = [self searchKeychainForIdentifier:user];
    if (valueData) {
        NSString *value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
        return value;
    }
    
    return nil;
}

#pragma mark - Keychain store

+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)user
{
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:user];
    NSData *valueData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    } else if (status == errSecDuplicateItem){
        return [self updateKeychainValue:password forIdentifier:user];
    }
    
    return NO;
}

+ (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)user
{
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:user];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
    
    if (status == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

@end
