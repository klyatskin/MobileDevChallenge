//
//  CollectionViewCell.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Utilities.h"
#import "NSError+Log.h"
#import "Cache.h"



@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor darkGrayColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 2, 2)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];

    return self;
}


-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}


#pragma mark - Setters

-(void)setImage:(UIImage *)image {
    [self.imageView setImage:image];
}


-(void)setImageAtUrl:(NSString *)urlStr {
    self.imageView.image = [UIImage imageNamed:@"nil.jpg"];



    if ([Cache isActive]) {
        NSData *data = [Cache readForLink:urlStr];
        if (data) {
            [self updateImageWithData:data];
            return;
        }
    }


    [Utilities setNetworkActivity:1];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                               [Utilities setNetworkActivity:-1];

                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (statusCode == 200) {

                                   if ([Cache isActive])
                                       if (data)
                                           [Cache write:data forLink:urlStr];

                                   [self updateImageWithData:data];

                               } else {
                                   self.imageView.image = [UIImage imageNamed:@"error.png"];
                                  [error log];
                               }
                           }];

}

- (void)updateImageWithData:(NSData*)data {
    self.imageView.image = [UIImage imageWithData:data];
}

@end
