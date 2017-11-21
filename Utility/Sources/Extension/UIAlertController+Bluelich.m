//
//  UIAlertController+Bluelich.m
//  ArtChat
//
//  Created by zhouqiang on 17/04/2017.
//
//

#import "UIAlertController+Bluelich.h"

@implementation UIAlertController (Bluelich)
+(void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelButtonTitle
{
    [UIAlertController showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil didSelectBlock:nil didCancelBlock:nil];
}
+(void)showAlertWithTitle:(nullable NSString *)title
                  message:(nullable NSString *)message
        cancelButtonTitle:(nullable NSString *)cancelButtonTitle
        otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
           didSelectBlock:(nullable void (^)(UIAlertAction *action,NSUInteger index))didSelectBlock
           didCancelBlock:(nullable void (^)())didCancelBlock
{
    [UIAlertController showWithStyle:UIAlertControllerStyleAlert
                               title:title
                             message:message
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles
                      didSelectBlock:didSelectBlock
                      didCancelBlock:didCancelBlock];
}

+(void)showActionSheetWithTitle:(nullable NSString *)title
                        message:(nullable NSString *)message
              cancelButtonTitle:(nullable NSString *)cancelButtonTitle
              otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                 didSelectBlock:(nullable void (^)(UIAlertAction *action,NSUInteger index))didSelectBlock
                 didCancelBlock:(nullable void (^)())didCancelBlock
{
    [UIAlertController showWithStyle:UIAlertControllerStyleActionSheet
                               title:title
                             message:message
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles
                      didSelectBlock:didSelectBlock
                      didCancelBlock:didCancelBlock];
}
+(void)showWithStyle:(UIAlertControllerStyle)style
               title:(nullable NSString *)title
             message:(nullable NSString *)message
   cancelButtonTitle:(nullable NSString *)cancelButtonTitle
   otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
      didSelectBlock:(nullable void (^)(UIAlertAction *action,NSUInteger index))didSelectBlock
      didCancelBlock:(nullable void (^)())didCancelBlock
{
    //Prevent Assembly
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.f) {
        return;
    }
    if (style == UIAlertControllerStyleActionSheet &&
        [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
//    alertController.view.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !didSelectBlock ?: didSelectBlock(action,i);
        }]];
    }
    if (cancelButtonTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !didCancelBlock ?: didCancelBlock();
        }]];
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
//    if (alertController.popoverPresentationController != nil) {
//        alertController.popoverPresentationController.sourceRect = [UIScreen mainScreen].bounds;
//        alertController.popoverPresentationController.sourceView = controller.view;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}
@end
