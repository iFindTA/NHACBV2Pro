//
//  NHResetPasswder.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NHResetPWDTypeInit                  =       1 << 0,//注册设置密码
    NHResetPWDTypeFind                  =       1 << 1,//忘记密码
    NHResetPWDTypeModify                =       1 << 2//修改登录密码
}NHResetPWDType;

@interface NHResetPasswder : NHBaseViewController

/**
 *  @brief init method
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithPwdType:(NHResetPWDType)type;

/**
 *  @brief the class that should pop to when user logined!
 */
@property (nonatomic, strong, nullable) Class aBackClass;
/**
 *  @brief 注册时此字段不为空
 */
@property (nonatomic, copy, nullable) NSString *account;
/**
 *  @brief 注册时此字段不为空
 */
@property (nonatomic, copy, nullable) NSString *smsCode;

NS_ASSUME_NONNULL_END

@end
