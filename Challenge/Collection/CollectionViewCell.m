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

    LazyImageCallback onUpdateBlock = ^(LazyImageView *liv) {
        [self cellUpdatedBy:liv];
    };

    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    self.imageView = [[LazyImageView alloc] initWithCallbackOnUpdate:onUpdateBlock];
    self.imageView.frame = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 2, 2);
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

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


- (void)cellUpdatedBy:(LazyImageView *)liv {
    NSLog(@"cell update = %@", NSStringFromCGSize(liv.image.size));
}

@end
