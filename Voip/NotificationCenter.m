//
//  NotificationCenter.m
//  Voip
//
//  Created by Bluelich on 20/11/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>
#import <PushKit/PushKit.h>
#import <JPush/JPUSHService.h>
#import <Utility/Utility.h>

NSString     *kNotificationInputCategoryIdentifier          = @"category1";
NSString     *kNotificationGeneralCategoryIdentifier        = @"category2";
NSString     *kNotificationTimerExpiredCategoryIdentifier   = @"TIMER_EXPIRED";
NSDictionary *NSDictionaryFromNotificationSettings(UNNotificationSettings *settings);

@interface PushCenter : NSObject
+ (void)jpushRegistrationWithLaunchOptions:(NSDictionary *)launchOptions;
+ (void)jpushRegisterDeviceToken:(NSData *)token;
+ (void)jpushHandleRemoteNotification:(NSDictionary *)remoteInfo;
@end

#pragma mark - 
@interface NotificationCenter ()<UNUserNotificationCenterDelegate,PKPushRegistryDelegate>
@property(class,nonatomic,strong,readonly)NotificationCenter *shared;
@end
@implementation NotificationCenter
+ (void)notificationRegistrationWithLaunchOptions:(NSDictionary *)launchOptions
{
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound + UNAuthorizationOptionAlert;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"error:%@",error);
            return;
        }
        [self.shared configNotificationCategories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }];
    //注册极光
    [PushCenter jpushRegistrationWithLaunchOptions:launchOptions];
}
+ (void)voipRegistration
{
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    voipRegistry.delegate = self.shared;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}
#pragma mark -
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [PushCenter jpushHandleRemoteNotification:remoteInfo];
}
#pragma mark -
#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        //Remote
        [self handleRemoteNotification:notification.request.content.userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBadge);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    if([response.notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        //Remote
        [self handleRemoteNotification:response.notification.request.content.userInfo];
    }
    completionHandler();
}
#pragma mark -
#pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
    NSString *tokenDescription = [NSString stringWithFormat:@"\nPushKit Token:%@",credentials.token.hexString];
    NSLog(@"tokenDescription: %@",tokenDescription);
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [PushCenter jpushRegisterDeviceToken:credentials.token];
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type
{
    NSDictionary *alert = [[payload.dictionaryPayload objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *alertBody = nil;
    if ([alert isKindOfClass:NSDictionary.class]) {
        NSString *body = [alert objectForKey:@"body"];
        if ([body isKindOfClass:NSString.class]) {
            alertBody = body;
        }else{
            alertBody = payload.dictionaryPayload.description;
        }
    }else if ([alert isKindOfClass:NSString.class]){
        alertBody = (NSString *)alert;
    }else{
        alertBody = payload.dictionaryPayload.description;
    }
    NSString *sound = [[payload.dictionaryPayload objectForKey:@"aps"] objectForKey:@"sound"];
    if (!sound) {
        sound = @"test.caf";
    }
    [NotificationCenter scheduledLocalNotificationWithTitle:@"my title" subTitle:@"my subtitle" body:alertBody sound:sound badge:0 category:kNotificationInputCategoryIdentifier userInfo:payload.dictionaryPayload];
}
- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
#pragma mark -
+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken:%@",deviceToken.hexString);
    NSString *tokenDescription = [NSString stringWithFormat:@"\nDeviceToken:%@",deviceToken.hexString];
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [PushCenter jpushRegisterDeviceToken:deviceToken];
}
+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - <=iOS6
// <=iOS6
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo];
}
#pragma mark - iOS7
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - Handler
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [PushCenter jpushHandleRemoteNotification:remoteInfo];
}
#pragma mark -
#pragma mark -
+ (void)scheduledLocalNotificationWithTitle:(NSString *)titile
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
    content.categoryIdentifier = kNotificationInputCategoryIdentifier;
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
#pragma mark -
#pragma mark -
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
#pragma mark -
+ (NotificationCenter *)shared
{
    static NotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
@end

@implementation PushCenter
#pragma mark - JPush
+ (void)jpushRegistrationWithLaunchOptions:(NSDictionary *)launchOptions
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
    NSLog(@"JPush registrationID:%@",JPUSHService.registrationID);
}
+ (void)jpushRegisterDeviceToken:(NSData *)deviceToken
{
    NSString *tokenDescription = [NSString stringWithFormat:@"\nDeviceToken:%@",deviceToken.hexString];
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [JPUSHService registerDeviceToken:deviceToken];
}
+ (void)jpushHandleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}
@end

NSString *NSStringFromAuthorizationStatus(UNAuthorizationStatus status){
    switch (status) {
        case UNAuthorizationStatusNotDetermined:return @"NotDetermined";
        case UNAuthorizationStatusAuthorized   :return @"Authorized";
        case UNAuthorizationStatusDenied       :return @"Denied";
    }
}
NSString *NSStringFromNotificationSetting(UNNotificationSetting setting){
    switch (setting) {
        case UNNotificationSettingNotSupported:return @"NotSupported";
        case UNNotificationSettingEnabled     :return @"Enabled";
        case UNNotificationSettingDisabled    :return @"Disabled";
    }
}
NSString *NSStringFromAlertStyle(UNAlertStyle alertStyle){
    switch (alertStyle) {
        case UNAlertStyleNone  :return @"None";
        case UNAlertStyleBanner:return @"Banner";
        case UNAlertStyleAlert :return @"Alert";
    }
}
NSDictionary *NSDictionaryFromNotificationSettings(UNNotificationSettings *settings){
    return @{@"authorizationStatus"      :NSStringFromAuthorizationStatus(settings.authorizationStatus),
             @"soundSetting"             :NSStringFromNotificationSetting(settings.soundSetting),
             @"badgeSetting"             :NSStringFromNotificationSetting(settings.badgeSetting),
             @"alertSetting"             :NSStringFromNotificationSetting(settings.alertSetting),
             @"notificationCenterSetting":NSStringFromNotificationSetting(settings.notificationCenterSetting),
             @"lockScreenSetting"        :NSStringFromNotificationSetting(settings.lockScreenSetting),
             @"carPlaySetting"           :NSStringFromNotificationSetting(settings.carPlaySetting),
             @"alertStyle"               :NSStringFromAlertStyle(settings.alertStyle)
            };
}
