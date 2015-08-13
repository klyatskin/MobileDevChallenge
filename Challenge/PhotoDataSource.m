//
//  PhotoDataSource.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "PhotoDataSource.h"
#import "NSError+Log.h"
#import "Utilities.h"


@interface PhotoDataSource () {
}

@property (nonatomic, strong) NSMutableArray *photoUrls;

@end




static const NSString* kAPIBaseUrl = @"https://api.500px.com/v1";
static const NSString *kAPIEndPoint = @"photos";

static const NSUInteger kCroppedImageSize = 440;
static const NSUInteger kFullImageSize = 1080;

#define CONSUMER_KEY @"yQ4SEZVun2N1BVMoB8ZvQJ2ojCwnDLdz3T8Od45U"


@implementation PhotoDataSource


#pragma mark - Create Singleton

static PhotoDataSource *_photoDataSource;

+ (PhotoDataSource *)sharedPhotoDataSource {
	if (_photoDataSource == nil) {
		_photoDataSource = [[PhotoDataSource alloc] init];
        [ _photoDataSource initialLoad];
	}
	return _photoDataSource;
}


#pragma mark - Initialize

- (void)initialLoad {
    _lastPageLoaded = 0;
    [self loadPage:1];
}


#pragma mark - Downloads

- (void)loadPage:(NSInteger)page {

    if ((self.totalPages != 0) && (page > self.totalPages))
        return;

    NSString *urlString = [NSString stringWithFormat:@"%@/%@?consumer_key=%@&image_size[]=%d&image_size[]=%d&page=%d", kAPIBaseUrl, kAPIEndPoint, CONSUMER_KEY, kCroppedImageSize, kFullImageSize, page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];


    [Utilities setNetworkActivity:1];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                               [Utilities setNetworkActivity:-1];

                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode == 200) {
                                   _lastPageLoaded = page;
                                   [self handlePageData:data];
                               } else {
                                   NSLog(@"Failure withStatusCode = %d", statusCode);
                                   [error log];
                               }
                           }];
}




- (void)handlePageData:(NSData *)data {

    NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSInteger count = [jsonData[@"photos"] count];

    // the very first call
    if (self.photoUrls == nil) {
        self.photoUrls = [NSMutableArray arrayWithCapacity:count];
        _totalPhotos = [jsonData[@"total_items"] integerValue];
        _totalPages = [jsonData[@"total_pages"] integerValue];

    }

    // parse data
    for (NSDictionary *photo in jsonData[@"photos"]) {

        NSMutableDictionary *newPhoto = [[NSMutableDictionary alloc] init];

        NSDictionary *images = photo[@"images"];
        for (NSDictionary *image in images) {

            NSInteger size = [image[@"size"] integerValue];

            if (size == kCroppedImageSize)
                [newPhoto setObject:image[@"url"] forKey:@"url_cropped"];

            if (size == kFullImageSize)
                [newPhoto setObject:image[@"url"] forKey:@"url_full"];

        }

        [self.photoUrls addObject:newPhoto];
    }

    _lastPhotoLoaded += count;
    self.callbackUpdated(self, count);
}


#pragma mark - Getters


- (NSString*)urlForPhoto:(NSUInteger)no isCropped:(BOOL)isCropped {

    if (no >= self.photoUrls.count)
        return nil;

    return [[self.photoUrls objectAtIndex:no] valueForKey: isCropped ? @"url_cropped" : @"url_full"];
}
    


@end
