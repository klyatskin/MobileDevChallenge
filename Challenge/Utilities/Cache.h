//
//  Cache.h
//  Challenge
//
//  Created by Константин Кляцкин on 12.08.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <Foundation/Foundation.h>



#define CACHE_USE 0


@interface Cache : NSObject

+(void)reset;
+(void)write:(NSData*)data forLink:(NSString*)link;
+(NSData*)readForLink:(NSString*)link;
+(Boolean)isActive;
+(void)setActive:(Boolean)on;

@end
