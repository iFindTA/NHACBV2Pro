//
//  NHUsrActivityProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHUsrActivityProfiler.h"
#import "NHTagsLabel.h"
#import "NHActivityProfiler.h"
#import "NHFinanceBooker.h"

#pragma mark -- Custom Cell --

@interface NHUsrActivityCell : UITableViewCell

//aider info
@property (nonatomic, strong) UILabel *m_arrow,*m_line_up,*m_sect,*m_line_down,*m_pre_in;

//content info
@property (nonatomic, strong) UILabel *m_platform,*m_in_time;

@property (nonatomic, strong) UILabel *m_act_title,*m_act_income;
@property (nonatomic, strong) NHTagsLabel *m_act_flag;

@end

static  int         m_platform_h = 40;
static  CGFloat     m_scale = 0.618;

@implementation NHUsrActivityCell

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
    UIColor *color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontTitleSize);
    [self.contentView addSubview:self.m_platform];
    self.m_platform.font = font;
    self.m_platform.textColor = color;
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
    [self.contentView addSubview:self.m_in_time];
    self.m_in_time.font = font;
    self.m_in_time.textColor = color;
    self.m_in_time.textAlignment = NSTextAlignmentRight;
    
    //line
    bgColor = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    [self.contentView addSubview:self.m_line_up];
    self.m_line_up.backgroundColor = bgColor;
    
    //arrow
    [self.contentView addSubview:self.m_arrow];
    self.m_arrow.textAlignment = NSTextAlignmentRight;
    self.m_arrow.textColor = bgColor;
    self.m_arrow.font = PBFont(@"iconfont", NHFontTitleSize);
    self.m_arrow.text = @"\U0000e605";
    
    //activity
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    font = PBSysBoldFont(NHFontTitleSize);
    [self.contentView addSubview:self.m_act_title];
    self.m_act_title.font = font;
    self.m_act_title.textColor = color;
    
    //pre in
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    font = PBSysFont(NHFontSubSize);
    [self.contentView addSubview:self.m_pre_in];
    self.m_pre_in.font = font;
    self.m_pre_in.textColor = color;
    self.m_pre_in.textAlignment = NSTextAlignmentRight;
    self.m_pre_in.text = @"活动奖励";
    
    //flags
    [self.contentView addSubview:self.m_act_flag];
    
    //income
    color = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
    [self.contentView addSubview:self.m_act_income];
    self.m_act_income.font = font;
    self.m_act_income.textColor = color;
    self.m_act_income.textAlignment = NSTextAlignmentRight;
    
    //sect
    bgColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    [self.contentView addSubview:self.m_sect];
    self.m_sect.backgroundColor = bgColor;
    //line
    bgColor = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    [self.contentView addSubview:self.m_line_down];
    self.m_line_down.backgroundColor = bgColor;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods

- (UILabel *)m_arrow {
    if (!_m_arrow) {
        UILabel *label = [[UILabel alloc] init];
        _m_arrow = label;
    }
    return _m_arrow;
}

- (UILabel *)m_line_up {
    if (!_m_line_up) {
        UILabel *label = [[UILabel alloc] init];
        _m_line_up = label;
    }
    return _m_line_up;
}

- (UILabel *)m_line_down {
    if (!_m_line_down) {
        UILabel *label = [[UILabel alloc] init];
        _m_line_down = label;
    }
    return _m_line_down;
}

- (UILabel *)m_sect {
    if (!_m_sect) {
        UILabel *label = [[UILabel alloc] init];
        _m_sect = label;
    }
    return _m_sect;
}

- (UILabel *)m_pre_in {
    if (!_m_pre_in) {
        UILabel *label = [[UILabel alloc] init];
        _m_pre_in = label;
    }
    return _m_pre_in;
}

- (UILabel *)m_platform {
    if (!_m_platform) {
        UILabel *label = [[UILabel alloc] init];
        _m_platform = label;
    }
    return _m_platform;
}

- (UILabel *)m_in_time {
    if (!_m_in_time) {
        UILabel *label = [[UILabel alloc] init];
        _m_in_time = label;
    }
    return _m_in_time;
}

- (UILabel *)m_act_title {
    if (!_m_act_title) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_title = label;
    }
    return _m_act_title;
}

- (UILabel *)m_act_income {
    if (!_m_act_income) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_income = label;
    }
    return _m_act_income;
}

