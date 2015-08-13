//
//  ViewController.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "ViewController.h"
#import "PhotoDataSource.h"

#import "CollectionViewCell.h"
#import "UICollectionViewGridLayout.h"
#import "UICollectionViewSingleLayout.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    UIView *statusBarView;
}

@property (nonatomic, strong) UICollectionViewGridLayout *gridLayout;
@property (nonatomic, strong) UICollectionViewSingleLayout *singleLayout;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation ViewController

static  NSString * kCellIdentifier = @"CellIdentifier";


#pragma mark - Initializing


- (BOOL)prefersStatusBarHidden {
    BOOL isHiding = self.collectionView.collectionViewLayout == self.singleLayout;
    statusBarView.alpha = isHiding ? 0:0.3;
    return isHiding;
}


- (void)loadView {

    // initialze API and load first page
    PhotoDataSource * pds = [PhotoDataSource sharedPhotoDataSource]; // a call to init
    pds.callbackOnUpdate = ^(PhotoDataSource *pds, NSUInteger count) {
        [self collectionIncreasedBy:count from:pds];
    };


    self.gridLayout = [[UICollectionViewGridLayout alloc] init];
    self.singleLayout = [[UICollectionViewSingleLayout alloc] init];

    // create collection view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;

    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];

    self.collectionView.pagingEnabled = YES;


    // make background for StatusBar
    CGRect rect = self.view.bounds;
    rect.size.height = 20;
    statusBarView = [[UIView alloc] initWithFrame:rect];
    statusBarView.backgroundColor = [UIColor whiteColor];
    statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:statusBarView];
}


- (void)viewWillAppear:(BOOL)animated {
    self.collectionView.frame = self.view.bounds;
}


#pragma mark - Actions on update callback

- (void)collectionIncreasedBy:(NSUInteger)count from:(PhotoDataSource * )pds {

    self.collectionView.frame = self.view.bounds;

    NSLog(@"Loaded %d new photos, total %d", count, pds.lastPhotoLoaded);

    // we have to update collection view as we have downloaded more items

    NSMutableArray *indexes = [NSMutableArray array];
    for (int i = 0; i < count; i++)
        [indexes addObject:[NSIndexPath indexPathForItem:pds.lastPhotoLoaded-count+i inSection:0]];

    // Perform the updates
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexes];
    } completion:nil];
}



#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [PhotoDataSource sharedPhotoDataSource].lastPhotoLoaded;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];

    // initiate new page downoad as we moving to the end
    PhotoDataSource *pds = [PhotoDataSource sharedPhotoDataSource];
    if (indexPath.item == pds.lastPhotoLoaded-1-10) // last one -10
        [pds loadPage:pds.lastPageLoaded+1];


    BOOL isCropped = self.collectionView.collectionViewLayout == self.gridLayout;
    [cell setImageByUrl:[[PhotoDataSource sharedPhotoDataSource] urlForPhoto:indexPath.item isCropped:isCropped]];
    return cell;
}


#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %d", indexPath.item);

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self.collectionView.collectionViewLayout invalidateLayout];

    void (^completion)(BOOL) = ^(BOOL finished) {

        [self setNeedsStatusBarAppearanceUpdate];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self.collectionView reloadData];

    };

    if (self.collectionView.collectionViewLayout == self.gridLayout) {
        [self.collectionView setCollectionViewLayout:self.singleLayout animated:YES completion:completion];
    }
    else if (self.collectionView.collectionViewLayout == self.singleLayout) {
        [self.collectionView setCollectionViewLayout:self.gridLayout animated:YES completion:completion];
    }
}

@end

