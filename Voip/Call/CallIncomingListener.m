//
//  CallIncomingListener.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/3.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallIncomingListener.h"
#import "CallMultiRecvViewController.h"
#import "CallC2CRecvViewController.h"
#import "AppDelegate.h"

@implementation CallIncomingListener
+ (void)load
{
     [[TILCallManager sharedInstance] setIncomingCallListener:self.shared];
}
+ (instancetype)shared
{
    static CallIncomingListener *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
- (void)onC2CCallInvitation:(TILCallInvitation *)invitation
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"C2CCall" bundle:nil];
    CallC2CRecvViewController *call = [storyboard instantiateViewControllerWithIdentifier:@"CallC2CRecvViewController"];
    call.invite = invitation;
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    [nav presentViewController:call animated:YES completion:nil];
}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{
//回复忙时
//    TILCallConfig * config = [[TILCallConfig alloc] init];
//    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
//    baseConfig.peerId = invitation.sponsorId;
//    baseConfig.callType = invitation.callType;
//    baseConfig.isSponsor = NO;
//    config.baseConfig = baseConfig;
//    
//    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
//    responderConfig.callInvitation = invitation;
//    config.responderConfig = responderConfig;
//    TILMultiCall *call = [[TILMultiCall alloc] initWithConfig:config];
//    [call responseLineBusy:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MultiCall" bundle:nil];
    CallMultiRecvViewController *call = [storyboard instantiateViewControllerWithIdentifier:@"CallMultiRecvViewController"];
    call.invite = invitation;
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    [nav presentViewController:call animated:YES completion:nil];
}

@end
