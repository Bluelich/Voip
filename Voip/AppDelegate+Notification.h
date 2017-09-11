//
//  AppDelegate+Notification.h
//  Voip
//
//  Created by zhouqiang on 11/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate.h"

FOUNDATION_EXPORT NSString *kNotificationInputCategoryIdentifier;
FOUNDATION_EXPORT NSString *kNotificationGeneralCategoryIdentifier;
FOUNDATION_EXPORT NSString *kNotificationTimerExpiredCategoryIdentifier;

@interface AppDelegate (Notification)

- (void)notificationRegistrationWithLaunchOptions:(NSDictionary *)launchOptions;

@end
