//
//  AppDelegate.m
//  Voip
//
//  Created by Bluelich on 04/09/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationCenter.h"
#import "CallLoginViewController.h"

#import <Utility/Utility.h>
#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

#import <ImSDK/ImSDK.h>
#import <QAVSDK/QAVSDK.h>
#import <ILiveSDK/ILiveSDK.h>
#import <TILCallSDK/TILCallSDK.h>
#import <ILiveSDK/ILiveLoginManager.h>
#import <SDKVersion/SDKVersionWindow.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()

@property (nonatomic,assign)UIBackgroundTaskIdentifier  backTaskId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [UIPasteboard generalPasteboard].string = @"";
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    BOOL background = application.applicationState == UIApplicationStateBackground;
    NSLog(@"background:%@",background ? @"YES" : @"NO");
    //注册通知
    [NotificationCenter notificationRegistrationWithLaunchOptions:launchOptions];
    //注册Voip
    [NotificationCenter voipRegistration];
    //登录账户
//    [self callLogin];
    return YES;
}
#pragma mark - Call
- (void)callLogin
{
    [[ILiveSDK getInstance] initSdk:kCallAppID accountType:kAccountType];
    NSString *callSDKVersion = [[TILCallManager sharedInstance] getVersion];
    NSString *qavsdkVersion  = [QAVContext getVersion];
    NSString *ilivesdkVersion  = [[ILiveSDK getInstance] getVersion];
    NSString *imVersion = [[TIMManager sharedInstance] GetVersion];
    NSLog(@"\ncallSDKVersion:%@\nqavsdkVersion:%@\nilivesdkVersion:%@\nimVersion:%@",
          callSDKVersion,qavsdkVersion,ilivesdkVersion,imVersion);
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    CallLoginViewController *loginController = (CallLoginViewController *)nav.topViewController;
    [loginController autoLogin];
    SDKVersionWindow.hidden = NO;
}
#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId != UIBackgroundTaskInvalid &&
       self.backTaskId != UIBackgroundTaskInvalid){
        [[UIApplication sharedApplication] endBackgroundTask:self.backTaskId];
    }
}
#pragma mark -
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://yourserver.com/data.json"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }
        
        // 解析响应/数据以决定新内容是否可用
        BOOL hasNewData = arc4random()%2;
        if (hasNewData) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
    // 开始任务
    [task resume];
}
#pragma mark -
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}
#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;
- (NSPersistentContainer *)persistentContainer
{
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Voip"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    /*
                     * 文件夹不存在,无法创建,或者没有权限写入数据
                     * 设备锁屏下数据受保护或权限问题
                     * 空间不足.
                     * 无法迁移到当前版本
                     * ...
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}
#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
