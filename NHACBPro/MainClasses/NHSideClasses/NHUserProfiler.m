//
//  NHUserProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHUserProfiler.h"
#import "NHDBEngine.h"

#pragma mark -- Custom Cell --

@interface NHUserProfilerCell : UITableViewCell

@property (nonatomic, strong) IBInspectable UIImageView *m_icon;

@property (nonatomic, strong) IBInspectable UILabel *m_img;
@property (nonatomic, strong) IBInspectable UILabel *m_type;
@property (nonatomic, strong) UILabel *m_sub_type;
@property (nonatomic, strong) UILabel *m_rot;
// with circle line
@property (nonatomic, strong) UILabel *m_sub_ring_type;

@end

@implementation NHUserProfilerCell

- (void)awakeFromNib {
    [self __initSetup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    UIColor *bgColor = [UIColor colorWithRed:78/255.f green:89/255.f blue:155/255.f alpha:1];
    self.backgroundColor = bgColor;
    self.contentView.backgroundColor = bgColor;
    self.accessoryView.tintColor = [UIColor whiteColor];
    //UIFont *iconfont = PBFont(@"iconfont", NHFontTitleSize*1.2);
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor whiteColor];
//    [self.contentView addSubview:self.m_img];
    [self.contentView addSubview:self.m_icon];
    [self.contentView addSubview:self.m_type];
//    self.m_img.font = iconfont;
//    self.m_img.textColor = color;
    self.m_type.font = font;
    self.m_type.textColor = color;
    
    color = [UIColor colorWithRed:136/255.f green:145/255.f blue:200/255.f alpha:1];
    font = PBSysFont(NHFontSubSize);
    [self.contentView addSubview:self.m_sub_type];
    self.m_sub_type.font = font;
    self.m_sub_type.textColor = color;
    self.m_sub_type.textAlignment = NSTextAlignmentRight;
    
    color = [UIColor colorWithRed:237/255.f green:201/255.f blue:32/255.f alpha:1];
    [self.contentView addSubview:self.m_sub_ring_type];
    self.m_sub_ring_type.font = font;
    self.m_sub_ring_type.textColor = color;
    //self.m_sub_ring_type.textAlignment = NSTextAlignmentRight;
    self.m_sub_ring_type.layer.cornerRadius = NH_CUSTOM_LAB_HEIGHT*0.5;
    self.m_sub_ring_type.layer.borderWidth = NH_CUSTOM_LINE_HEIGHT;
    self.m_sub_ring_type.layer.borderColor = color.CGColor;
    self.m_sub_ring_type.layer.masksToBounds = true;
    
    color = [UIColor redColor];
    [self.contentView addSubview:self.m_rot];
    self.m_rot.backgroundColor = color;
    self.m_rot.hidden = true;
}

#pragma mark -- lazy methods
- (UIImageView *)m_icon {
    if (!_m_icon) {
        UIImageView *imgv = [[UIImageView alloc] init];
        _m_icon = imgv;
    }
    return _m_icon;
}

- (UILabel *)m_img {
    if (!_m_img) {
        UILabel *label = [[UILabel alloc] init];
        _m_img = label;
    }
    return _m_img;
}

- (UILabel *)m_type {
    if (!_m_type) {
        UILabel *label = [[UILabel alloc] init];
        _m_type = label;
    }
    return _m_type;
}

- (UILabel *)m_sub_type {
    if (!_m_sub_type) {
        UILabel *label = [[UILabel alloc] init];
        _m_sub_type = label;
    }
    return _m_sub_type;
}

- (UILabel *)m_sub_ring_type {
    if (!_m_sub_ring_type) {
        UILabel *label = [[UILabel alloc] init];
        _m_sub_ring_type = label;
    }
    return _m_sub_ring_type;
}

- (UILabel *)m_rot {
    if (!_m_rot) {
        UILabel *label = [[UILabel alloc] init];
        _m_rot = label;
    }
    return _m_rot;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat m_icon_size = NH_CUSTOM_LAB_HEIGHT;
    weakify(self)
    [self.m_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView);
        make.width.and.height.equalTo(m_icon_size);
    }];
    [self.m_type mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.m_icon.mas_right).offset(NH_CONTENT_MARGIN);
        //make.right.equalTo(self.contentView);
        make.height.equalTo(m_icon_size);
    }];
    [self.m_sub_type mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        //make.left.equalTo(self.m_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_icon_size);
    }];
    [self.m_sub_ring_type mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        //make.left.equalTo(self.m_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_icon_size);
    }];
    int size = 5;
    self.m_rot.layer.cornerRadius = size*0.5;
    self.m_rot.layer.masksToBounds = true;
    [self.m_rot mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_type.mas_top).offset(size*0.5);
        make.left.equalTo(self.m_type.mas_right).offset(size*0.5);
        make.width.height.equalTo(size);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHUserProfiler ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *usr_avatar;
