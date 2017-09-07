//
//  AppDelegate+NotificationCenter.m
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (NotificationCenter)

- (void)scheduledLocalNotificationWithTitle:(NSString *)titile
                                   subTitle:(NSString *)subTitle
                                       body:(NSString *)body
                                      sound:(NSString *)sound
                                      badge:(NSUInteger)badge
                                   category:(NSString *)category
                                   userInfo:(NSDictionary *)userInfo
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.badge = @(badge);
    content.title = titile;
    content.subtitle = subTitle;
    content.body = body;
    content.categoryIdentifier = category;
    content.launchImageName = @"icon_test";
    content.sound = [UNNotificationSound soundNamed:sound];
    content.userInfo = userInfo;
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image_test" ofType:@"jpg"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            CFDictionaryRef ref = CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 1, 1));
            NSDictionary *options = @{UNNotificationAttachmentOptionsTypeHintKey:@"jpg",
                                      UNNotificationAttachmentOptionsThumbnailHiddenKey:@(NO),
                                      UNNotificationAttachmentOptionsThumbnailClippingRectKey:(__bridge id)ref,
                                      UNNotificationAttachmentOptionsThumbnailTimeKey:@0};
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSUUID UUID].UUIDString URL:[NSURL fileURLWithPath:path] options:options error:nil];
            content.attachments = @[attachment];
        }
    }
    //给通知内容设置category
    content.categoryIdentifier = @"category1";
    /*
     按照calendar触发
     NSDateComponents *components = ...
     [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
     按照区域触发
     CLRegion *regin = ...
     [UNLocationNotificationTrigger triggerWithRegion:regin repeats:YES];
     */
    //1秒后触发 repeats && interval < 60 => crash
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"add notification failed");
            return;
        }
        NSLog(@"add notification success");
    }];
}
@end
