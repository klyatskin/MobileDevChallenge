//
//  NSError+Log.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "NSError+Log.h"

@implementation NSError (Log)

- (void)log {


    NSLog(@"Error - %@\n\n%@\n\n%@",
          [self localizedDescription],
          [self description],
          [self userInfo][NSURLErrorFailingURLStringErrorKey]
          );
}


@end
