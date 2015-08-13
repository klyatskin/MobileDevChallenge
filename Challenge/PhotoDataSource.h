//
//  PhotoDataSource.h
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoDataSource : NSObject


typedef void (^PhotoDataSourceCallback)(PhotoDataSource *ds, NSUInteger added);

@property (nonatomic,copy) PhotoDataSourceCallback callbackUpdated;


// # no check for multiple downloads of the same page !

@property (nonatomic,readonly) NSInteger lastPageLoaded;
@property (nonatomic,readonly) NSInteger lastPhotoLoaded;
@property (nonatomic,readonly) NSInteger totalPhotos;
@property (nonatomic,readonly) NSInteger totalPages;



+ (PhotoDataSource *)sharedPhotoDataSource;
- (void)loadPage:(NSInteger)page;
- (NSString*)urlForPhoto:(NSUInteger)no isCropped:(BOOL)isCropped;


@end
