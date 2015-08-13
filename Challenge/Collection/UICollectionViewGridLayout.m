//
//  UICollectionViewGridLayout.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "UICollectionViewGridLayout.h"

@implementation UICollectionViewGridLayout


#define SPACE 0.0f
#define ITEMS_IN_ROW 3


-(id) init {

    self = [super init];

    CGFloat size = ([[UIScreen mainScreen] bounds].size.width - (ITEMS_IN_ROW+1) * SPACE) / ITEMS_IN_ROW;

    self.itemSize = CGSizeMake(size, size);
    self.sectionInset = UIEdgeInsetsMake(20+SPACE, SPACE, 0, SPACE);
    self.minimumInteritemSpacing = SPACE;
    self.minimumLineSpacing = SPACE;

    [self setScrollDirection:UICollectionViewScrollDirectionVertical];

    return self;
}

@end
