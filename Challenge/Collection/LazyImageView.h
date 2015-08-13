//
//  LazyImage.h
//  Challenge
//
//  Created by Константин Кляцкин on 13.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyImageView: UIImageView

typedef void (^LazyImageCallback)(LazyImageView *li);


- (void)setUrl:(NSString*)urlStr;
- (LazyImageView*)initWithCallbackOnUpdate:(LazyImageCallback)callback;

@end
