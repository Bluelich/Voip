//
//  CallC2CRecvViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallC2CRecvViewController.h"
#import <TILCallSDK/TILCallSDK.h>
#import <ILiveSDK/ILiveLoginManager.h>
#import <ILiveSDK/ILiveRoomManager.h>
#import <ImSDK/ImSDK.h>

@interface CallC2CRecvViewController () <TILCallNotificationListener,TILCallMemberEventListener,TILCallStatusListener,TILCallMessageListener>
@property (nonatomic, strong)TILC2CCall     *call;
@property (nonatomic, strong)NSString       *myId;
@property (nonatomic,strong)AVAudioPlayer   *bg_player;
@end

@implementation CallC2CRecvViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setText:[NSString stringWithFormat:@"收到%@的视频邀请",_invite.sponsorId]];
    [self setButtonEnable:NO];
    [self initCall];
    _myId = [[ILiveLoginManager getInstance] getLoginId];
}

#pragma mark - 通话接口相关

- (void)initCall{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = NO;
    baseConfig.peerId = _invite.sponsorId;
    baseConfig.heartBeatInterval = 5;
    baseConfig.isAutoResponseBusy = YES;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    listener.callStatusListener = self;
    //注意：
    //［通知回调］可以获取通话的事件通知，建议双人和多人都走notifListener
    // [通话状态回调] 也可以获取通话的事件通知
    listener.memberEventListener = self;
    listener.notifListener = self;
    listener.msgListener = self;
    
    config.callListener = listener;
    
    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
    responderConfig.callInvitation = _invite;
    responderConfig.controlRole = @"interactTest";
    config.responderConfig = responderConfig;
    _call = [[TILC2CCall alloc] initWithConfig:config];
}

- (IBAction)recvInvite:(id)sender {
    __weak typeof(self) ws = self;
    [_call createRenderViewIn:self.view];
    [_call accept:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"接受失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [ws selfDismiss];
        }
        else{
            [ws setText:@"通话建立成功"];
            [ws setButtonEnable:YES];
        }
    }];
}


- (IBAction)rejectInvite:(id)sender {
    __weak typeof(self) ws = self;
    [_call refuse:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"拒绝失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
        }
        else{
            [ws setText:@"拒绝成功"];
            [ws selfDismiss];
        }
    }];
}

- (IBAction)hangUp:(id)sender {
    __weak typeof(self) ws = self;
    [_call hangup:^(TILCallError *err) {
        if(err){
            [ws setText:[NSString stringWithFormat:@"挂断失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
        }
        else{
            [ws setText:@"挂断成功"];
            [ws selfDismiss];
        }
    }];
}

#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    if(isOn){
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            if([identifier isEqualToString:_myId]){
                [_call addRenderFor:_myId atFrame:self.view.bounds];
                [_call sendRenderViewToBack:_myId];
            }
            else{
                [_call addRenderFor:identifier atFrame:CGRectMake(20, 20, 120, 160)];
            }
        }
    }
    else{
        for (TILCallMember *member in members) {
            NSString *identifier = member.identifier;
            [_call removeRenderFor:identifier];
        }
    }
}


#pragma mark - 通知回调
//注意：
//［通知回调］可以获取通话的事件通知
// [通话状态回调] 也可以获取通话的事件通知
- (void)onRecvNotification:(TILCallNotification *)notify
{
    //    TILCALL_NOTIF_ACCEPTED      = 0x82,
    //    TILCALL_NOTIF_CANCEL,
    //    TILCALL_NOTIF_TIMEOUT,
    //    TILCALL_NOTIF_REFUSE,
    //    TILCALL_NOTIF_HANGUP,
    //    TILCALL_NOTIF_LINEBUSY,
    //    TILCALL_NOTIF_HEARTBEAT     = 0x88,
    //    TILCALL_NOTIF_INVITE        = 0x89,
    //    TILCALL_NOTIF_DISCONNECT    = 0x8A,
    
    NSInteger notifId = notify.notifId;
    NSString *sender = notify.sender;
    switch (notifId) {
        case TILCALL_NOTIF_CANCEL:
            [self setText:@"对方取消邀请"];
            [self selfDismiss];
            break;
        case TILCALL_NOTIF_TIMEOUT:
            [self setText:@"对方呼叫超时"];
            [self selfDismiss];
            break;
        case TILCALL_NOTIF_HANGUP:
            [self setText:@"对方已挂断"];
            [self selfDismiss];
            break;
        case TILCALL_NOTIF_HEARTBEAT:
            [self setText:[NSString stringWithFormat:@"%@发来心跳",sender]];
            break;
        case TILCALL_NOTIF_DISCONNECT:
            [self setText:@"对方失去连接"];
            [self selfDismiss];
            break;
        default:
            break;
    }
}


