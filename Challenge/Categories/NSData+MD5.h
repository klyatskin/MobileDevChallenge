//
//  NSData+MD5.h
//  Challenge
//
//  Created by Константин Кляцкин on 06.10.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MD5)

- (NSString*)md5;

@end

@interface NSString (MD5)

- (NSString*)md5;

@end
