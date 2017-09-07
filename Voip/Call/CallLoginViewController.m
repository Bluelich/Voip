//
//  CallLoginViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/10/26.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallLoginViewController.h"
#import "CallRegisterViewController.h"
#import "CallC2CMainViewController.h"
#import "CallMultiMainViewController.h"
#import <ILiveSDK/ILiveLoginManager.h>
#import "CallIncomingListener.h"
#import <QAVSDK/QAVSDK.h>

@interface CallLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
- (IBAction)login:(id)sender;
- (IBAction)registe:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic,  copy)NSString *name;
@property (nonatomic,  copy)NSString *pwd;
@end

@implementation CallLoginViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getUserDefault];
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getUserDefault];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self getUserDefault];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.text = self.name;
    self.passTextField.text = self.pwd;
}
- (IBAction)login:(id)sender {
    [self tlsLogin];
}
- (void)autoLogin
{
    [self tlsLogin];
}
//托管模式登录
- (void)tlsLogin{
    __weak typeof(self) ws = self;
    if (self.nameTextField.text.length > 0) {
        self.name = self.nameTextField.text;
    }
    if (self.passTextField.text.length > 0) {
        self.pwd = self.passTextField.text;
    }
    [[ILiveLoginManager getInstance] tlsLogin:self.name pwd:self.pwd succ:^{
        [ws setUserDefault];
        if(ws.segmentControl.selectedSegmentIndex == 0){
            CallC2CMainViewController *call = [ws.storyboard instantiateViewControllerWithIdentifier:@"CallC2CMainViewController"];
            [ws.navigationController pushViewController:call animated:YES];
        }
        else{
            CallMultiMainViewController *call = [ws.storyboard instantiateViewControllerWithIdentifier:@"CallMultiMainViewController"];
            [ws.navigationController pushViewController:call animated:YES];
        }
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        ws.errLabel.text = [NSString stringWithFormat:@"moldleID=%@;errid=%d;errmsg=%@",moudle,errId,errMsg];
    }];
}

//独立模式登录
- (void)iLiveLogin{
    NSString *name = self.nameTextField.text;
    NSString *pwd = self.passTextField.text;
    NSString *urlStr = [NSString stringWithFormat:@"http://182.254.234.225:8085/login?account=%@&password=%@",name,pwd];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(session) wsession = session;
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [wsession invalidateAndCancel];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(error || httpResponse.statusCode != 200 || data == nil){
            //请求sig出错
        }
        //请求sig成功
        NSString *sig = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[ILiveLoginManager getInstance] iLiveLogin:name sig:sig succ:^{
            //独立模式登录成功
        } failed:^(NSString *moudle, int errId, NSString *errMsg) {
            //独立模式登录失败
        }];
    }];
    [task resume];
}

- (IBAction)registe:(id)sender {
    [self performSegueWithIdentifier:@"toCallRegister" sender:nil];
}

- (void)getUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *pwd = [userDefaults objectForKey:@"pwd"];
    if (!name) {
        name = @"bjzq";
    }
    if (!pwd) {
        pwd = @"123456789";
    }
    self.nameTextField.text = name;
    self.passTextField.text = pwd;
    self.name = name;
    self.pwd = pwd;
}

- (void)setUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.name forKey:@"name"];
    [userDefaults setObject:self.pwd forKey:@"pwd"];
    [userDefaults synchronize];
}
@end
