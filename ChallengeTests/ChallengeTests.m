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

- (void)testExample {


    __unused PhotoDataSource *pds = [PhotoDataSource sharedPhotoDataSource].callbackOnUpdate = ^(PhotoDataSource *pds, NSUInteger count) {

        NSUInteger items = [pds lastPhotoLoaded];
        printf("\n\nDownloaded %d\n\n", items);
        if (items != 20)
            XCTFail(@"A first page should return 20 items.");
        [[TestSemaphor sharedInstance] lift:@"pds"];
        printf("\n\nSuccess.\n\n");

    };

    [[TestSemaphor sharedInstance] waitForKey:@"pds"];
}

@end
