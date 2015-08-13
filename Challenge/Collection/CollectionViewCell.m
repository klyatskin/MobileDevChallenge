//
//  CollectionViewCell.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Utilities.h"
#import "LazyImageView.h"



@interface CollectionViewCell () {
}

@property (nonatomic, strong) LazyImageView *imageView;


@end


@implementation CollectionViewCell


#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor darkGrayColor];
    self.imageView = [[LazyImageView alloc] initWithCallbackOnUpdate:nil];
    self.imageView.frame = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 2, 2);
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];

    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView setUrl:nil];    // cancel any active connection
}


- (void)setImageByUrl:(NSString *)urlStr {
    [self.imageView setUrl:urlStr];
}



@end