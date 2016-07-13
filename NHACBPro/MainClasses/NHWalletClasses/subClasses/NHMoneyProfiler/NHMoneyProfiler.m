//
//  NHMoneyProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHMoneyProfiler.h"
#import "NHGoldenConverter.h"
#import "NHCashOutter.h"
#import "NHWebBrowser.h"

#pragma mark -- Custom Cell --

@interface NHRichCell : UITableViewCell

@property (nonatomic, strong) UILabel *m_title;

@property (nonatomic, strong) UILabel *m_time;
@property (nonatomic, strong) UILabel *m_income;

@end

@implementation NHRichCell

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
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    [self.contentView addSubview:self.m_title];
    self.m_title.font = font;
    self.m_title.textColor = color;
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    [self.contentView addSubview:self.m_time];
    self.m_time.font = font;
    self.m_time.textColor = color;
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    [self.contentView addSubview:self.m_income];
    self.m_income.font = font;
    self.m_income.textColor = color;
    self.m_income.textAlignment = NSTextAlignmentRight;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods
- (UILabel *)m_title {
    if (!_m_title) {
        UILabel *label = [[UILabel alloc] init];
        _m_title = label;
    }
    return _m_title;
}

- (UILabel *)m_time {
    if (!_m_time) {
        UILabel *label = [[UILabel alloc] init];
        _m_time = label;
    }
    return _m_time;
}

- (UILabel *)m_income {
    if (!_m_income) {
        UILabel *label = [[UILabel alloc] init];
        _m_income = label;
    }
    return _m_income;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakify(self)
    [self.m_title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, NH_BOUNDARY_MARGIN, 0, 0));
    }];
    [self.m_time mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_income makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, NH_BOUNDARY_MARGIN, 0, NH_BOUNDARY_MARGIN));
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHMoneyProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NHProfileType profileType;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHMoneyProfiler

- (id)initWithProfileType:(NHProfileType)type {
    self = [super init];
    if (self) {
        self.profileType = type;
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = (self.profileType == NHProfileTypeMoney?@"我的余额":(self.profileType == NHProfileTypeGolden?@"我的金币":@"风险保证金"));
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i < 3; i++) {
        NSDictionary *tmp = @{
                              @"action":@"注册新用户",
                              @"amount":PBFormat(@"%zd",arc4random()%400),
                              @"unit":(self.profileType==NHProfileTypeGolden?@"枚":@"元")
                              };
        [arrs addObject:tmp];
    }
    self.dataSource = [NSMutableArray arrayWithArray:[arrs copy]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderBody];
    }
    if (self.shouldRefreshWhenWillShow) {
        self.shouldRefreshWhenWillShow = false;
        //TODO:refresh
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBody {
    
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
    NSString *title = (self.profileType==NHProfileTypeMoney?@"提现":(self.profileType==NHProfileTypeGolden?@"兑换":@"什么是风险保证金？"));
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    CGFloat m_boudary_offset = NH_BOUNDARY_OFFSET * 2;
    UIColor *bgColor = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    color = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    if (self.profileType == NHProfileTypeRiskMargin) {
        bgColor = [UIColor whiteColor];
        color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pageTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(whiteBg.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.bottom.equalTo(whiteBg.mas_bottom).offset(-m_boudary_offset);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
    }];
    //余额
    color = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    NSString *amount = (self.profileType == NHProfileTypeGolden)?@"1129":@"1314.52";
    NSString *unit = (self.profileType == NHProfileTypeGolden)?@"枚":@"元";
    NSString *info = PBFormat(@"%@%@",amount,unit);
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:color,
                                 NSFontAttributeName:font
                                 };
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:info attributes:attributes];
    NSRange boldRange = NSMakeRange(0, amount.length);
    [attributeString addAttribute:NSFontAttributeName value:PBSysBoldFont(NHFontTitleSize*3) range:boldRange];
    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor cyanColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = color;
    label.attributedText = attributeString;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(whiteBg.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.top.equalTo(whiteBg).offset(m_boudary_offset);
        make.bottom.equalTo(btn.mas_top).offset(-m_boudary_offset);
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
    title = (self.profileType==NHProfileTypeMoney?@"余额明细":(self.profileType==NHProfileTypeGolden?@"金币明细":@"保证金明细"));
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    attributes = @{
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
    
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(up_bg_lab.mas_bottom).offset(m_sect_height);
        make.left.bottom.right.equalTo(self.view);
    }];
    //TODO:上拉更多
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_RICH_CELL_HEIGHT           =       50;

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
    return NH_RICH_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"moneyCell";
    NHRichCell *cell = (NHRichCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHRichCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row__];
    
    //TODO:test
    BOOL plus = __row__%2==0;
    NSString *title = [aDic objectForKey:@"action"];
    NSString *amount = [aDic objectForKey:@"amount"];
    NSString *unit = [aDic objectForKey:@"unit"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@%@",plus?@"+":@"-",amount,unit];
    
    [cell layoutIfNeeded];
    cell.m_title.text = title;
    cell.m_time.text = @"2016-3-28";
    cell.m_income.text = info;
    UIColor *plusColor = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    UIColor *minusColor = [UIColor colorWithRed:98/255.f green:159/255.f blue:97/255.f alpha:1];
    cell.m_income.textColor = plus?plusColor:minusColor;
    
    if (__row__ == self.dataSource.count-1) {
        pb_makeCellSeperatorLineTopGrid(cell);
    }
    
    return cell;
}

- (void)pageTypeAction {
    UIViewController *destCtr = nil;
    weakify(self)
    if (NHProfileTypeMoney == self.profileType) {
        NHCashOutter *cashOutter = [[NHCashOutter alloc] init];
        [cashOutter handleCashOutterEvent:^(CGFloat cash, BOOL success) {
            if (success) {
                strongify(self)
                self.shouldRefreshWhenWillShow = true;
                PBMAINDelay(PBANIMATE_DURATION, ^{
                    [self popUpLayer];
                });
            }
        }];
        destCtr = cashOutter;
    }else if (NHProfileTypeGolden == self.profileType){
        NHGoldenConverter *goldenOutter = [[NHGoldenConverter alloc] init];
        [goldenOutter handleConvertGoldenEvent:^(NSInteger amount, BOOL success) {
            if (success) {
                strongify(self)
                self.shouldRefreshWhenWillShow = true;
                PBMAINDelay(PBANIMATE_DURATION, ^{
                    [self popUpLayer];
                });
            }
        }];
        destCtr = goldenOutter;
    }else if (NHProfileTypeRiskMargin == self.profileType){
        //To WebBrowser
    }
    if (destCtr != nil) {
        [self.navigationController pushViewController:destCtr animated:true];
    }
}

@end
