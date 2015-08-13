//
//  LazyImage.m
//  Challenge
//
//  Created by Константин Кляцкин on 13.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "LazyImageView.h"
#import "Utilities.h"
#import "NSError+Log.h"
#import "Cache.h"

@interface LazyImageView ()

@property (nonatomic,copy) LazyImageCallback callbackOnUpdate;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSString *imageUrl;

@end


@implementation LazyImageView

#define LI_EMPTY_IMAGE [UIImage imageNamed:@"nil.jpg"]
#define LI_ERROR_IMAGE [UIImage imageNamed:@"error.png"]




- (LazyImageView*)initWithCallbackOnUpdate:(LazyImageCallback)callback {
    self = [super init];
    self.image = LI_EMPTY_IMAGE;
    self.callbackOnUpdate = callback;
    return self;
}



#pragma mark - Setters


- (void)setUrl:(NSString*)urlStr {

    self.image = LI_EMPTY_IMAGE;
    [self cancelConnection];

    if ([Cache isActive]) {
        NSData *data = [Cache readForLink:urlStr];
        if (data) {
            [self updateImageWithData:data];
            return;
        }
    }

    // save url
    self.imageUrl = urlStr;
    // create new buffer
    self.mutableData = [NSMutableData data];

    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    [Utilities setNetworkActivity:1];
    [self.connection start];
}



- (void)updateImageWithData:(NSData*)data {
    UIImage *image = [UIImage imageWithData:data];
    self.image = image ? image : LI_ERROR_IMAGE;
}



#pragma mark - NSURLConnection protocol

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSUInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    if (statusCode != 200)
        [self cancelConnection];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mutableData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [error log];
    [self cancelConnection];
    self.image = LI_ERROR_IMAGE;
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self updateImageWithData:self.mutableData];
    if ([Cache isActive])
        [Cache write:self.mutableData forLink:self.imageUrl];

    self.callbackOnUpdate(self);
    [self cancelConnection];
}


- (void)cancelConnection {
    if (self.connection) {
        [Utilities setNetworkActivity:-1];
        [self.connection cancel];
        self.connection = nil;
    }
}





@end
