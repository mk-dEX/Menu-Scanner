//
//  RESTConnection.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 17.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"
#import "MenuScannerConstants.h"

@interface RESTConnection ()
@property (strong) NSMutableData *receivedData;
@end

@implementation RESTConnection

@synthesize receivedData;
@synthesize httpDelegate;
@synthesize baseURL;

- (id)init
{
    if (self = [super init]) {
        baseURL = [NSURL URLWithString:REST_BASE];
    }
    return self;
}

- (BOOL)executeRequest:(NSURLRequest *)request
{
    receivedData = [NSMutableData new];
    return [[NSURLConnection alloc] initWithRequest:request delegate:self] != nil;
}

#pragma mark - HTTP Connection Handling

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    receivedData = nil;
    if (httpDelegate) {
        [httpDelegate connection:self didFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    
    id json = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&error];
    HttpCode code = [self checkResponse:json];
    if (code == NoCode || code == HttpCodeSuccessful) {
        [self processData:json];
    }
}

#pragma mark - Output Processing

- (void)processData:(id)json
{
    //Implementierung in Subklasse
}

#pragma mark - Error Checking

- (HttpCode)checkResponse:(id)json
{
    NSDictionary *responseDetail;
    NSNumber *responseCode;
    HttpCode code = NoCode;
    
    NSDictionary *responseDict = (NSDictionary *)json;
    if ([responseDict respondsToSelector:@selector(objectForKey:)]) {
        responseDetail = [(NSDictionary *)json objectForKey:REST_HTTP_RESPONSE];
        responseCode = (NSNumber *)[responseDetail objectForKey:REST_HTTP_CODE];
        if (responseCode != nil) {
            code = HttpCodeUnknown;
        }
    }
    
    if (code == HttpCodeUnknown)
    {
        int value = [responseCode intValue];
        if (value == 200) {
            code = HttpCodeSuccessful;
        }
        else if (value == 401) {
            code = HttpCodeNotAuthorized;
        }
        else if (value == 404) {
            code = HttpCodeServiceNotAvailable;
        }
    }
    
    if (httpDelegate) {
        [httpDelegate connection:self didFinishWithCode:code];
    }
    
    return code;
}

@end
