//
//  NHCustomerProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

@interface NHCustomerProfiler : NHBaseViewController

@end

#pragma mark -- Custom Cell --

@interface NHFrindActCell : UITableViewCell

@property (nonatomic, strong) IBInspectable UIImageView *m_icon;

@property (nonatomic, strong) IBInspectable UILabel *m_nick;
@property (nonatomic, strong) IBInspectable UILabel *m_act,*m_income;

@end