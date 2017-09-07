//
//  UIAlertController+Art.h
//  ArtChat
//
//  Created by zhouqiang on 17/04/2017.
//
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Art)
+(void)showAlertWithTitle:(nullable NSString *)title
                  message:(nullable NSString *)message
        cancelButtonTitle:(nullable NSString *)cancelButtonTitle;
/**
 UIAlertControllerStyleAlert
 */
+(void)showAlertWithTitle:(nullable NSString *)title
                  message:(nullable NSString *)message
        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
        otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
           didSelectBlock:(nullable void (^)(UIAlertAction * _Nonnull action,NSUInteger index))didSelectBlock
           didCancelBlock:(nullable void (^)())didCancelBlock;
/**
 UIAlertControllerStyleActionSheet
 */
+(void)showActionSheetWithTitle:(nullable NSString *)title
                        message:(nullable NSString *)message
              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
              otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                 didSelectBlock:(nullable void(^)(UIAlertAction * _Nonnull action,NSUInteger index))didSelectBlock
                 didCancelBlock:(nullable void(^)())didCancelBlock
NS_DEPRECATED_IOS(1_0, 1_0, "已经弃用,改用ArtActionSheet(暂时还没写)(TBActionSheet)");

/**
 @param style               UIAlertControllerStyle
 @param title               NSString
 @param message             NSString
 @param cancelButtonTitle   NSString
 @param otherButtonTitles   [NSString]
 @param didSelectBlock      取消调用
 @param didCancelBlock      选中button调用
 */
+(void)showWithStyle:(UIAlertControllerStyle)style
               title:(nullable NSString *)title
             message:(nullable NSString *)message
   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
   otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
      didSelectBlock:(nullable void(^)(UIAlertAction * _Nonnull action,NSUInteger index))didSelectBlock
      didCancelBlock:(nullable void(^)())didCancelBlock
NS_DEPRECATED_IOS(1_0, 1_0, "已经弃用,改用ArtActionSheet(暂时还没写)(TBActionSheet)");
@end



