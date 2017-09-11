//
//  AppDelegate+RemoteNotification.m
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+RemoteNotification.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+JPush.h"
#import <Utility/Utility.h>

@implementation AppDelegate (RemoteNotification)
#pragma mark - Registration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken:%@",deviceToken.hexString);
    NSString *tokenDescription = [NSString stringWithFormat:@"\nDeviceToken:%@",deviceToken.hexString];
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [self jpushRegisterDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - <=iOS6
// <=iOS6
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo];
}
#pragma mark - iOS7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - Handler
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [self jpushHandleRemoteNotification:remoteInfo];
}
@end
