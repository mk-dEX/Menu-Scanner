//
//  RESTConnection.m
//  Menu Scanner 2
//
//  Created by Marc Kirchmann on 17.02.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//

#import "RESTConnection.h"

@interface RESTConnection ()
@property (strong) NSMutableData *receivedData;
@end


@implementation RESTConnection

@synthesize receivedData;

- (Boolean) executeRequest:(NSURLRequest *)request
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    
    id json = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&error];
    [self processData:json];
}

#pragma mark - Output Processing

- (void) processData:(id)json
{
}

@end