@property (nonatomic, strong) UILabel *usr_nick,*usr_account,*usr_state;

@property (nonatomic, strong) NSDictionary *usrStateDict;
@property (nonatomic, strong) UITableView *usr_table;

@end

@implementation NHUserProfiler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"user profiler";
    UIColor *bgColor = [UIColor colorWithRed:78/255.f green:89/255.f blue:155/255.f alpha:1];
    self.view.backgroundColor = bgColor;
    //layout subviews
    NSInteger avatar_size = NH_SIDE_OFF_WIDTH;
    CGFloat margin_offset = NH_BOUNDARY_MARGIN;
    
    UIControl *usr_ctr = [[UIControl alloc] init];
    //usr_ctr.backgroundColor = [UIColor blueColor];
    [usr_ctr addTarget:self action:@selector(usrInfoShowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:usr_ctr];
    weakify(self)
    [usr_ctr mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view).offset(avatar_size * 0.5);
        make.left.equalTo(self.view).offset(margin_offset);
        make.right.equalTo(self.view).offset(-avatar_size);
        make.height.equalTo(@(avatar_size));
    }];
    UIImageView *usr_avatar = [[UIImageView alloc] init];
    //usr_avatar.backgroundColor = [UIColor redColor];
    [usr_ctr addSubview:usr_avatar];
    self.usr_avatar = usr_avatar;
    [usr_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.equalTo(usr_ctr);
        make.width.equalTo(@(avatar_size));
    }];
    UIColor *color = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysBoldFont(NHFontTitleSize*1.2);
    label.textColor = color;
    //label.backgroundColor = [UIColor lightGrayColor];
    [usr_ctr addSubview:label];
    self.usr_nick = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usr_ctr).offset(avatar_size*0.25);
        make.left.equalTo(usr_avatar.mas_right).offset(margin_offset);
        make.right.equalTo(usr_ctr.mas_right).offset(-margin_offset*2);
        make.height.equalTo(@(avatar_size*0.25));
    }];
    label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontTitleSize);
    label.textColor = color;
    //label.backgroundColor = [UIColor grayColor];
    [usr_ctr addSubview:label];
    self.usr_account = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.usr_nick.mas_bottom);
        make.left.equalTo(usr_avatar.mas_right).offset(margin_offset);
        make.right.equalTo(usr_ctr.mas_right).offset(-margin_offset*2);
        make.height.equalTo(@(avatar_size*0.25));
    }];
    //arrow
    color = [UIColor colorWithRed:136/255.f green:145/255.f blue:200/255.f alpha:1];
    UILabel *arrow = [[UILabel alloc] init];
    arrow.font = PBFont(@"iconfont", 20);
    arrow.text = @"\U0000e605";
    arrow.textAlignment = NSTextAlignmentRight;
    arrow.textColor = color;
    [usr_ctr addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usr_ctr.mas_centerY);
        make.right.equalTo(usr_ctr.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.width.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontTitleSize);
    label.textAlignment = NSTextAlignmentRight;
    label.text = PBFormat(@"%@",@"点击登录");
    label.textColor = color;
    //label.backgroundColor = [UIColor orangeColor];
    [usr_ctr addSubview:label];
    self.usr_state = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usr_avatar.mas_centerY);
        make.left.equalTo(usr_avatar.mas_right).offset(margin_offset);
        make.right.equalTo(arrow.mas_left).offset(-NH_CONTENT_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    
    //avatar bottom line
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usr_ctr.mas_bottom).offset(margin_offset);
        make.left.equalTo(usr_ctr);
        make.right.equalTo(usr_ctr.mas_right).offset(margin_offset*2);
        make.height.equalTo(@(1));
    }];
    //setting
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.bottom.equalTo(self.view).offset(-avatar_size+margin_offset);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    UILabel *setting = [[UILabel alloc] init];
    setting.font = PBFont(@"iconfont", NHFontTitleSize);
    setting.textColor = color;
    setting.text = @"\U0000e60e 设置";
    setting.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [setting addGestureRecognizer:tap];
    [self.view addSubview:setting];
    [setting mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view);
    }];
    
    //表格
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundView = nil;
    table.backgroundColor = bgColor;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    // delete empty cell
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    self.usr_table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(margin_offset);
        make.left.equalTo(usr_ctr);
        make.right.equalTo(usr_ctr);
        make.bottom.equalTo(line.mas_bottom).offset(-margin_offset);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__FUNCTION__);
    [self refreshUsrState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- user abouts --

- (void)synchronizedUsrState {
    //TODO:联网同步用户信息
}

- (void)refreshUsrState {
    
    BOOL logined = [[NHDBEngine share] logined];
    self.usr_nick.hidden = self.usr_account.hidden = !logined;
    self.usr_state.hidden = logined;
    UIColor *color = [UIColor colorWithRed:136/255.f green:145/255.f blue:200/255.f alpha:1];
    UIImage *usr_img = [UIImage pb_iconFont:nil withName:@"\U0000e609" withSize:NH_SIDE_OFF_WIDTH withColor:color];
    if (!logined) {
        self.usr_avatar.image = usr_img;
    }else{
        NHUsr *usr = [[NHDBEngine share] authorizedUsr];
        [self.usr_avatar sd_setImageWithURL:[NSURL URLWithString:usr.avatar] placeholderImage:usr_img];
        self.usr_nick.text = usr.nick;
        self.usr_account.text = usr.account;
    }
    
    //get data
    weakify(self)
    PBBACK(^{
        [[NHAFEngine share] GET:@"sideStatus" parameters:nil vcr:nil view:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary   * _Nullable responseObj) {
            NSDictionary *mDict = [responseObj pb_dictionaryForKey:@"state"];
            if (_usrStateDict) {
                _usrStateDict = nil;
            }
            _usrStateDict = [NSDictionary dictionaryWithDictionary:mDict];
            PBMAIN(^{strongify(self);[self.usr_table reloadData];});
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == NH_USR_STATE_INVALID) {
                
            }
        }];
    });
}

