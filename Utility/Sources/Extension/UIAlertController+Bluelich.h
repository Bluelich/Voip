//
//  UIAlertController+Bluelich.h
//  ArtChat
//
//  Created by Bluelich on 17/04/2017.
//
//

#import <UIKit/UIKit.h>

#define BL_Deprecated_Will_Be_Removed_In(version) \
__attribute__((deprecated("This method has been deprecated and will be removed in" version ".")))

#define BL_Deprecated_Will_Be_Removed_In_Please_Use(since_version,method) \
__attribute__((deprecated("This method has been deprecated and will be removed in " since_version ". Please use `" METHOD "` instead.")))
#define BL_Deprecated(msg) __attribute((deprecated(msg)))

@interface UIAlertController (Bluelich)
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
                 didCancelBlock:(nullable void(^)())didCancelBlock BL_Deprecated_Will_Be_Removed_In("aaa");

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



