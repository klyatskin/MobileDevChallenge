//
//  CollectionViewCell.h
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

-(void)setImageByUrl:(NSString *)urlStr indexToCache:(NSIndexPath*)indexPath;
- (UIImageView*)cellImageView;

@end
