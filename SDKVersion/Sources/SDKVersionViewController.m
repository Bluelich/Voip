//
//  SDKVersionViewController.m
//  Pods
//
//  Created by zhouqiang on 08/09/2017.
//
//

#import "SDKVersionViewController.h"
#import "SDKVersionView.h"

@interface SDKVersionViewController ()

@property (weak, nonatomic) IBOutlet SDKVersionView *versionView;

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
    [self.versionView setVersionInfo];
}
@end
