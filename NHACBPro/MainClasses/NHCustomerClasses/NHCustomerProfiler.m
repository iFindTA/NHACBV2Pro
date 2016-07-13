//
//  NHCustomerProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHCustomerProfiler.h"
#import "NHUsrActivityProfiler.h"

#pragma mark -- Custom Cell --

static int NH_ICON_SIZE                 =       40;

@implementation NHFrindActCell

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
    
    [self.contentView addSubview:self.m_icon];
    
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    [self.contentView addSubview:self.m_nick];
    self.m_nick.font = font;
    self.m_nick.textColor = color;
    
    font = PBSysFont(NHFontSubSize);
    [self.contentView addSubview:self.m_act];
    [self.contentView addSubview:self.m_income];
    self.m_act.font = font;
    self.m_income.font = font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods
- (UIImageView *)m_icon {
    if (!_m_icon) {
        UIImageView *imgv = [[UIImageView alloc] init];
        //TODO:优化点 使用圆形遮罩提高效率
        imgv.layer.cornerRadius = NH_ICON_SIZE*0.5;
        imgv.layer.masksToBounds = true;
        _m_icon = imgv;
    }
    return _m_icon;
}

- (UILabel *)m_nick {
    if (!_m_nick) {
        UILabel *label = [[UILabel alloc] init];
        _m_nick = label;
    }
    return _m_nick;
}

- (UILabel *)m_act {
    if (!_m_act) {
        UILabel *label = [[UILabel alloc] init];
        _m_act = label;
    }
    return _m_act;
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
    
    CGFloat mWidth = PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2-NH_CONTENT_MARGIN;
    CGFloat m_scale = 0.66;
    weakify(self)
    [self.m_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.width.and.height.equalTo(NH_ICON_SIZE);
    }];
    [self.m_nick mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_icon);
        make.left.equalTo(self.m_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_act mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.left.equalTo(self.m_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.bottom.equalTo(self.m_icon);
        make.size.equalTo(CGSizeMake(mWidth*(1-m_scale), NHFontSubSize));
    }];
    [self.m_income mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.left.equalTo(self.m_act.mas_right).offset(NH_CONTENT_MARGIN);
        make.bottom.equalTo(self.m_icon);
        make.right.equalTo(self.contentView);
        make.height.equalTo(NHFontSubSize);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHCustomerProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHCustomerProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"我的好友";
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
        [self renderFriendActivityBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderFriendActivityBody {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.separatorInset = UIEdgeInsetsMake(0, NH_ICON_SIZE+NH_BOUNDARY_MARGIN+NH_CONTENT_MARGIN, 0, 0);
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
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

@end
