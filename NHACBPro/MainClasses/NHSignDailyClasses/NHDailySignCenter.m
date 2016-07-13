//
//  NHDailySignCenter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHDailySignCenter.h"

#pragma mark -- Custom Cell --

@interface NHDailySignCell : UITableViewCell

@property (nonatomic, strong) UILabel *m_title;

@property (nonatomic, strong) UILabel *m_time;
@property (nonatomic, strong) UILabel *m_income;

@end

@implementation NHDailySignCell

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
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    [self.m_time mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_income makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHDailySignCenter ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIButton *sign_btn;

@end

@implementation NHDailySignCenter

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"kdailysign");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSDictionary *aDic = @{
                               @"title":@"钱内助",
                               @"time":@"2016-3-23",
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
        [self renderDailySignBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderDailySignBody {
    
    //TODO:本地判断有无签到过
    BOOL isSigned = false;
    
    CGFloat m_bg_h = 165;
    CGFloat m_btn_size = m_bg_h-NH_CUSTOM_LAB_HEIGHT*2;
    weakify(self)
    UIColor *color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UILabel *bgLabel = [[UILabel alloc] init];
    bgLabel.backgroundColor = color;
    [self.view addSubview:bgLabel];
    [bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(m_bg_h);
    }];
    CGFloat img_width = 12;
    UIFont *font = PBSysFont(NHFontTitleSize);
    if (!isSigned) {
        UIImage *icon = [UIImage pb_iconFont:nil withName:@"\U0000e61d" withSize:img_width withColor:color];
        CGSize img_size = icon.size;
        NSDictionary *attributes = @{NSFontAttributeName:font};
        NSString *title = @"今日签到";
        CGSize tit_size = [title sizeWithAttributes:attributes];
        CGFloat m_padding = NH_CONTENT_MARGIN;
        CGFloat m_all_h = img_size.height+tit_size.height+m_padding;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = true;
        btn.titleLabel.font = font;
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = m_btn_size*0.5;
        btn.layer.masksToBounds = true;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-(m_all_h-img_size.height), 0, 0, -tit_size.width);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -img_size.width, -(m_all_h-tit_size.height), 0);
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dailySignAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        self.sign_btn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgLabel.mas_centerX);
            make.centerY.equalTo(bgLabel.mas_centerY);
            make.width.height.equalTo(m_btn_size);
        }];
    }else{
        UIImage *icon = [UIImage pb_iconFont:nil withName:@"\U0000e61e" withSize:img_width withColor:[UIColor whiteColor]];
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.image = icon;
        [self.view addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgLabel).offset(NH_CUSTOM_LAB_HEIGHT+NH_CONTENT_MARGIN);
            make.centerX.equalTo(bgLabel);
            make.width.height.equalTo(img_width*PBSCREEN_SCALE);
        }];
        NSString *signedString = @"今日已签";
        UILabel *label = [[UILabel alloc] init];
        label.font = font;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = signedString;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(imgv.mas_bottom).offset(NH_CONTENT_MARGIN);
            make.left.right.equalTo(self.view);
            make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
        }];
        signedString = @"连续签到金币更多";
        font = PBSysFont(NHFontSubSize);
        UILabel *sub = [[UILabel alloc] init];
        sub.font = font;
        sub.textColor = [UIColor whiteColor];
        sub.textAlignment = NSTextAlignmentCenter;
        sub.text = signedString;
        [self.view addSubview:sub];
        [sub mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(label.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
        }];
    }
    
    CGFloat m_sect_height = 55;
    //分割区
    color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(bgLabel.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(m_sect_height);
    }];
    //中间提示
    NSString *title = @"签到明细";
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    NSDictionary *attributes = @{
                   NSFontAttributeName:font
                   };
    CGSize size = [title sizeWithAttributes:attributes];
    UILabel *sect_title = [[UILabel alloc] init];
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
        make.left.equalTo(bgLabel.mas_left);
        make.right.equalTo(sect_title.mas_left).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@1);
    }];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sect_title.mas_centerY);
        make.left.equalTo(sect_title.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(bgLabel.mas_right);
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
        make.top.equalTo(bgLabel.mas_bottom).offset(m_sect_height);
        make.left.bottom.right.equalTo(self.view);
    }];
    //TODO:上拉更多
}

/**
 *  @brief refresh state after signed today!
 */
- (void)refreshTodaySignState {
    
    [self.sign_btn removeFromSuperview];
    _sign_btn = nil;
    weakify(self)
    CGFloat img_width = 12;
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIImage *icon = [UIImage pb_iconFont:nil withName:@"\U0000e61e" withSize:img_width withColor:[UIColor whiteColor]];
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = icon;
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view).offset(NH_CUSTOM_LAB_HEIGHT+NH_CONTENT_MARGIN);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(img_width*PBSCREEN_SCALE);
    }];
    NSString *signedString = @"今日已签";
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = signedString;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(imgv.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.right.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    signedString = @"连续签到金币更多";
    font = PBSysFont(NHFontSubSize);
    UILabel *sub = [[UILabel alloc] init];
    sub.font = font;
    sub.textColor = [UIColor whiteColor];
    sub.textAlignment = NSTextAlignmentCenter;
    sub.text = signedString;
    [self.view addSubview:sub];
    [sub mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_DAILYSIGN_CELL_HEIGHT           =       50;

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
    return NH_DAILYSIGN_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"dailyCell";
    NHDailySignCell *cell = (NHDailySignCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHDailySignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    UIColor *plusColor = [UIColor colorWithRed:215/255.f green:105/255.f blue:100/255.f alpha:1];
    UIColor *minusColor = [UIColor colorWithRed:98/255.f green:159/255.f blue:97/255.f alpha:1];
    [cell layoutIfNeeded];
    cell.m_title.text = title;
    cell.m_time.text = @"2016-3-28";
    cell.m_income.text = info;
    cell.m_income.textColor = plus?plusColor:minusColor;
    
    if (__row__ == self.dataSource.count-1) {
        pb_makeCellSeperatorLineTopGrid(cell);
    }
    
    return cell;
}

#pragma mark -- sign action

- (void)dailySignAction {
    //TODO:联网签到
    //本地保存签到记录
    
    //刷新页面
    [self refreshTodaySignState];
}

@end