#pragma mark -- Touch Actions --

- (void)usrInfoShowAction {
    NSLog(@"user login");
    BOOL logined = [[NHDBEngine share] logined];
    Class aClass = NSClassFromString(@"NHLoginProfiler");
    if (logined) {
        aClass = NSClassFromString(@"NHUserProfileCenter");
    }
    [self centralizedCall:aClass];
}

- (void)callWalletAction {
    Class aClass = NSClassFromString(@"NHWalletProfiler");
    [self centralizedCall:aClass];
}

- (void)callFinanceBookAction {
    Class aClass = NSClassFromString(@"NHFinanceBooker");
    [self centralizedCall:aClass];
}

- (void)callActivityAction {
    Class aClass = NSClassFromString(@"NHUsrActivityProfiler");
    [self centralizedCall:aClass];
}

- (void)callRecommendAction {
    Class aClass = NSClassFromString(@"NHRecommendProfiler");
    [self centralizedCall:aClass];
}

- (void)callCustomerAction {
    Class aClass = NSClassFromString(@"NHCustomerProfiler");
    [self centralizedCall:aClass];
}

- (void)callDailySignAction {
    Class aClass = NSClassFromString(@"NHDailySignCenter");
    [self centralizedCall:aClass];
}

- (void)callHelpAction {
    Class aClass = NSClassFromString(@"NHHelpProfiler");
    [self centralizedCall:aClass];
}

- (void)callSettingAction {
    Class aClass = NSClassFromString(@"NHSettingProfiler");
    [self centralizedCall:aClass];
}

/**
 *  @brief 集中跳转
 *
 *  @param aClass 使用反射
 */
- (void)centralizedCall:(Class)aClass {
    if (_delegate && [_delegate conformsToProtocol:@protocol(NHUserProfilerDelegate)] && [_delegate respondsToSelector:@selector(userProfiler:didToggleClass:)]) {
        [_delegate userProfiler:self didToggleClass:NSStringFromClass(aClass)];
    }
}