- (NHTagsLabel *)m_act_flag {
    if (!_m_act_flag) {
        CGFloat mWidth = (PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2)*m_scale;
        CGRect bounds = CGRectMake(0, 0, mWidth, m_platform_h);
        NHTagsLabel *label = [[NHTagsLabel alloc] initWithFrame:bounds];
        _m_act_flag = label;
    }
    return _m_act_flag;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakify(self)
    [self.m_platform mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_platform_h);
    }];
    [self.m_in_time mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.m_platform.mas_centerY);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_platform_h);
    }];
    [self.m_line_up mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_platform.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
    [self.m_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY).offset(m_platform_h*0.5);
        make.right.equalTo(self.contentView.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.width.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    CGFloat mWidth = PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2;
    CGFloat mHeight = NH_BOUNDARY_MARGIN+NH_CONTENT_MARGIN;
    [self.m_pre_in mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.right.equalTo(self.m_arrow.mas_left);
        make.bottom.equalTo(self.m_arrow.mas_centerY);
        make.size.equalTo(CGSizeMake(mWidth*(1-m_scale), mHeight));
    }];
    [self.m_act_income mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.top.equalTo(self.m_arrow.mas_centerY);
        make.right.equalTo(self.m_arrow.mas_left);
        make.size.equalTo(CGSizeMake(mWidth*(1-m_scale), mHeight));
    }];
    [self.m_act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.m_pre_in.mas_centerY).offset(-NH_CONTENT_MARGIN);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(mWidth*m_scale, mHeight));
    }];
    [self.m_act_flag mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_act_income.mas_top);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(mWidth*m_scale, m_platform_h));
    }];
    [self.m_line_down mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
    [self.m_sect mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.m_line_down.mas_top);
        make.height.equalTo(NH_CONTENT_MARGIN);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHUsrActivityProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NHUsrActivityType type;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHUsrActivityProfiler

- (void)dealloc {
    
}

- (id)init {
    self = [super init];
    if (self) {
        self.type = NHUsrActivityTypeMine;
    }
    return self;
}

- (id)initWithUsrActivityType:(NHUsrActivityType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //TODO:此处应传递用户昵称
    BOOL isMine = (NHUsrActivityTypeMine == self.type);
    self.title = isMine?@"我参与的活动":@"TA参与的活动";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
//    if (isMine) {
//        UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
//        public.frame = CGRectMake(0, 0, 50, 31);
//        public.titleLabel.font = PBSysFont(NHFontSubSize);
//        [public setTitle:@"账本" forState:UIControlStateNormal];
//        [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [public addTarget:self action:@selector(showUsrFinanceBooksAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *bookBar = [[UIBarButtonItem alloc] initWithCustomView:public];
//        self.navigationItem.rightBarButtonItems = @[spacer,bookBar];
//    }
    
    //TODO:test
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSDictionary *aDic = @{
                               @"title":@"钱内助",
                               @"time":@"2016-3-23",
                               @"activity":@"新手投资注册",
                               @"income":@"5700",
                               @"unit":@"元",
                               @"tags":@[@"新手福利",@"注册1000元",@"鬼子背景",@"新手奖励10000金币"]
                               };
        [arrs addObject:aDic];
    }
    self.dataSource = [NSMutableArray arrayWithArray:arrs.copy];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderUsrActivityBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderUsrActivityBody {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_USR_ACT_CELL_HEIGHT           =       160;

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
    return NH_USR_ACT_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"usrActCell";
    NHUsrActivityCell *cell = (NHUsrActivityCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHUsrActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell layoutIfNeeded];
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDict = [self.dataSource objectAtIndex:__row__];
    NSString *platform = [aDict objectForKey:@"title"];
    NSString *time = [aDict objectForKey:@"time"];
    NSString *activity = [aDict objectForKey:@"activity"];
    NSString *income = [aDict objectForKey:@"income"];
    NSString *unit = [aDict objectForKey:@"unit"];
    NSArray *tags = [aDict objectForKey:@"tags"];
    NSString *text = PBFormat(@"%@ %@",income,unit);
    UIFont *font = PBSysFont(NHFontSubSize);
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSRange fontRange = [[attrString string] rangeOfString:income options:NSNumericSearch];
    UIFont *boldSystemFont = [UIFont systemFontOfSize:NHFontTitleSize+8];
    [attrString addAttribute:NSFontAttributeName value:boldSystemFont range:fontRange];
    cell.m_platform.text = PBFormat(@"活动平台：%@",platform);
    cell.m_in_time.text = PBFormat(@"参与时间：%@",time);
    cell.m_act_title.text = activity;
    cell.m_act_flag.tags = tags;
    cell.m_act_income.attributedText = [attrString copy];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NHActivityProfiler *activitier = [[NHActivityProfiler alloc] init];
    activitier.activityName = @"活动详情";
    [self.navigationController pushViewController:activitier animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)showUsrFinanceBooksAction {
    NHFinanceBooker *finaceBooker = [[NHFinanceBooker alloc] init];
    [self.navigationController pushViewController:finaceBooker animated:true];
}

@end
