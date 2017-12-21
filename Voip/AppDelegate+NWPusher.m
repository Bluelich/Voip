//
//  AppDelegate+NWPusher.m
//  Voip
//
//  Created by Bluelich on 05/09/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import "AppDelegate+NWPusher.h"
#import <NWPusher/NWPusher.h>
#import <NWPusher/NWPushFeedback.h>
#import <YYModel/YYModel.h>

@interface AppDelegate (__NWPusher__)

@property (nonatomic,strong)NWPusher *pusher;

@end

@implementation AppDelegate (NWPusher)

//To create a connection directly from a PKCS12 (.p12) file
- (void)connect
{
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NWPusher *pusher = pusher = [NWPusher connectWithPKCS12Data:pkcs12 password:@"pa$$word" environment:NWEnvironmentAuto error:&error];
    if (!error) {
        NSLog(@"Connected to APNs");
    } else {
        NSLog(@"Unable to connect: %@", error);
    }
}
//When pusher is successfully connected, send a payload to your device
- (void)pushWithToken:(NSString *)token payload:(NSDictionary *)payload
{
    if (!payload) {
        payload = @{@"aps":@{
                            @"alert":@"Testing..."
                            }
                    };
    }
    NSError *error = nil;
    if ([self.pusher pushPayload:payload.yy_modelToJSONString token:token identifier:rand() error:&error]) {
        NSLog(@"Pushed to APNs");
    } else {
        NSLog(@"Unable to push: %@", error);
    }
}
//After a second or so, we can take a look to see if the notification was accepted by Apple
- (void)take_a_look
{
    NSUInteger identifier = 0;
    NSError *apnError = nil;
    NSError *error = nil;
    BOOL read = [self.pusher readFailedIdentifier:&identifier apnError:&apnError error:&error];
    if (read && apnError) {
        NSLog(@"Notification with identifier %i rejected: %@", (int)identifier, apnError);
    } else if (read) {
        NSLog(@"Read and none failed");
    } else {
        NSLog(@"Unable to read: %@", error);
    }
}
//The feedback service is part of the Apple Push Notification service. The feedback service is basically a list containing device tokens that became invalid. Apple recommends that you read from the feedback service once every 24 hours, and no longer send notifications to listed devices. Note that this can be used to find out who removed your app from their device.
- (void)feedback
{
    //Communication with the feedback service can be done with the NWPushFeedback class. First connect using one of the connect methods:
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NWPushFeedback *feedback = [NWPushFeedback connectWithPKCS12Data:pkcs12 password:@"pa$$word" environment:NWEnvironmentAuto error:&error];
    if (feedback) {
        NSLog(@"Connected to feedback service");
    } else {
        NSLog(@"Unable to connect to feedback service: %@", error);
        return;
    }
    {
        //When connected read the device token and date of invalidation
        NSError *error = nil;
        NSArray *pairs = [feedback readTokenDatePairsWithMax:100 error:&error];
        if (pairs) {
            NSLog(@"Read token-date pairs: %@", pairs);
        } else {
            NSLog(@"Unable to read feedback: %@", error);
        }
    }
}
@end
