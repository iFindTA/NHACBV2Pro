//
//  NHMoneyProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

/**
 页面类型分类
 */
typedef enum {
    NHProfileTypeMoney                  =       1 << 0, //余额
    NHProfileTypeGolden                 =       1 << 1, //金币
    NHProfileTypeRiskMargin             =       1 << 2  //风险保证金
}NHProfileType;

@interface NHMoneyProfiler : NHBaseViewController

/**
 *  @brief 实例化
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithProfileType:(NHProfileType)type;

@end
