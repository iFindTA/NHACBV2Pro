//
//  NHModels.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHModels.h"

@implementation NHModels

@end

@implementation NHUsr

- (id)copyWithZone:(NSZone *)zone {
    NHUsr *usr = [[[self class] alloc] init];
    usr.uid = self.uid;
    usr.account = self.account;
    usr.acctype = self.acctype;
    usr.passwd = self.passwd;
    usr.authorToken = self.authorToken;
    usr.gender = self.gender;
    usr.level = self.level;
    usr.nick = self.nick;
    usr.avatar = self.avatar;
    usr.signature = self.signature;
    usr.authorName = self.authorName;
    usr.authorID = self.authorID;
    usr.authorType = self.authorType;
    usr.email = self.email;
    usr.postal = self.postal;
    usr.state = self.state;
    usr.province = self.province;
    usr.city = self.city;
    usr.logdate = self.logdate;
    usr.overage = self.overage;
    usr.allIncome = self.allIncome;
    usr.numGolden = self.numGolden;
    usr.points = self.points;
    usr.riskCapital = self.riskCapital;
    usr.numBankCard = self.numBankCard;
    usr.accWeiXin = self.accWeiXin;
    usr.accAlipay = self.accAlipay;
    usr.ext = self.ext;
    return usr;
}

@end

@implementation NHConfigure

@end
