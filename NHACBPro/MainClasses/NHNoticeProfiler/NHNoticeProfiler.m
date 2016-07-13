//
//  NHNoticeProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHNoticeProfiler.h"
#import <MJRefresh/MJRefresh.h>

#pragma mark -- Custom Cell --

@interface NHUsrNoticeCell : UITableViewCell

@property (nonatomic, strong) UILabel *m_title;
@property (nonatomic, strong) UILabel *m_time;

@end

@implementation NHUsrNoticeCell

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
    UIFont *font = PBFont(@"iconfont",NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    [self.contentView addSubview:self.m_title];
    self.m_title.font = font;
    self.m_title.textColor = color;
    
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    font = PBSysFont(NHFontSubSize);
    [self.contentView addSubview:self.m_time];
    self.m_time.font = font;
    self.m_time.textColor = color;
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
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

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakify(self)
    [self.m_title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    [self.m_time mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_title.mas_bottom);
        make.left.right.equalTo(self.m_title);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHNoticeProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHNoticeProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"knoticer");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSDictionary *not = @{
                              @"title":@"关于端午放假的通知",
                              @"statu":PBFormat(@"%d",i%2),
                              @"time":@"2016-3-29"
                              };
        [arrs addObject:not];
    }
    self.dataSource = [NSMutableArray arrayWithArray:arrs.copy];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderNoticeListBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderNoticeListBody {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.layoutMargins = UIEdgeInsetsZero;
    table.separatorInset = UIEdgeInsetsMake(0, NH_BOUNDARY_MARGIN, 0, 0);
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self refreshing];
    }];
    table.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        strongify(self)
        [self loadMore];
    }];
    //table.mj_footer.automaticallyHidden = true;
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    //TODO:test for error view
    [self removeErrorAlertView];
    [self showErrorType:NHViewErrorTypeNetwork inView:self.view layoutMargin:self.table withTarget:nil withSelector:nil];
}

#pragma mark -- Page Aid Funcs
//当前页码
- (NSUInteger)curPage {
    NSUInteger mPageIdx = 0;
    NSInteger mCounts = self.dataSource.count;
    mPageIdx = labs(mCounts-1)/NH_REFRESH_PAGESIZE + 1;
    return mPageIdx;
}

//此时需要请求的页码
- (NSUInteger)reqPageIdx {
    NSUInteger mPageIdx = [self curPage];
    NSInteger mCounts = self.dataSource.count;
    if (mCounts == 0 || self.table.mj_header.isRefreshing) {
        mPageIdx = 1;
    }else{
        //不是刷新第一页
        mPageIdx ++;
    }
    return mPageIdx;
}

- (BOOL)moreWether {
    //此处仅仅判断已有数据是否是页码的整数倍 也有可能没有了更多数据 以后台返回数据为准
    NSUInteger mCounts = self.dataSource.count;
    return mCounts%NH_REFRESH_PAGESIZE == 0;
}

//没有了更多数据 激活load更多UI状态
- (void)activeNoMoreState {
    if (self.table.mj_footer) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -- MJRefresh Actions--

- (void)refreshing {
    
}

- (void)loadMore {
    BOOL partWetherMore = [self moreWether];
    if (!partWetherMore) {
        [self activeNoMoreState];
    }
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_NOTICE_CELL_HEIGHT           =       60;

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
    return NH_NOTICE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"noticeCell";
    NHUsrNoticeCell *cell = (NHUsrNoticeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHUsrNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell layoutIfNeeded];
    
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDict = [self.dataSource objectAtIndex:__row__];
    NSString *title = [aDict objectForKey:@"title"];
    NSString *time = [aDict objectForKey:@"time"];
    BOOL statu = [[aDict objectForKey:@"statu"] boolValue];
    NSString *_new = @"\U0000e62a";
    if (!statu) {
        UIFont *font = PBFont(@"iconfont",NHFontTitleSize);
        NSString *info = PBFormat(@"%@ %@",title, _new);
        UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName:color,
                                     NSFontAttributeName:font
                                     };
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:info attributes:attributes];
        NSRange colorRange = [info rangeOfString:_new];
        UIColor *rangeColor = [UIColor colorWithRed:213/255.f green:93/255.f blue:91/255.f alpha:1];
        [attributeString addAttribute:NSForegroundColorAttributeName value:rangeColor range:colorRange];
        cell.m_title.attributedText = [attributeString copy];
    }else{
        cell.m_title.text = title;
    }
    cell.m_time.text = time;
    if (__row__ == self.dataSource.count - 1) {
        pb_makeCellSeperatorLineTopGrid(cell);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __row__ = indexPath.row;
    
    [self alertOnUsrAuthorizationStateWithEvent:^(BOOL success) {
        
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
