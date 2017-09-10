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
}
@property (nonatomic,assign)CGPoint  currentPoint;
@property (nonatomic,strong)NSLayoutConstraint *top;
@property (nonatomic,strong)NSLayoutConstraint *leading;
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
    [self.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == self) {
            NSLog(@"");
            switch (obj.firstAttribute) {
                case NSLayoutAttributeTop:
                    self.top = obj;
                    break;
                case NSLayoutAttributeLeading:
                    self.leading = obj;
                    break;
                default:
                    break;
            }
        }
    }];
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
    self.top.constant = CGRectGetMinY(frame);
    self.leading.constant = CGRectGetMinX(frame);
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self.superview layoutIfNeeded];
    }];
}
@end
