//
//  SDKVersionWindow.m
//  Voip
//
//  Created by zhouqiang on 07/09/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "SDKVersionWindow.h"
#import "SDKVersionViewController.h"

@interface SDKVersionWindow ()

@property (class,nonatomic,strong,readonly)SDKVersionWindow *window;

@end

@implementation SDKVersionWindow
+ (void)setHidden:(BOOL)hidden
{
    self.window.hidden = hidden;
}
+ (BOOL)isHidden
{
    return self.window.isHidden;
}
+ (instancetype)window
{
    static dispatch_once_t onceToken;
    static SDKVersionWindow *window;
    dispatch_once(&onceToken, ^{
        window = [[SDKVersionWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        window.backgroundColor = [UIColor clearColor];
        window.rootViewController = [SDKVersionViewController new];
        window.windowLevel = 2002;
        window.hidden = NO;
    });
    return window;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIViewController *controller = self.rootViewController;
    if (controller.class != SDKVersionViewController.class) {
        return NO;
    }
    return [(SDKVersionViewController *)controller pointInside:point withEvent:event];
}
@end
