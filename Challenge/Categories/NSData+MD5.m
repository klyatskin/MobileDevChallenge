//
//  NSData+MD5.m
//  Challenge
//
//  Created by Константин Кляцкин on 06.10.15.
//  Copyright (c) 2015 Konstantin Klyatkin. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (MD5)


// CC_MD5_DIGEST_LENGTH = 16

- (NSString *)md5 {

    return [NSString stringWithFormat:@"%lu",(unsigned long)[self hash]];

    unsigned char result[16];
    CC_MD5( self.bytes, (unsigned int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end

@implementation NSString(MD5)

- (NSString*)md5 {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];

/*
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);

    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;

*/
}

@end
