//
//  ChallengeTests.m
//  ChallengeTests
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestSemaphor.h"
#import "PhotoDataSource.h"
#import "LazyImageView.h"

@interface ChallengeTests : XCTestCase

@end

@implementation ChallengeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample1 {

    // step 1 - how many photos we get for 1 page? Answer = 20
    // step 2 - what is the width od random image? Answer = 440.

    LazyImageCallback onUpdateBlock = ^(LazyImageView *liv) {

        UIImage *image = liv.image;

        NSUInteger width = image.size.width;
        printf("\n\nImage width %ld\n\n", (long)width);

        if (width != 440) {
            XCTFail(@"An image should be 440px.");
        }
        [[TestSemaphor sharedInstance] lift:@"liv"];

    };

    __unused PhotoDataSource *pds = [PhotoDataSource sharedPhotoDataSource].callbackOnUpdate = ^(PhotoDataSource *pds, NSUInteger count) {

        NSUInteger items = [pds lastPhotoLoaded];
        printf("\n\nDownloaded %ld\n\n", (long)items);
        if (items != 20) {
            XCTFail(@"A first page should return 20 items.");
        }
        [[TestSemaphor sharedInstance] lift:@"pds"];

        if (items) {
            NSUInteger no = arc4random() % items;
            NSString *url = [pds urlForPhoto:no isCropped:YES];
            LazyImageView *liv = [[LazyImageView alloc] initWithCallbackOnUpdate:onUpdateBlock];
            [liv setUrl:url]; // start loading

            [[TestSemaphor sharedInstance] waitForKey:@"liv"];
        }
    };

    [[TestSemaphor sharedInstance] waitForKey:@"pds"];
}


@end
