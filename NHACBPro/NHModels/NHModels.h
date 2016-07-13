//
//  NHModels.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface NHModels : NSObject

@end

#pragma mark -- 用户
@interface NHUsr : NSObject <NSCopying>

//usr unique id, distributed by system
@property (nonatomic, copy) NSString *uid;
//usr account default by null
@property (nonatomic, copy) NSString *account;
//usr account type default by "normal"
@property (nonatomic, copy) NSString *acctype;
//usr account's login passwd default by null(MD5)
@property (nonatomic, copy) NSString *passwd;
//usr's authorition to comunicate with server, generated after usr logined
@property (nonatomic, copy) NSString *authorToken;
//usr gender 0:none 1:male 2:female default by 0
@property (nonatomic, copy) NSString *gender;
//usr account'e level default by 0
@property (nonatomic, copy) NSString *level;
//usr nick name
@property (nonatomic, copy) NSString *nick;
//usr avatar's url
@property (nonatomic, copy) NSString *avatar;
//usr signature
@property (nonatomic, copy) NSString *signature;
//usr's real name by law
@property (nonatomic, copy) NSString *authorName;
//usr's identity's number by law
@property (nonatomic, copy) NSString *authorID;
//usr's authorition type, default by 0 that mean idcard
@property (nonatomic, copy) NSString *authorType;
//usr's email
@property (nonatomic, copy) NSString *email;
//usr's post code
@property (nonatomic, copy) NSString *postal;
//usr state default by 86
@property (nonatomic, copy) NSString *state;
//usr province default by null
@property (nonatomic, copy) NSString *province;
//usr city default by null
@property (nonatomic, copy) NSString *city;
//usr city default by now
@property (nonatomic, copy) NSString *logdate;
//usr's money left
@property (nonatomic, copy) NSString *overage;
//usr's all incomes
@property (nonatomic, copy) NSString *allIncome;
//usr's golden number
@property (nonatomic, copy) NSString *numGolden;
//usr's point number
@property (nonatomic, copy) NSString *points;
//usr's risk capital
@property (nonatomic, copy) NSString *riskCapital;
//usr's binded bankCard's number
@property (nonatomic, copy) NSString *numBankCard;
//usr's binded weixin's account
@property (nonatomic, copy) NSString *accWeiXin;
//usr's binded alipay's account
@property (nonatomic, copy) NSString *accAlipay;
//usr's ext
@property (nonatomic, copy) NSString *ext;

@end

@interface NHConfigure : NSObject

//app build version
@property (nonatomic, copy) NSString *appv;
// 此build版本app是否审核结束 0未结束审核中 1已结束
@property (nonatomic, copy) NSString *reviewed;
//用户引导是否显示
@property (nonatomic, copy) NSString *guideFlashed;
// 扩展
@property (nonatomic, copy) NSString *ext;

@end