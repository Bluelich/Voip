//
//  CallMultiMainViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallMultiMainViewController.h"
#import "CallMultiMakeViewController.h"
#import "CallIncomingListener.h"
#import <ILiveSDK/ILiveLoginManager.h>

@interface CallMultiMainViewController () <UITextFieldDelegate>
@end

@implementation CallMultiMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.userLabel.text = [[ILiveLoginManager getInstance] getLoginId];
    [[TILCallManager sharedInstance] setIncomingCallListener:[[CallIncomingListener alloc] init]];
}

//登出
- (IBAction)logout:(id)sender {
    __weak typeof(self) ws = self;
    [[ILiveLoginManager getInstance] tlsLogout:^{
        [ws.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

//发起呼叫
- (IBAction)makeCall:(id)sender {
#if TARGET_IPHONE_SIMULATOR //模拟器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"模拟器无法拨号" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
#elif TARGET_OS_IPHONE //真机    
    NSString *peerId = self.peerTextField.text;
    if(peerId.length <= 0){
        return;
    }
    CallMultiMakeViewController *make = [self.storyboard instantiateViewControllerWithIdentifier:@"CallMultiMakeViewController"];
    NSArray *tempArray = [self.peerTextField.text componentsSeparatedByString:@" "];
    make.memberArray = tempArray;
    [self presentViewController:make animated:YES completion:nil];
#endif
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