#pragma mark -- table abouts --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int __rows = 0;
    if (section == 0) {
        //TODO:审核时不显示 推荐有奖
        BOOL isReviewed = [[NHDBEngine share] globalConfig].reviewed.boolValue;
        __rows = isReviewed?6:5;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int __h = 0;
    if (section == 0) {
        __h = 0;
    }else if (section == 1){
        __h = 20;
    }
    return __h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"usrCell";
    NHUserProfilerCell *cell = (NHUserProfilerCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHUserProfilerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger __section = [indexPath section];
    NSInteger __row__ = [indexPath row];
    //NSInteger icon_size = 40;CGFloat offset = 5;
    NSString *icon,*title,*subInfo;
    BOOL subHidden = false;BOOL rotShow = false;
    BOOL isReviewed = [[NHDBEngine share] globalConfig].reviewed.boolValue;
    if (isReviewed) {
        if (__section == 0) {
            if (__row__ == 0) {
                icon = @"m_wallet";
                title = @"我的钱包";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"wallet"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 1){
                icon = @"m_finance_book";
                title = @"账本";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"finanbook"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 2){
                icon = @"m_usr_activity";
                title = @"我的活动";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"activity"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 3){
                icon = @"m_recommend";
                title = @"推荐有奖";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"invite"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = true;
                subInfo = PBFormat(@"   %@   ",subInfo);
            }else if (__row__ == 4){
                icon = @"m_usr_friend";
                title = @"我的好友";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"friend"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 5){
                icon = @"m_daily_sign";
                title = @"每日签到";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"sign"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = true;
                subInfo = PBFormat(@"   %@   ",subInfo);
            }
            
        }else if (__section == 1){
            
        }
    }else{
        if (__section == 0) {
            if (__row__ == 0) {
                icon = @"m_wallet";
                title = @"我的钱包";
                subInfo = @"钱包、金币、保证金";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"wallet"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 1){
                icon = @"m_finance_book";
                title = @"账本";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"finanbook"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 2){
                icon = @"m_usr_activity";
                title = @"我的活动";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"activity"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 3){
                icon = @"m_usr_friend";
                title = @"我的好友";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"friend"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = false;
            }else if (__row__ == 4){
                icon = @"m_daily_sign";
                title = @"每日签到";
                NSDictionary *mDict = [self.usrStateDict pb_dictionaryForKey:@"sign"];
                subInfo = [mDict pb_stringForKey:@"tips"];
                rotShow = [mDict pb_boolForKey:@"status"];
                
                subHidden = true;
                subInfo = PBFormat(@"   %@   ",subInfo);
            }
            
        }else if (__section == 1){
            
        }
    }
    
    cell.m_sub_type.hidden = subHidden;
    cell.m_sub_ring_type.hidden = !subHidden;
    cell.m_rot.hidden = !rotShow;
    [cell layoutIfNeeded];
    
    cell.m_icon.image = [UIImage imageNamed:icon];
    cell.m_type.text = title;
    [cell.m_type sizeToFit];
    cell.m_sub_type.text = subInfo;
    cell.m_sub_ring_type.text = subInfo;
    
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger __section = [indexPath section];
    NSInteger __row__ = [indexPath row];
    BOOL isReviewed = [[NHDBEngine share] globalConfig].reviewed.boolValue;
    BOOL shouldReload = false;
    if (isReviewed) {
        if (__section == 0) {
            if (__row__ == 0) {
                [self callWalletAction];
            }else if (__row__ == 1){
                [self callFinanceBookAction];
            }else if (__row__ == 2){
                [self callActivityAction];
            }else if (__row__ == 3){
                [self callRecommendAction];
            }else if (__row__ == 4){
                [self callCustomerAction];
                shouldReload = true;
            }else if (__row__ == 5){
                [self callDailySignAction];
            }
        }else if (__section == 1){
            
        }
    }else{
        if (__section == 0) {
            if (__row__ == 0) {
                [self callWalletAction];
            }else if (__row__ == 1){
                [self callFinanceBookAction];
            }else if (__row__ == 2){
                [self callActivityAction];
            }else if (__row__ == 3){
                [self callCustomerAction];
                shouldReload = true;
            }else if (__row__ == 4){
                [self callDailySignAction];
            }
        }else if (__section == 1){
            
        }
    }
    
    if (shouldReload) {
        NSDictionary *tmpDict = [self.usrStateDict pb_dictionaryForKey:@"friend"];
        [tmpDict setValue:@"0" forKey:@"status"];
        NSMutableDictionary *tmpUsr = [NSMutableDictionary dictionaryWithDictionary:self.usrStateDict];
        [tmpUsr setValue:tmpDict forKey:@"friend"];
        self.usrStateDict = [tmpUsr copy];
        [tableView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)settingAction {
    [self callSettingAction];
}

@end
