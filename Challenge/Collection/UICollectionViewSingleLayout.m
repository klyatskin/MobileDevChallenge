//
//  UICollectionViewSingleLayout.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "UICollectionViewSingleLayout.h"

@implementation UICollectionViewSingleLayout


#define SPACE 0


-(id) init {

    self = [super init];

    CGSize rect = [[UIScreen mainScreen] bounds].size;

    UIDeviceOrientation  orientation = [UIDevice currentDevice].orientation;

    if (UIDeviceOrientationIsLandscape(orientation)) {
        rect.height= [[UIScreen mainScreen] bounds].size.width;
        rect.width= [[UIScreen mainScreen] bounds].size.height;
    }

    self.itemSize = rect;

    self.sectionInset = UIEdgeInsetsMake(SPACE, SPACE, 0, SPACE);
    self.minimumInteritemSpacing = SPACE;
    self.minimumLineSpacing = SPACE;

    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return self;
}

@end
