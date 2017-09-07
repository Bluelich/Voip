//
//  Constant.m
//  VoipTest
//
//  Created by zhouqiang on 29/08/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "Constant.h"
#import <YYKit/YYKit.h>

int kCallAppID   = 1400028285;
int kAccountType = 11818;
NSString *kMasterSecret = @"03b9fb351f68f096ee106125";
NSString *kJPUSHKey     = @"101a10c732d211e04c33f5b3";
NSString *kChannel      = @"VoipTest";

NSString *NSStrinWithHexFormatFromData(NSData *token){
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:token.length * 2];
    const char *bytes = token.bytes;
    for (int i = 0; i < token.length; ++i) {
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    return str;
}

@implementation Constant

@end

@implementation NSObject (Test)

+ (void)load
{
    
}

@end
