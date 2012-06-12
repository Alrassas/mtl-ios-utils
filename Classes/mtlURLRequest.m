//
//  mtlURLRequest.m
//  mtliOSUtils
//
//  Created by Elie Zananiri on 12-01-19.
//  Copyright (c) 2012 Departement. All rights reserved.
//

#import "mtlURLRequest.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlURLRequest

@synthesize numRetries;
@synthesize httpRequest;

@synthesize delegate;
@synthesize requestSuccessSelector;
@synthesize requestFailedSelector;

//--------------------------------------------------------------
- (id)init
{
    if ((self = [super init])) {
        numRetries = 0;
        httpRequest = nil;
    }
    
    return self;
}

//--------------------------------------------------------------
- (void)clear
{
    if (httpRequest != nil) {
        [httpRequest clearDelegatesAndCancel];
        httpRequest = nil;
    }
}

//--------------------------------------------------------------
- (NSString *)buildRequestURL
{
    return nil;
}

//--------------------------------------------------------------
- (NSString *)buildJSONData
{
    return nil;
}

//--------------------------------------------------------------
- (void)process
{
    // Clear any old request first.
    [self clear];
    
    // Build the request.
    httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self buildRequestURL]]];
    [httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [httpRequest appendPostData:[[self buildJSONData] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [httpRequest setNumberOfTimesToRetryOnTimeout:numRetries];
    [httpRequest setDelegate:self];
    [httpRequest setDidFinishSelector:@selector(requestFinished:)];
    [httpRequest setDidFailSelector:@selector(requestFailed:)];
    [httpRequest startAsynchronous];
}

//--------------------------------------------------------------
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (delegate && [delegate respondsToSelector:requestSuccessSelector]) {
        [delegate performSelectorOnMainThread:requestSuccessSelector withObject:self waitUntilDone:[NSThread isMainThread]];
	}
    else {
        NSLog(@"mtlURLRequest finished: %@", [request responseString]);
    }
}

//--------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (delegate && [delegate respondsToSelector:requestFailedSelector]) {
        [delegate performSelectorOnMainThread:requestFailedSelector withObject:self waitUntilDone:[NSThread isMainThread]];
	}
    else {
        NSLog(@"mtlURLRequest failed: %@", [[request error] localizedDescription]);
    }
}

@end
