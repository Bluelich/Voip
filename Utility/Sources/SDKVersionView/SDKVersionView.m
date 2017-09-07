//
//  SDKVersionView.m
//  Voip
//
//  Created by zhouqiang on 07/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "SDKVersionView.h"
#import <ImSDK/ImSDK.h>
#import <QAVSDK/QAVSDK.h>
#import <ILiveSDK/ILiveSDK.h>
#import <TILCallSDK/TILCallSDK.h>

@interface SDKVersionView ()
@property (weak, nonatomic) IBOutlet UILabel *iLive_VersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *callSDK_VersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *qavSDK_VersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *imSDK__VersionLabel;
@end

@implementation SDKVersionView

+ (instancetype)loadViewFromNib
{
    SDKVersionView *view = [[NSBundle bundleForClass:self.class] loadNibNamed:@"SDKVersionView" owner:nil options:nil].lastObject;
    NSAssert(view.class == SDKVersionView.class,@"the view which load from nib is not kind of SDKVersionView");
    view.frame = CGRectZero;
    return view;
}
- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(300, 130);
    [super setFrame:frame];
}
- (void)setVersionInfo
{
    self.callSDK_VersionLabel.text = [[TILCallManager sharedInstance] getVersion];
    self.qavSDK_VersionLabel.text  = [QAVContext getVersion];
    self.iLive_VersionLabel.text   = [[ILiveSDK getInstance] getVersion];
    self.imSDK__VersionLabel.text  = [[TIMManager sharedInstance] GetVersion];
}
@end
