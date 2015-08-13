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

// to cache preevious and next
#import "PhotoDataSource.h"



@interface CollectionViewCell () {
}

@property (nonatomic, strong) LazyImageView *imageView;
@property (nonatomic, copy) NSIndexPath *indexToCache;


@end


@implementation CollectionViewCell

#pragma mark - Getters

- (UIImageView*)cellImageView {
    return self.imageView;
}



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


-(void)setImageByUrl:(NSString *)urlStr indexToCache:(NSIndexPath*)indexPath {
    self.indexToCache = indexPath;
    [self.imageView setUrl:urlStr];
}


- (void)cellUpdatedBy:(LazyImageView *)liv {

    NSLog(@"cell update = %@", NSStringFromCGSize(liv.image.size));

    // as we have completed this cell we can start download the neibours
    // cache either to file storage or internal iOS cache

    if (self.indexToCache) {
        // we cache previous and next image

        NSUInteger no = self.indexToCache.item;

        PhotoDataSource *pds = [PhotoDataSource sharedPhotoDataSource];
        if (no > 0) { // prev
            NSString *url = [pds urlForPhoto:no-1 isCropped:NO];
            LazyImageView *livPrevous = [[LazyImageView alloc] initWithCallbackOnUpdate:nil];
            [livPrevous setUrl:url]; // start loading
        }
        // next
        NSString *url = [pds urlForPhoto:no+1 isCropped:NO];
        if (url) {
            LazyImageView *livNext = [[LazyImageView alloc] initWithCallbackOnUpdate:nil];
            [livNext setUrl:url]; // start loading
        }

    }
}

@end
