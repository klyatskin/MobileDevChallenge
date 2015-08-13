//
//  Cache.m
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//


#import "Cache.h"
#import "Settings.h"
#import "Utilities.h"



// TODO - test with CoreData, people say it will be slower...
// http://biasedbit.com/filesystem-vs-coredata-image-cache/
// http://stackoverflow.com/questions/4158286/storing-images-in-core-data-or-as-file



#define FOLDER NSTemporaryDirectory()

@implementation Cache


+ (Boolean)isActive {

    return NO;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyLaunchedBefore] == NO) {
        // the very first launch
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKeyIsCaching];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKeyLaunchedBefore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return [[NSUserDefaults standardUserDefaults] boolForKey:kKeyIsCaching];
}



+ (void)setActive:(Boolean)on {

    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kKeyIsCaching];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!on) {
        [Utilities alertWithTitle:@"Warning!" message:@"\nCache wiped out and won't be used.\n\nSwitching cache off may brings some visual flicks."];
        [Cache reset];  // wipe all cached data
    }
}



+ (void)reset {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FOLDER error:nil];
    for (NSString *file in files) {
        if ([file hasPrefix:@"cache_"])
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",FOLDER,file] error:nil];
    }
}



+ (void)write:(NSData*)data forLink:(NSString*)link {
    NSString *fName = [NSString stringWithFormat:@"%@/cache_%lu.jpg",FOLDER, (unsigned long)[link hash]];
    [data writeToFile:fName atomically:NO];
}



+ (NSData*)readForLink:(NSString*)link {
    NSString *fName = [NSString stringWithFormat:@"%@/cache_%lu.jpg",FOLDER, (unsigned long)[link hash]];
    return [NSData dataWithContentsOfFile:fName];
}

@end
