//
//  AppDelegate+JPush.h
//  Voip
//
//  Created by zhouqiang on 11/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (JPush)

- (void)jpushRegistrationWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)jpushRegisterDeviceToken:(NSData *)token;
- (void)jpushHandleRemoteNotification:(NSDictionary *)remoteInfo;

@end
