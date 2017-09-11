//
//  MoveAbleView.m
//  Pods
//
//  Created by zhouqiang on 07/09/2017.
//
//

#import "MoveAbleView.h"

@interface MoveAbleView ()
{
    CGFloat kScreenWidth;
    CGFloat kScreenHeight;
    BOOL    constraintsHasBeenLoaded;
}
@property (nonatomic,assign)CGPoint  currentPoint;
@property (nonatomic,strong)NSLayoutConstraint *topConstraint;
@property (nonatomic,strong)NSLayoutConstraint *leadingConstraint;
@property (atomic   ,assign)BOOL  constraintsHasBeenLoaded;
@end

@implementation MoveAbleView
- (void)awakeFromNib
{
    [super awakeFromNib];
    kScreenWidth = UIScreen.mainScreen.bounds.size.width;
    kScreenHeight = UIScreen.mainScreen.bounds.size.height;
    self.userInteractionEnabled = YES;
    _currentPoint = CGPointMake(NSNotFound, NSNotFound);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.constraintsHasBeenLoaded) {
        return;
    }
    self.constraintsHasBeenLoaded = YES;
    CGFloat leading = CGRectGetMinX(self.frame);
    CGFloat top = CGRectGetMinY(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = @[].mutableCopy;
    [self.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == self || obj.secondItem == self){
            NSLayoutConstraint *constant = [NSLayoutConstraint constraintWithItem:obj.firstItem attribute:obj.firstAttribute relatedBy:obj.relation toItem:obj.secondItem attribute:obj.secondAttribute multiplier:obj.multiplier constant:obj.constant];
            constant.priority = obj.priority - 1;
            constant.shouldBeArchived = obj.shouldBeArchived;            
            [constraints addObject:constant];
            obj.active = NO;
        }
    }];
    [NSLayoutConstraint activateConstraints:constraints];
    self.topConstraint     = [self.topAnchor     constraintEqualToAnchor:self.superview.topAnchor     constant:top];
    self.topConstraint.priority = UILayoutPriorityRequired;
    self.leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:leading];
    self.leadingConstraint.priority = UILayoutPriorityRequired;
    NSLayoutConstraint *widthConstraint = [self.widthAnchor constraintEqualToConstant:width];
    widthConstraint.priority = UILayoutPriorityRequired;
    NSLayoutConstraint *heightConstraint = [self.widthAnchor constraintEqualToConstant:width];
    heightConstraint.priority = UILayoutPriorityRequired;
    [NSLayoutConstraint activateConstraints:@[self.topConstraint,
                                              self.leadingConstraint,
                                              widthConstraint,
                                              heightConstraint]];
}
#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [self pointOfTouches:touches];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [self pointOfTouches:touches];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [self pointOfTouches:touches];
    self.currentPoint = CGPointMake(NSNotFound, NSNotFound);
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [self pointOfTouches:touches];
    self.currentPoint = CGPointMake(NSNotFound, NSNotFound);
}
#pragma mark -
- (CGPoint)pointOfTouches:(NSSet<UITouch *> *)touches
{
    CGPoint point = [[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    return point;
}
#pragma mark -
- (void)setCurrentPoint:(CGPoint)currentPoint
{
    [self configPositionWithCurrentPoint:currentPoint lastPoint:_currentPoint];
    _currentPoint = currentPoint;
}
- (void)configPositionWithCurrentPoint:(CGPoint)currentPoint lastPoint:(CGPoint)lastPoint
{
    if (lastPoint.x == NSNotFound || lastPoint.y == NSNotFound) {
        return;
    }
    CGRect frame = self.frame;
    if (currentPoint.x == NSNotFound || currentPoint.y == NSNotFound) {
        CGFloat x = 0;
        if (CGRectGetMinX(frame) >= (kScreenWidth - CGRectGetWidth(frame)) / 2.) {
            x = kScreenWidth - CGRectGetWidth(frame);
        }
        frame.origin.x = x;
        [self updateWithTargetFrame:frame animated:YES];
        return;
    }
    CGFloat distance_x = currentPoint.x - lastPoint.x;
    CGFloat distance_y = currentPoint.y - lastPoint.y;
    CGFloat x = MAX(0, MIN(distance_x + CGRectGetMinX(frame), kScreenWidth - CGRectGetWidth(frame)));
    CGFloat y = MAX(0, MIN(distance_y + CGRectGetMinY(frame), kScreenHeight - CGRectGetHeight(frame)));
    frame.origin.x = x;
    frame.origin.y = y;
    [self updateWithTargetFrame:frame animated:NO];
}
- (void)updateWithTargetFrame:(CGRect)frame animated:(BOOL)animated
{
    self.topConstraint.constant = CGRectGetMinY(frame);
    self.leadingConstraint.constant = CGRectGetMinX(frame);
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self.superview layoutIfNeeded];
    }];
}
@end
