//
//  AppDelegate+Notification.m
//  Voip
//
//  Created by zhouqiang on 11/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+RemoteNotification.h"
#import "AppDelegate+JPush.h"

NSString     *kNotificationInputCategoryIdentifier          = @"category1";
NSString     *kNotificationGeneralCategoryIdentifier        = @"category2";
NSString     *kNotificationTimerExpiredCategoryIdentifier   = @"TIMER_EXPIRED";
NSDictionary *NSDictionaryFromNotificationSettings(UNNotificationSettings *settings);

@interface AppDelegate (__Notification__)<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (Notification)
- (void)notificationRegistrationWithLaunchOptions:(NSDictionary *)launchOptions
{
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound + UNAuthorizationOptionAlert;
    __weak typeof(self) weakSelf = self;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [weakSelf configNotificationCategories];
        }
    }];
    //注册极光
    [self jpushRegistrationWithLaunchOptions:launchOptions];
}
- (void)configNotificationCategories
{
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",NSDictionaryFromNotificationSettings(settings));
    }];
    NSSet *categories = [NSSet setWithArray:@[self.category1,self.category2,self.category3]];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
}
- (UNNotificationCategory *)category1
{
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"action1" options:UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"action2" options:UNNotificationActionOptionForeground];
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"action3" options:UNNotificationActionOptionDestructive];
    UNTextInputNotificationAction *action4 = [UNTextInputNotificationAction actionWithIdentifier:@"action4" title:@"action4" options:UNNotificationActionOptionForeground textInputButtonTitle:@"action4_buttonTitle" textInputPlaceholder:@"action4_placeholder"];
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1,action2,action3,action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    return category1;
}
- (UNNotificationCategory *)category2
{
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"GENERAL" actions:@[] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    return category2;
}
- (UNNotificationCategory *)category3
{
    UNNotificationAction* snoozeAction = [UNNotificationAction actionWithIdentifier:@"SNOOZE_ACTION" title:@"Snooze" options:UNNotificationActionOptionNone];
    UNNotificationAction* stopAction = [UNNotificationAction actionWithIdentifier:@"STOP_ACTION" title:@"Stop" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *category3 = [UNNotificationCategory categoryWithIdentifier:@"TIMER_EXPIRED" actions:@[snoozeAction, stopAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    return category3;
}
#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        //Remote
        [self handleRemoteNotification:notification.request.content.userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    if([response.notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        //Remote
        [self handleRemoteNotification:response.notification.request.content.userInfo];
    }
    completionHandler();
}
@end

NSString *NSStringFromAuthorizationStatus(UNAuthorizationStatus status){
    switch (status) {
        case UNAuthorizationStatusNotDetermined:
            return @"NotDetermined";
        case UNAuthorizationStatusAuthorized:
            return @"Authorized";
        case UNAuthorizationStatusDenied:
            return @"Denied";
    }
}
NSString *NSStringFromNotificationSetting(UNNotificationSetting setting){
    switch (setting) {
        case UNNotificationSettingNotSupported:
            return @"NotSupported";
        case UNNotificationSettingEnabled:
            return @"Enabled";
        case UNNotificationSettingDisabled:
            return @"Disabled";
    }
}
NSString *NSStringFromAlertStyle(UNAlertStyle alertStyle){
    switch (alertStyle) {
        case UNAlertStyleNone:
            return @"None";
        case UNAlertStyleBanner:
            return @"Banner";
        case UNAlertStyleAlert:
            return @"Alert";
    }
}
NSDictionary *NSDictionaryFromNotificationSettings(UNNotificationSettings *settings){
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:NSStringFromAuthorizationStatus(settings.authorizationStatus) forKey:@"authorizationStatus"];
    [info setValue:NSStringFromNotificationSetting(settings.soundSetting) forKey:@"soundSetting"];
    [info setValue:NSStringFromNotificationSetting(settings.badgeSetting) forKey:@"badgeSetting"];
    [info setValue:NSStringFromNotificationSetting(settings.alertSetting) forKey:@"alertSetting"];
    [info setValue:NSStringFromNotificationSetting(settings.notificationCenterSetting) forKey:@"notificationCenterSetting"];
    [info setValue:NSStringFromNotificationSetting(settings.lockScreenSetting) forKey:@"lockScreenSetting"];
    [info setValue:NSStringFromNotificationSetting(settings.carPlaySetting) forKey:@"carPlaySetting"];
    [info setValue:NSStringFromAlertStyle(settings.alertStyle) forKey:@"alertStyle"];
    return info.copy;
}
