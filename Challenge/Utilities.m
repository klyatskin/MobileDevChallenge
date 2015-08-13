//
//  Utilities.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "Utilities.h"



@implementation Utilities



+ (void)setNetworkActivity:(int)increment {
    static int count = 0;

    count += increment;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = count > 0;

    if (count <0) {   // we should not get here!
        count = 0;
        printf("BUG: some connection missed %s %s:%i\n", __FUNCTION__, __FILE__, __LINE__);
    }
}

@end