#pragma mark - 通话状态事件回调
- (void)onCallEstablish{
    [self stopBg];
    [self setText:@"通话建立成功"];
    [self setButtonEnable:YES];
}

- (void)onCallEnd:(TILCallEndCode)code
{
    switch (code) {
        case TILCALL_END_SPONSOR_CANCEL:
            [self setText:@"对方已取消通话"];
            break;
        case TILCALL_END_SPONSOR_TIMEOUT:
            [self setText:@"对方已结束通话"];
            break;
        case TILCALL_END_PEER_HANGUP:
            [self setText:@"对方已挂断"];
            break;
        default:
            break;
    }
    [self selfDismiss];
}

#pragma mark - 设备操作（使用ILiveRoomManager接口，也可以使用TILCallSDK接口）
- (IBAction)closeCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    __weak typeof(self) ws = self;
    [manager enableCamera:pos enable:!isOn succ:^{
        NSString *text = !isOn?@"打开摄像头成功":@"关闭摄像头成功";
        [ws setText:text];
        [ws.closeCameraButton setTitle:(!isOn?@"关闭摄像头":@"打开摄像头") forState:UIControlStateNormal];
    }failed:^(NSString *moudle, int errId, NSString *errMsg) {
        NSString *text = !isOn?@"打开摄像头失败":@"关闭摄像头失败";
        [ws setText:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg]];
    }];
}

- (IBAction)switchCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    [manager switchCamera:^{
        [ws setText:@"切换摄像头成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws setText:[NSString stringWithFormat:@"切换摄像头失败:%@-%d-%@",moudle,errId,errMsg]];
    }];
}

- (IBAction)closeMic:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    __weak typeof(self) ws = self;
    [manager enableMic:!isOn succ:^{
        NSString *text = !isOn?@"打开麦克风成功":@"关闭麦克风成功";
        [ws setText:text];
        [ws.closeMicButton setTitle:(!isOn?@"关闭麦克风":@"打开麦克风") forState:UIControlStateNormal];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        NSString *text = !isOn?@"打开麦克风失败":@"关闭麦克风失败";
        [ws setText:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg]];
    }];
}

- (IBAction)switchReceiver:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    QAVOutputMode mode = [manager getCurAudioMode];
    [ws setText:(mode == QAVOUTPUTMODE_EARPHONE?@"切换扬声器成功":@"切换到听筒成功")];
    [ws.switchReceiverButton setTitle:(mode == QAVOUTPUTMODE_EARPHONE?@"切换到听筒":@"切换扬声器") forState:UIControlStateNormal];
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
    }
}

- (IBAction)onBeautyChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[ILiveRoomManager getInstance] setBeauty:slider.value];
}

- (IBAction)onWhiteChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [[ILiveRoomManager getInstance] setWhite:slider.value];
}

- (IBAction)switchRenderView:(id)sender {
    [_call switchRenderView:_invite.sponsorId with:_myId];
}


#pragma mark - 界面管理
- (void)setButtonEnable:(BOOL)isAccept{
    _closeCameraButton.enabled = isAccept;
    _switchCameraButton.enabled = isAccept;
    _closeMicButton.enabled = isAccept;
    _switchReceiverButton.enabled = isAccept;
    _hangUpButton.enabled = isAccept;
    _recvInviteButton.enabled = !isAccept;
    _rejectButton.enabled = !isAccept;
    _switchRenderButton.enabled = isAccept;
}

- (void)setText:(NSString *)text
{
    NSString *tempText = _textView.text;
    tempText = [tempText stringByAppendingString:@"\n"];
    tempText = [tempText stringByAppendingString:text];
    _textView.text = tempText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)selfDismiss
{
    [self stopBg];
    __weak typeof(self) ws = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"dismiss" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [ws dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onNewMessages:(NSArray *)messages
{
    NSString *text = ((TIMTextElem *)[messages[0] getElem:0]).text;
    NSLog(@"%@",text);
}
- (void)playBg
{
    if (!self.bg_player) {
        NSError *error = nil;
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        BOOL success = [AVAudioSession.sharedInstance overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        if (!success) {
            NSLog(@"error:%@",error);
        }
        [AVAudioSession.sharedInstance setActive:YES error:&error];
        self.bg_player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self.class bgMusicPath]] error:nil];
        self.bg_player.numberOfLoops = -1;
        [self.bg_player prepareToPlay];
    }
    [self.bg_player play];
}
- (void)stopBg
{
    if (self.bg_player.isPlaying) {
        [self.bg_player stop];
    }
}
+ (NSString *)bgMusicPath
{
    return [[NSBundle mainBundle] pathForResource:@"art_call" ofType:@"caf"];
}
@end
