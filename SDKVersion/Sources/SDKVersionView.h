//
//  SDKVersionView.h
//  Voip
//
//  Created by zhouqiang on 07/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import <Utility/MoveAbleView.h>

@interface SDKVersionView : MoveAbleView

+ (instancetype)loadViewFromNib;
- (void)setVersionInfo;

@end