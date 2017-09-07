//
//  AppDelegate+NotificationCenter.h
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (NotificationCenter)
- (void)scheduledLocalNotificationWithTitle:(NSString *)titile
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      sound:(NSString *)sound
                                      badge:(NSUInteger)badge
                                   category:(NSString *)category
                                   userInfo:(NSDictionary *)userInfo;
@end
