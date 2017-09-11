//
//  AppDelegate+JPush.m
//  Voip
//
//  Created by zhouqiang on 11/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import <JPush/JPUSHService.h>
#import <AdSupport/AdSupport.h>
#import <Utility/Constant.h>
#import <UserNotifications/UserNotifications.h>
#import <Utility/Utility.h>

@interface AppDelegate (__JPush__)

@end

@implementation AppDelegate (JPush)
- (void)jpushRegistrationWithLaunchOptions:(NSDictionary *)launchOptions
{
    [JPUSHService setLogOFF];
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPUSHKey
                          channel:kJPUSHChannel
                 apsForProduction:NO
            advertisingIdentifier:ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSMutableString *text = [NSMutableString string];
        if (resCode == 1011 && registrationID == nil) {
            [text appendString:@"模拟器"];
        }
        [text appendFormat:@"resCpde:%d registrationID:%@",resCode,registrationID];
        NSLog(@"%@",text);
    }];
}
- (void)jpushRegisterDeviceToken:(NSData *)deviceToken
{
    NSString *tokenDescription = [NSString stringWithFormat:@"\nDeviceToken:%@",deviceToken.hexString];
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)jpushHandleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}
@end
