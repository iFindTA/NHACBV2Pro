//
//  NHWhoInProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/8.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHWhoInProfiler.h"
#import <MJRefresh.h>
#import "TTTAttributedLabel.h"

@interface NHWhoInProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHWhoInProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"TA们投了";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderBodyForInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBodyForInfo:(NSArray *)infos {
    if (infos.count == 0) {
//        return;
    }
    
    weakify(self)
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    // delete empty cell
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    table.delegate = self;
    table.dataSource = self;
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self refreshing];
    }];
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        strongify(self)
        [self loadMore];
    }];
    table.mj_footer.automaticallyHidden = true;
    table.mj_header.lastUpdatedTimeKey = [self updateKey];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
    }];
    
    //TODO:test datas
    NSMutableArray *tmps = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSDictionary *dic = @{
                              @"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                              @"nick":@"贝西",
                              @"time":@"2016-6-8",
                              @"amount":@"3629",
                              @"unit":@"元"
                              };
        [tmps addObject:dic];
    }
    self.dataSource = [NSMutableArray arrayWithArray:[tmps copy]];
    [self.table reloadData];
}

/**
 *  @brief refresh key
 *
 *  @return the key
 */
- (NSString *)updateKey {
    return NSStringFromClass([self class]);
}

//获取第一页数据
- (void)refreshing {
    
}
//加载更多
- (void)loadMore {
    
    //如果此时没有数据 则加载第一页
    if (PBIsEmpty(self.dataSource)) {
        [self refreshing];
        return;
    }
}

- (BOOL)isRefreshing {
    return (self.table.mj_header.isRefreshing || self.table.mj_footer.isRefreshing);
}

- (void)endRefreshState {
    //结束获取数据状态
    if (self.table.mj_header.isRefreshing) {
        [self.table.mj_header endRefreshing];
    }
    if (self.table.mj_footer.isRefreshing) {
        [self.table.mj_footer endRefreshing];
    }
}

#pragma mark -- table view abouts --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat __h = 75;
    
    return __h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger __row = [indexPath row];
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row];
    
    NSString *url = [aDic objectForKey:@"url"];
    CGFloat icon_size = 40;
    CGFloat m_left_offset = 16;
    UIImageView *img = [[UIImageView alloc] init];
    //TODO:优化点，裁剪图片遮罩不使用圆角
    img.layer.cornerRadius = icon_size*0.5;
    img.layer.masksToBounds = true;
    [cell.contentView addSubview:img];
    [img sd_setImageWithURL:[NSURL URLWithString:url]];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(m_left_offset);
        make.width.height.equalTo(@(icon_size));
    }];
    //nick
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:84/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = PBSysBoldFont(NHFontTitleSize);
    label.text = @"贝西";
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top);
        make.left.equalTo(img.mas_right).offset(@(m_left_offset));
        make.right.equalTo(cell.contentView);
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
    }];
    //time
    UIFont *font = PBSysFont(NHFontSubSize-2);
    NSString *time = [aDic objectForKey:@"time"];
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:198/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.text = time;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(img.mas_bottom);
        make.left.equalTo(img.mas_right).offset(@(m_left_offset));
        make.right.equalTo(cell.contentView);
        make.height.equalTo(@(font.pointSize+4));
    }];
    //line
    color = [UIColor colorWithRed:219/255.f green:219/255.f blue:219/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.left.equalTo(img.mas_right).offset((__row == (self.dataSource.count-1)?@(-m_left_offset*2-icon_size):@(m_left_offset)));
        make.right.equalTo(cell.contentView);
        make.height.equalTo(@1);
    }];
    //amount
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    NSString *amount = [aDic pb_stringForKey:@"amount"];
    NSString *unit = [aDic pb_stringForKey:@"unit"];
    NSString *title = PBFormat(@"%@ %@",amount,unit);
    CGRect bounds = CGRectMake(m_left_offset, (75-icon_size)*0.5, PBSCREEN_WIDTH-m_left_offset*2, icon_size);
    TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
    attributeLabel.userInteractionEnabled = false;
    attributeLabel.font = PBSysFont(NHFontSubSize);
    attributeLabel.textColor = color;
    attributeLabel.textAlignment = NSTextAlignmentRight;
    [attributeLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange colorRange = [[mutableAttributedString string] rangeOfString:amount options:NSNumericSearch];
        CGColorRef rangeColor = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1].CGColor;
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id _Nonnull)(rangeColor) range:colorRange];
        
        return mutableAttributedString;
    }];
    [cell.contentView addSubview:attributeLabel];
    
    return cell;
}

@end
