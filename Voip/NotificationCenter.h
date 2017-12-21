//
//  NotificationCenter.h
//  Voip
//
//  Created by Bluelich on 20/11/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *kNotificationInputCategoryIdentifier;
FOUNDATION_EXPORT NSString *kNotificationGeneralCategoryIdentifier;
FOUNDATION_EXPORT NSString *kNotificationTimerExpiredCategoryIdentifier;

@interface NotificationCenter : NSObject

+ (void)notificationRegistrationWithLaunchOptions:(NSDictionary *)launchOptions;
+ (void)voipRegistration;

+ (void)scheduledLocalNotificationWithTitle:(NSString *)titile
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      sound:(NSString *)sound
                                      badge:(NSUInteger)badge
                                   category:(NSString *)category
                                   userInfo:(NSDictionary *)userInfo;


+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
