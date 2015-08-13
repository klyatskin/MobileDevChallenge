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


@interface ViewController ()

@property (nonatomic, strong) UICollectionViewGridLayout *gridLayout;
@property (nonatomic, strong) UICollectionViewSingleLayout *singleLayout;


@end

@implementation ViewController

static  NSString * kCellIdentifier = @"CellIdentifier";


#pragma mark - Initializing

-(void)loadView
{
    // initialze API and load first page

    PhotoDataSource * pds = [PhotoDataSource sharedPhotoDataSource]; // a call to init
    pds.callbackUpdated = ^(PhotoDataSource *pds, NSUInteger count) {
        [self collectionIncreasedBy:count from:pds];
    };


    // Create instances of our layouts
    self.gridLayout = [[UICollectionViewGridLayout alloc] init];


    // create collection view

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;

    // Register our classes so we can use our custom subclassed cell and header
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];

    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView = collectionView;
}


-(void)viewDidAppear:(BOOL)animated {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions on update callback

- (void)collectionIncreasedBy:(NSUInteger)count from:(PhotoDataSource * )pds {

    NSLog(@"Loaded %d new photos", count);

    // we have to update collection view as we have downloaded more items

    NSMutableArray *indexes = [NSMutableArray array];
    for (int i = 0; i < count; i++)
        [indexes addObject:[NSIndexPath indexPathForItem:pds.lastPhotoLoaded-count+i inSection:0]];

    // Perform the updates
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexes];
    } completion:nil];
}


#pragma mark - UICollectionView Delegate & DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [PhotoDataSource sharedPhotoDataSource].lastPhotoLoaded;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];



    // перезапускаем если показана последгяя
    PhotoDataSource *pds = [PhotoDataSource sharedPhotoDataSource];
    if (indexPath.item == pds.lastPhotoLoaded-1-10) // last one -10
        [pds loadPage:pds.lastPageLoaded+1];


    [cell setImageAtUrl:[[PhotoDataSource sharedPhotoDataSource] urlForPhoto:indexPath.item isCropped:YES]];
    return cell;
}

@end

