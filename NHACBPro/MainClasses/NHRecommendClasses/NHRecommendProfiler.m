//
//  NHRecommendProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHRecommendProfiler.h"
#import "NHCustomerProfiler.h"
#import "NHUsrActivityProfiler.h"

@interface NHRecommendProfiler ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UILabel *golden_lab;
@property (nonatomic, strong) UIButton *invest_btn;

@end

@implementation NHRecommendProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"推荐有奖";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSDictionary *aDic = @{
                               @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                               @"nick":@"东成西就－西毒",
                               @"acts":@"65",
                               @"income":@"5700",
                               @"unit":@"金币"
                               };
        [arrs addObject:aDic];
    }
    self.dataSource = [NSMutableArray arrayWithArray:arrs.copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderRecommendBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderRecommendBody {
    CGFloat m_up_height = 200;
    CGFloat m_sect_height = 55;
    
    UIColor *color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UILabel *up_bg_lab = [[UILabel alloc] init];
    up_bg_lab.backgroundColor = color;
    [self.view addSubview:up_bg_lab];
    weakify(self)
    [up_bg_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(m_up_height));
    }];
    //white bg
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = NH_CORNER_RADIUS;
    whiteBg.layer.masksToBounds = true;
    [self.view addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(up_bg_lab).insets(UIEdgeInsetsMake(NH_BOUNDARY_MARGIN, NH_BOUNDARY_MARGIN, NH_BOUNDARY_MARGIN, NH_BOUNDARY_MARGIN));
    }];
    //按钮
    NSString *title = @"";
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    CGFloat m_boudary_offset = NH_BOUNDARY_OFFSET * 2;
    UIColor *bgColor = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    color = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(continueInvestFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(whiteBg.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.bottom.equalTo(whiteBg.mas_bottom).offset(-m_boudary_offset);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
    }];
    //金币
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize*3);
    NSString *amount = @"8000";
    UILabel *label = [[UILabel alloc] init];
    //    label.backgroundColor = [UIColor cyanColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = color;
    label.text = amount;
    [self.view addSubview:label];
    self.golden_lab = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(whiteBg.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(whiteBg.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(font.pointSize);
    }];
    //unit
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *unit = [[UILabel alloc] init];
    unit.font = font;
    unit.textColor = color;
    unit.textAlignment = NSTextAlignmentCenter;
    unit.text = @"累计奖励金币（枚）";
    [self.view addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(whiteBg);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    //分割区
    color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(up_bg_lab.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(m_sect_height);
    }];
    //中间提示
    title = @"最近邀请";
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    NSDictionary *attributes = @{
                   NSFontAttributeName:font
                   };
    CGSize size = [title sizeWithAttributes:attributes];
    UILabel *sect_title = [[UILabel alloc] init];
    //    sect_title.backgroundColor = [UIColor cyanColor];
    sect_title.textAlignment = NSTextAlignmentCenter;
    sect_title.font = font;
    sect_title.textColor = color;
    sect_title.text = title;
    [sect_title sizeToFit];
    [self.view addSubview:sect_title];
    [sect_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label.mas_centerX);
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(label);
        make.width.equalTo(size.width);
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sect_title.mas_centerY);
        make.left.equalTo(whiteBg.mas_left);
        make.right.equalTo(sect_title.mas_left).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@1);
    }];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sect_title.mas_centerY);
        make.left.equalTo(sect_title.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(whiteBg.mas_right);
        make.height.equalTo(@1);
    }];
    //查看所有
    //TODO:此处有条件 如果当前条数大于5条 最近仅仅显示五条
    color = [UIColor colorWithRed:119/255.f green:134/255.f blue:225/255.f alpha:1];
    UIColor *btnBgColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = btnBgColor;
    btn.titleLabel.font = PBSysFont(NHFontTitleSize);
    [btn setTitle:@"查看所有好友" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showAllFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(sect_title.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(btn.mas_top);
    }];
}

- (void)continueInvestFriend {
    //TODO:share action
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_FRIEND_ACT_CELL_HEIGHT           =       75;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = self.dataSource.count;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NH_FRIEND_ACT_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"friendActCell";
    NHFrindActCell *cell = (NHFrindActCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHFrindActCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell layoutIfNeeded];
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDict = [self.dataSource objectAtIndex:__row__];
    NSString *icon = [aDict objectForKey:@"icon"];
    NSString *nick = [aDict objectForKey:@"nick"];
    NSString *acts = [aDict objectForKey:@"acts"];
    NSString *income = [aDict objectForKey:@"income"];
    NSString *text = PBFormat(@"完成活动：%@个",acts);
    UIFont *font = PBSysFont(NHFontSubSize);
    UIColor *color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSRange colorRange = [[attrString string] rangeOfString:acts options:NSNumericSearch];
    UIColor *hiColor = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
    [attrString addAttribute:NSForegroundColorAttributeName value:hiColor range:colorRange];
    [cell.m_icon sd_setImageWithURL:[NSURL URLWithString:icon]];
    cell.m_nick.text = nick;
    cell.m_act.attributedText = [attrString copy];
    text = PBFormat(@"累计奖励：%@金币",income);
    attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    colorRange = [[attrString string] rangeOfString:income options:NSNumericSearch];
    [attrString addAttribute:NSForegroundColorAttributeName value:hiColor range:colorRange];
    cell.m_income.attributedText = [attrString copy];
    if (__row__ == self.dataSource.count-1) {
        pb_makeCellSeperatorLineTopGrid(cell);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NHUsrActivityProfiler *activitier = [[NHUsrActivityProfiler alloc] initWithUsrActivityType:NHUsrActivityTypeFriend];
    [self.navigationController pushViewController:activitier animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)showAllFriends {
    NHCustomerProfiler *mineFriends = [[NHCustomerProfiler alloc] init];
    [self.navigationController pushViewController:mineFriends animated:true];
}

@end
