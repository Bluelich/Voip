//
//  SDKVersionViewController.m
//  Voip
//
//  Created by zhouqiang on 07/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "SDKVersionViewController.h"
#import "SDKVersionView.h"

@interface SDKVersionViewController ()

@property (nonatomic,strong)SDKVersionView *versionView;

@end

@implementation SDKVersionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.versionView.frame, point)) {
        return YES;
    }
    return NO;
}
#pragma mark - Views
- (void)setupViews
{
    self.view.backgroundColor = [UIColor clearColor];
    self.versionView = [SDKVersionView loadViewFromNib];
    [self.versionView setVersionInfo];
    [self.view addSubview:self.versionView];
    [self setupLayout];
}
- (void)setupLayout
{
    
}
@end
