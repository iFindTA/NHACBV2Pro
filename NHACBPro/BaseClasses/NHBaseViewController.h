//
//  NHBaseViewController.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHAFEngine.h"
#import "NHDBEngine.h"
#import "DQAlertView.h"
#import "JGActionSheet.h"

typedef enum {
    NHViewErrorTypeNone                 =       0,
    NHViewErrorType404                  =       1 << 0,
    NHViewErrorTypeNetwork              =       1 << 1,
    NHViewErrorTypeEmpty                =       1 << 2
}NHViewErrorType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^NHUsrAuthorityEvent)(BOOL success);

@interface NHBaseViewController : UIViewController

/**
 *  @brief wether initialized
 */
@property (nonatomic, assign) BOOL isInitialized;

/**
 *  @brief wether should refresh data when called:viewWillApppear method
 */
@property (nonatomic, assign) BOOL shouldRefreshWhenWillShow;

/**
 *  @brief generate fixed space baritem
 *
 *  @return the bar item
 */
- (UIBarButtonItem *)barSpacer;

/**
 *  @brief generate custom barItem: default::color:FFFFFF/size:31
 *
 *  @param icon     iconfont's name
 *  @param target   iconfont's target
 *  @param selector iconfont's selector
 *
 *  @return the bar item
 */
- (UIBarButtonItem *)barWithIcon:(NSString *)icon withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 *  @brief generate custom barItem: default::size:31
 *
 *  @param icon  iconfont's name
 *  @param color bar's front color
 *  @param target   iconfont's target
 *  @param selector iconfont's selector
 *
 *  @return the bar item
 */
- (UIBarButtonItem *)barWithIcon:(NSString *)icon withColor:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 *  @brief generate custom barItem: default::size:31
 *
 *  @param icon     the icon image
 *  @param target   bar's target
 *  @param selector bar's selector
 *
 *  @return the bar item
 */
- (UIBarButtonItem *)barWithImage:(UIImage *)icon withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 *  @brief generate custom barItem: default::size:31
 *
 *  @param icon     the icon image
 *  @param color    the icon image's tintColor, default is whiteColor
 *  @param target   bar's target
 *  @param selector bar's selector
 *
 *  @return the bar item
 */
- (UIBarButtonItem *)barWithImage:(UIImage *)icon withColor:(nullable UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector;

/**
 *  @brief call pop
 */
- (void)popUpLayer;

/**
 *  @brief 统一处理错误页面
 *
 *  @attention:***此方法需要配合 子类方法使用
 *  @param type 页面类型
 *  @param view 被添加上的view
 */
- (void)showErrorType:(NHViewErrorType)type inView:(UIView *)superview layoutMargin:(UIView *)layout withTarget:(nullable id)target withSelector:(nullable SEL)selector;
- (void)removeErrorAlertView;

/**
 *  @brief this function must called by subclass!!!
 *
 *  @param type <#type description#>
 */
- (void)handleErrorType:(NHViewErrorType)type;

#pragma mark -- usr authority alert 

/**
 *  @brief wether usr did authority when do something should be authorization
 *
 *  @param event the event after usr authoritied
 *
 *  @return usr's login state
 */
- (BOOL)alertOnUsrAuthorizationStateWithEvent:(NHUsrAuthorityEvent)event;

NS_ASSUME_NONNULL_END

@end
