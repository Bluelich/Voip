//
//  AppDelegate+RemoteNotification.m
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+RemoteNotification.h"
#import "NotificationCenter.h"

@implementation AppDelegate (RemoteNotification)
#pragma mark - Registration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [NotificationCenter application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [NotificationCenter application:application didFailToRegisterForRemoteNotificationsWithError:error];
}
#pragma mark - <=iOS6
// <=iOS6
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [NotificationCenter application:application didReceiveRemoteNotification:userInfo];
}
#pragma mark - iOS7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [NotificationCenter application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
@end
