//
//  NHFinanceBooker.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/16.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

@interface NHFinanceBooker : NHBaseViewController

@end

#pragma mark -- Custom Money Cell --

typedef void(^NHRecordEditEvent)(id info);

@interface NHFinanceAmountCell : UITableViewCell

//aid info
@property (nonatomic, strong) UILabel *m_aid_arrow,*m_aid_platfm,*m_aid_income,*m_aid_payway;
@property (nonatomic, strong) UILabel *m_line1,*m_line2,*m_line3,*m_sect;

//content info
@property (nonatomic, strong) UILabel *m_act_title,*m_act_income,*m_act_payway;
@property (nonatomic, strong) UILabel *m_act_platform,*m_act_starttime,*m_act_endtime;

- (void)updateContent:(NSDictionary *)aDict;

- (void)handleManualRecordEditEvent:(NHRecordEditEvent)event;

@end