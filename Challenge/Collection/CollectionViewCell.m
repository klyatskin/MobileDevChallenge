//
//  CollectionViewCell.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Utilities.h"
#import "NSError+Log.h"
#import "Cache.h"



@interface CollectionViewCell () {
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSString *imageUrl;


@end


@implementation CollectionViewCell


#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor darkGrayColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 2, 2)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];

    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    [self cancelConnection];    // cancel any active connection
    self.mutableData = nil;
    self.imageView.image = nil;
}


#pragma mark - Setters


- (void)setImageByUrl:(NSString *)urlStr {
    self.imageView.image = [UIImage imageNamed:@"nil.jpg"];

    if ([Cache isActive]) {
        NSData *data = [Cache readForLink:urlStr];
        if (data) {
            [self updateImageWithData:data];
            return;
        }
    }

    self.imageUrl = urlStr; // save it

    self.mutableData = [NSMutableData data];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    [Utilities setNetworkActivity:1];
    [self.connection start];
}



- (void)updateImageWithData:(NSData*)data {
    self.imageView.image = [UIImage imageWithData:data];
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
    self.imageView.image = [UIImage imageNamed:@"error.png"];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self updateImageWithData:self.mutableData];
    if ([Cache isActive])
            [Cache write:self.mutableData forLink:self.imageUrl];

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
