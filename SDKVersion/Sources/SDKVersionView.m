//
//  SDKVersionView.m
//  Voip
//
//  Created by Bluelich on 07/09/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
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
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    if (self.subviews.count == 0) {
        UIView *view = [self.class instantiateRealViewFromPlaceholder:self];
        return view;
    }
    return self;
}
- (void)setVersionInfo
{
    self.callSDK_VersionLabel.text = [[TILCallManager sharedInstance] getVersion];
    self.qavSDK_VersionLabel.text  = [QAVContext getVersion];
    self.iLive_VersionLabel.text   = [[ILiveSDK getInstance] getVersion];
    self.imSDK__VersionLabel.text  = [[TIMManager sharedInstance] GetVersion];
}
#pragma mark - Views
+ (UIView *)instantiateRealViewFromPlaceholder:(UIView *)view
{
    UIView *realView = [[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    {
        //Copy properties
        realView.tag = view.tag;
        realView.frame = view.frame;
        realView.alpha = view.alpha;
        realView.opaque = view.opaque;
        realView.hidden = view.hidden;
        realView.bounds = view.bounds;
        realView.tintColor = view.tintColor;
        realView.contentMode = view.contentMode;
        realView.clipsToBounds = view.clipsToBounds;
        realView.contentStretch = view.contentStretch;
        realView.backgroundColor = view.backgroundColor;
        realView.autoresizingMask = view.autoresizingMask;
        realView.contentScaleFactor = view.contentScaleFactor;
        realView.autoresizesSubviews = view.autoresizesSubviews;
        realView.multipleTouchEnabled = view.multipleTouchEnabled;
        realView.userInteractionEnabled = view.userInteractionEnabled;
        realView.semanticContentAttribute = view.semanticContentAttribute;
        realView.clearsContextBeforeDrawing = view.clearsContextBeforeDrawing;
        realView.translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints;
    }
    if (view.constraints.count == 0) {
        return realView;
    }
    // Copy autolayout constrains.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Fix crash when using 2.3.1 in UICollectionViews or similar
        (void)view;
    });
    // We only need to copy "self" constraints (like width/height constraints) from placeholder to real view
    [view.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint* newConstraint = nil;
        if (obj.secondItem == nil) {
            // Height | Width, first = self, second = nil
            newConstraint = [NSLayoutConstraint constraintWithItem:realView attribute:obj.firstAttribute relatedBy:obj.relation toItem:nil attribute:obj.secondAttribute multiplier:obj.multiplier constant:obj.constant];
        }else if ([obj.firstItem isEqual:obj.secondItem]){
            // Aspect ratio, first = second  = self
            newConstraint = [NSLayoutConstraint constraintWithItem:realView attribute:obj.firstAttribute relatedBy:obj.relation toItem:realView attribute:obj.secondAttribute multiplier:obj.multiplier constant:obj.constant];
        }
        if (newConstraint) {
            // Copy properties to new constraint
            newConstraint.shouldBeArchived = obj.shouldBeArchived;
            newConstraint.priority = obj.priority;
            if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
                newConstraint.identifier = obj.identifier;
            }
            [realView addConstraint:newConstraint];
        }
    }];
    return realView;
}
+ (UIView *)viewFromNib
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:self.class]) {
            return view;
        }
    }
    NSAssert(NO, @"Expect file: %@", [NSString stringWithFormat:@"%@.xib", NSStringFromClass(self)]);
    return nil;
}
@end
