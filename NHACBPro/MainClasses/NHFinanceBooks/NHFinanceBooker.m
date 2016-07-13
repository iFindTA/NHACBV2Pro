//
//  NHFinanceBooker.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/16.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFinanceBooker.h"
#import "NHFinanceHistory.h"
#import "NHActivityProfiler.h"
#import "NHFinanceManualRecorder.h"

#pragma mark -- Custom Money Cell --

static  int         m_sect1_h = 40;
static  int         m_sect2_h = 60;
static  int         m_sect3_h = 24;

@interface NHFinanceAmountCell ()

@property (nonatomic, copy) NHRecordEditEvent event;
@property (nonatomic, strong) NSDictionary *recorderInfo;

@end

@implementation NHFinanceAmountCell

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

- (void)updateContent:(NSDictionary *)aDict {
    if (aDict != nil) {
        self.recorderInfo = [NSDictionary dictionaryWithDictionary:aDict];
        NSString *platform = [aDict objectForKey:@"platform"];
        NSString *start = [aDict objectForKey:@"start"];
        NSString *end = [aDict objectForKey:@"end"];
        NSString *activity = [aDict objectForKey:@"activity"];
        NSString *income = [aDict objectForKey:@"amount"];
        NSString *way = [aDict objectForKey:@"payway"];
        self.m_act_title.text = activity;
        self.m_act_platform.text = platform;
        self.m_act_income.text = income;
        self.m_act_payway.text = way;
        self.m_act_starttime.text = PBFormat(@"开始日期：%@",start);
        self.m_act_endtime.text = PBFormat(@"到期日期：%@",end);
    }
}

- (void)handleManualRecordEditEvent:(NHRecordEditEvent)event {
    self.event = [event copy];
}

- (void)__initSetup {
    
    //activity
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontTitleSize);
    [self.contentView addSubview:self.m_act_title];
    self.m_act_title.font = font;
    self.m_act_title.textColor = color;
    
    //arrow or edit
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontSubSize);
    [self.contentView addSubview:self.m_aid_arrow];
    self.m_aid_arrow.font = font;
    self.m_aid_arrow.textColor = color;
    self.m_aid_arrow.textAlignment = NSTextAlignmentRight;
    self.m_aid_arrow.text = @"查看详情\U0000e605";
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.m_line1 = line;
    
    //aids~platform
    CGFloat m_font_offset = 3;
    color = [UIColor colorWithRed:161/255.f green:162/255.f blue:170/255.f alpha:1];
    font = PBSysFont(NHFontSubSize-m_font_offset);
    [self.contentView addSubview:self.m_aid_platfm];
    self.m_aid_platfm.font = font;
    self.m_aid_platfm.textColor = color;
    self.m_aid_platfm.text = @"平台";
    //aids~income
    [self.contentView addSubview:self.m_aid_income];
    self.m_aid_income.font = font;
    self.m_aid_income.textColor = color;
    self.m_aid_income.textAlignment = NSTextAlignmentCenter;
    self.m_aid_income.text = @"本金";
    //aids~payway
    [self.contentView addSubview:self.m_aid_payway];
    self.m_aid_payway.font = font;
    self.m_aid_payway.textColor = color;
    self.m_aid_payway.textAlignment = NSTextAlignmentRight;
    self.m_aid_payway.text = @"还款方式";
    
    //platform
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:54/255.f green:54/255.f blue:54/255.f alpha:1];
    [self.contentView addSubview:self.m_act_platform];
    self.m_act_platform.font = font;
    self.m_act_platform.textColor = color;
    
    //payway
    [self.contentView addSubview:self.m_act_payway];
    self.m_act_payway.font = font;
    self.m_act_payway.textColor = color;
    self.m_act_payway.textAlignment = NSTextAlignmentRight;
    
    //income
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    [self.contentView addSubview:self.m_act_income];
    self.m_act_income.font = font;
    self.m_act_income.textColor = color;
    self.m_act_income.textAlignment = NSTextAlignmentCenter;
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.m_line2 = line;
    
    //aid~dates
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    [self.contentView addSubview:self.m_act_starttime];
    self.m_act_starttime.font = font;
    self.m_act_starttime.textColor = color;
    
    [self.contentView addSubview:self.m_act_endtime];
    self.m_act_endtime.font = font;
    self.m_act_endtime.textColor = color;
    self.m_act_endtime.textAlignment = NSTextAlignmentRight;
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.m_line3 = line;
    
    //sect
    color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.m_sect = line;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods

- (UILabel *)m_aid_arrow {
    if (!_m_aid_arrow) {
        UILabel *label = [[UILabel alloc] init];
        _m_aid_arrow = label;
    }
    return _m_aid_arrow;
}

- (UILabel *)m_aid_platfm {
    if (!_m_aid_platfm) {
        UILabel *label = [[UILabel alloc] init];
        _m_aid_platfm = label;
    }
    return _m_aid_platfm;
}

- (UILabel *)m_aid_income {
    if (!_m_aid_income) {
        UILabel *label = [[UILabel alloc] init];
        _m_aid_income = label;
    }
    return _m_aid_income;
}

