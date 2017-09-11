//
//  NSData+Utility.m
//  Pods
//
//  Created by zhouqiang on 11/09/2017.
//
//

#import "NSData+Utility.h"

@implementation NSData (Utility)
- (NSString *)hexString
{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:self.length * 2];
    const char *bytes = self.bytes;
    for (int i = 0; i < self.length; ++i) {
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    return str;
}
@end
