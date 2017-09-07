//
//  AppDelegate+PushKit.m
//  Voip
//
//  Created by zhouqiang on 06/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate+PushKit.h"
#import <PushKit/PushKit.h>
#import <Utility/Constant.h>
#import <JPush/JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate+NotificationCenter.h"

@interface AppDelegate (_PushKit_) <PKPushRegistryDelegate>

@end

@implementation AppDelegate (PushKit)
#pragma mark - PushKit Registration
- (void)voipRegistration
{
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    voipRegistry.delegate = self;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}
#pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
    NSLog(@"PushKit Token:%@",NSStrinWithHexFormatFromData(credentials.token));
    //9418CACB8216173D589057266C722DEA1BC7F3EC96DAFE440FCB62A51B6BAC52
    NSString *tokenDescription = [NSString stringWithFormat:@"\nPushKit Token:%@",NSStrinWithHexFormatFromData(credentials.token)];
    if ([UIPasteboard generalPasteboard].string.length > 0) {
        [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingString:@"\n"];
    }
    [UIPasteboard generalPasteboard].string = [[UIPasteboard generalPasteboard].string stringByAppendingFormat:@"%@",tokenDescription];
    [JPUSHService registerDeviceToken:credentials.token];
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
    [self scheduledLocalNotificationWithTitle:@"my title" subTitle:@"my subtitle" body:alertBody sound:sound badge:0 category:@"" userInfo:payload.dictionaryPayload];
}
- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//#pragma clang diagnostic pop