- (UILabel *)m_aid_payway {
    if (!_m_aid_payway) {
        UILabel *label = [[UILabel alloc] init];
        _m_aid_payway = label;
    }
    return _m_aid_payway;
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

- (UILabel *)m_act_platform {
    if (!_m_act_platform) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_platform = label;
    }
    return _m_act_platform;
}

- (UILabel *)m_act_payway {
    if (!_m_act_payway) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_payway = label;
    }
    return _m_act_payway;
}

- (UILabel *)m_act_starttime {
    if (!_m_act_starttime) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_starttime = label;
    }
    return _m_act_starttime;
}

- (UILabel *)m_act_endtime {
    if (!_m_act_endtime) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_endtime = label;
    }
    return _m_act_endtime;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakify(self)
    [self.m_act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_sect1_h);
    }];
    [self.m_aid_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_sect1_h);
    }];
    [self.m_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_act_title.mas_bottom);
        make.left.right.equalTo(self.m_act_title);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    [self.m_aid_platfm mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line1.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.right.equalTo(self.m_line1);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_aid_income mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line1.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.right.equalTo(self.m_line1);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_aid_payway mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line1.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.right.equalTo(self.m_line1).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_act_platform mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_aid_platfm.mas_bottom);
        make.left.right.equalTo(self.m_aid_platfm);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_act_income mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_aid_platfm.mas_bottom);
        make.left.right.equalTo(self.m_aid_platfm);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_act_payway mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_aid_platfm.mas_bottom);
        make.left.right.equalTo(self.m_aid_platfm).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line1.mas_bottom).offset(m_sect2_h);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    [self.m_act_starttime mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line2.mas_bottom);
        make.left.equalTo(self.m_line2).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.m_line2);
        make.height.equalTo(m_sect3_h);
    }];
    [self.m_act_endtime mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line2.mas_bottom);
        make.left.equalTo(self.m_line2).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.m_line2).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_sect3_h);
    }];
    [self.m_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_act_starttime.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    [self.m_sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_line3.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(NH_CONTENT_MARGIN);
    }];
}

@end

@interface NHFinancePlatformCell : UITableViewCell

//content info
@property (nonatomic, strong) UILabel *m_act_platform,*m_act_income;

@end

@implementation NHFinancePlatformCell

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
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontTitleSize);
    [self.contentView addSubview:self.m_act_platform];
    self.m_act_platform.font = font;
    self.m_act_platform.textColor = color;
    
    //income
    color = [UIColor colorWithRed:216/255.f green:111/255.f blue:106/255.f alpha:1];
    [self.contentView addSubview:self.m_act_income];
    self.m_act_income.font = font;
    self.m_act_income.textAlignment = NSTextAlignmentRight;
    self.m_act_income.textColor = color;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods

- (UILabel *)m_act_platform {
    if (!_m_act_platform) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_platform = label;
    }
    return _m_act_platform;
}

