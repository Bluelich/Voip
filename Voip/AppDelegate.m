//
//  AppDelegate.m
//  Voip
//
//  Created by zhouqiang on 04/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+PushKit.h"
#import "AppDelegate+Notification.h"

#import <Utility/Constant.h>
#import <Utility/UIAlertController+Art.h>
#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

#import <ImSDK/ImSDK.h>
#import <QAVSDK/QAVSDK.h>
#import <ILiveSDK/ILiveSDK.h>
#import <TILCallSDK/TILCallSDK.h>
#import <ILiveSDK/ILiveLoginManager.h>
#import "CallLoginViewController.h"
#import "SDKVersionWindow.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()<NSURLSessionDelegate>

@property (nonatomic,assign)UIBackgroundTaskIdentifier  backTaskId;
@property (nonatomic,strong)NSMutableDictionary *completionHandlerDictionary;
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
    [self notificationRegistrationWithLaunchOptions:launchOptions];
    //注册Voip
//    [self voipRegistration];
    //登录账户
    [self callLogin];
//    [MPRemoteCommandCenter.sharedCommandCenter.playCommand addTarget:self action:NSSelectorFromString(@"sel")];
//    [MPRemoteCommandCenter.sharedCommandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
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
- (NSURLSession *)backgroundURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"io.objc.backgroundTransferExample";
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return session;
}
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"downloadTask:%@ didFinishDownloadingToURL:%@", downloadTask.taskDescription, location);
    // 必须用 NSFileManager 将文件复制到应用的存储中，因为临时文件在方法返回后会被删除
    // ...
    // 通知 UI 刷新
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
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
#pragma mark - 后台的任务完成后如果应用没有在前台运行，需要实现UIApplication的delegate让系统唤醒应用
- (void) application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    // 你必须重新建立一个后台 seesiong 的参照
    // 否则 NSURLSessionDownloadDelegate 和 NSURLSessionDelegate 方法会因为
    // 没有 对 session 的 delegate 设定而不会被调用。参见上面的 backgroundURLSession
    NSURLSession *backgroundSession = [self backgroundURLSession];
    
    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
    
    // 保存 completion handler 以在处理 session 事件后更新 UI
    [self addCompletionHandler:completionHandler forSession:identifier];
}
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Background URL session %@ finished events.", session);
    if (session.configuration.identifier) {
        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
        [self callCompletionHandlerForSession:session.configuration.identifier];
    }
}
#pragma mark -
- (void)addCompletionHandler:(void (^)())handler forSession:(NSString *)identifier
{
    if ([self.completionHandlerDictionary objectForKey:identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier. This should not happen.");
    }
    [self.completionHandlerDictionary setObject:handler forKey:identifier];
}
- (void)callCompletionHandlerForSession: (NSString *)identifier
{
    void (^handler)() = [self.completionHandlerDictionary objectForKey: identifier];
    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler for session %@", identifier);
        handler();
    }
}
#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    
}
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    
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
