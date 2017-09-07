//
//  AppDelegate+RemoteNotification.m
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+RemoteNotification.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (RemoteNotification)
- (void)remoteNotificationRegistration
{
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound + UNAuthorizationOptionAlert;
    __weak typeof(self) weakSelf = self;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [weakSelf configRemoteNotificationSettings];
        }
    }];
}
- (void)configRemoteNotificationSettings
{
    NSMutableArray<UNNotificationCategory *> *categories = [NSMutableArray array];
    {
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"action1" options:UNNotificationActionOptionNone];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"action2" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"action3" options:UNNotificationActionOptionDestructive];
        UNTextInputNotificationAction *action4 = [UNTextInputNotificationAction actionWithIdentifier:@"action4" title:@"action4" options:UNNotificationActionOptionForeground textInputButtonTitle:@"action4_buttonTitle" textInputPlaceholder:@"action4_placeholder"];
        UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1,action2,action3,action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [categories addObject:category1];
    }
    {
        UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"GENERAL" actions:@[] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [categories addObject:category2];
    }
    {
        UNNotificationAction* snoozeAction = [UNNotificationAction actionWithIdentifier:@"SNOOZE_ACTION" title:@"Snooze" options:UNNotificationActionOptionNone];
        UNNotificationAction* stopAction = [UNNotificationAction actionWithIdentifier:@"STOP_ACTION" title:@"Stop" options:UNNotificationActionOptionForeground];
        UNNotificationCategory *category3 = [UNNotificationCategory categoryWithIdentifier:@"TIMER_EXPIRED" actions:@[snoozeAction, stopAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [categories addObject:category3];
    }
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:categories]];
}
@end