- (UILabel *)m_act_income {
    if (!_m_act_income) {
        UILabel *label = [[UILabel alloc] init];
        _m_act_income = label;
    }
    return _m_act_income;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakify(self)
    [self.m_act_platform mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
    }];
    [self.m_act_income mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHFinanceBooker ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UITableView *capitalTable,*platTable;
@property (nonatomic, strong) UILabel *flagIndicator,*flagBg;
@property (nonatomic, assign) BOOL isCapitalShowing;

@property (nonatomic, strong) UILabel *m_amount;

@end

@implementation NHFinanceBooker

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"账本";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithImage:[UIImage imageNamed:@"m_back"] withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //历史明细 意义不大
//    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
//    public.frame = CGRectMake(0, 0, 60, 31);
//    public.titleLabel.font = PBSysFont(NHFontSubSize);
//    [public setTitle:@"历史明细" forState:UIControlStateNormal];
//    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [public addTarget:self action:@selector(showUsrFinanceBooksHistory) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bookBar = [[UIBarButtonItem alloc] initWithCustomView:public];
//    self.navigationItem.rightBarButtonItems = @[spacer,bookBar];
    
    self.isCapitalShowing = true;
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i < 5; i++) {
        NSDictionary *tmp = @{
                              @"activity":@"新手投资活动",
                              @"platform":@"钱内助",
                              @"amount":PBFormat(@"%zd",arc4random()%1000),
                              @"payway":@"一次性还款",
                              @"start":@"2015-12-3",
                              @"end":@"2016-3-29"
                              };
        [arrs addObject:tmp];
    }
    self.dataSource = [NSMutableArray arrayWithArray:[arrs copy]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.scroller) {
        [self renderFinanceBookerBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderFinanceBookerBody {
    static int m_bg_h = 150;
    /*
    weakify(self)
    UIControl *capital = [[UIControl alloc] init];
//    capital.backgroundColor = [UIColor redColor];
    [capital addTarget:self action:@selector(capitalShowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:capital];
    [capital mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self.view);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH*0.5, m_bg_h));
    }];
    UIControl *platCtl = [[UIControl alloc] init];
//    platCtl.backgroundColor = [UIColor blueColor];
    [platCtl addTarget:self action:@selector(platformShowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:platCtl];
    [platCtl mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.right.equalTo(self.view);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH*0.5, m_bg_h));
    }];
    
    //line
    UIColor *color = [UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    self.flagBg = line;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(platCtl.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(1);
    }];
    //indicator
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    UILabel *indicator = [[UILabel alloc] init];
    indicator.backgroundColor = color;
    [line addSubview:indicator];
    self.flagIndicator = indicator;
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.bottom.left.equalTo(line);
        //make.left.equalTo(line);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH*0.5, 2));
    }];
    
    //scroller 需要指定Scroller的bounds 不然无响应
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroller.pagingEnabled = true;
    scroller.showsHorizontalScrollIndicator = false;
    scroller.showsVerticalScrollIndicator = false;
    scroller.delegate = self;
    [self.view addSubview:scroller];
    self.scroller = scroller;
    [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroller);
        make.height.equalTo(scroller);
    }];
    
    //table1
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.backgroundColor = [UIColor cyanColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [container addSubview:table];
    self.capitalTable = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(container);
        make.width.equalTo(PBSCREEN_WIDTH);
    }];
    
    //table2
    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.backgroundColor = [UIColor blueColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [container addSubview:table];
    self.platTable = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.bottom.equalTo(container);
        make.left.equalTo(self.capitalTable.mas_right);
        make.width.equalTo(PBSCREEN_WIDTH);
    }];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(table.mas_right);
    }];
    //*/
    //以下情况为单个表的情况
    UIColor *color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UILabel *bg = [[UILabel alloc] init];
    bg.backgroundColor = color;
    [self.view addSubview:bg];
    weakify(self)
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(m_bg_h);
    }];
    //white bg
    UILabel *whiteBg = [[UILabel alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = NH_CORNER_RADIUS;
    whiteBg.layer.masksToBounds = true;
    [self.view addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_bg_h-NH_BOUNDARY_MARGIN*2);
    }];
    //amount
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    UIFont *font = PBSysBoldFont(NHFontTitleSize*3);
    UILabel *amount = [[UILabel alloc] init];
    amount.font = font;
    amount.textColor = color;
    amount.textAlignment = NSTextAlignmentCenter;
    amount.text = @"8000.09";
    [whiteBg addSubview:amount];
    self.m_amount = amount;
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(NH_BOUNDARY_MARGIN+NH_CONTENT_MARGIN);
        make.left.right.equalTo(whiteBg);
        make.height.equalTo(font.pointSize);
    }];
    //unit
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *unit = [[UILabel alloc] init];
    unit.font = font;
    unit.textColor = color;
    unit.textAlignment = NSTextAlignmentCenter;
    unit.text = @"待收本金（元）";
    [whiteBg addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amount.mas_bottom);
        make.left.right.equalTo(whiteBg);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    UIColor *btnBgColor = [UIColor colorWithRed:127/255.f green:142/255.f blue:227/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = btnBgColor;
    btn.titleLabel.font = PBSysFont(NHFontTitleSize);
    [btn setTitle:@"记一笔" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(manualRecordBehavial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    //table1
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    table.backgroundColor = [UIColor cyanColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.capitalTable = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(btn.mas_top);
    }];
}

- (void)capitalShowAction {
    
}

- (void)platformShowAction {
    
}

- (void)showUsrFinanceBooksHistory {
    NHFinanceHistory *history = [[NHFinanceHistory alloc] init];
    [self.navigationController pushViewController:history animated:true];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_BOOK_CELL_HEIGHT           =       136;

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
    return NH_BOOK_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.capitalTable) {
        static NSString *identifier = @"financeAmountCell";
        NHFinanceAmountCell *cell = (NHFinanceAmountCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NHFinanceAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [cell layoutIfNeeded];
        NSInteger __row__ = indexPath.row;
        NSDictionary *aDict = [self.dataSource objectAtIndex:__row__];
        [cell updateContent:aDict];
        //手动添加的可以修改
        weakify(self)
        [cell handleManualRecordEditEvent:^(id info) {
            if (info) {
                strongify(self)
                NHFinanceManualRecorder *manualEditor = [[NHFinanceManualRecorder alloc] initWithType:NHManualTypeModify withInfo:info];
                [self.navigationController pushViewController:manualEditor animated:true];
            }
        }];
        
        return cell;
    }else if (tableView == self.platTable){
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NHActivityProfiler *activitier = [[NHActivityProfiler alloc] init];
    activitier.activityName = @"活动详情";
    [self.navigationController pushViewController:activitier animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark -- UIScrollview Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scroller) {
        CGFloat offset_x = scrollView.contentOffset.x * 0.5;
        weakify(self)
        [self.flagIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.left.equalTo(self.flagBg).offset(offset_x);
        }];
        [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
            [self.flagBg layoutIfNeeded];
        }];
    }
}

#pragma mark -- 手动记一笔

- (void)manualRecordBehavial {
    NHFinanceManualRecorder *manualRecorder = [[NHFinanceManualRecorder alloc] initWithType:NHManualTypeInit withInfo:nil];
    [self.navigationController pushViewController:manualRecorder animated:true];
}

@end
