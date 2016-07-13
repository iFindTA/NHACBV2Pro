//
//  ViewController.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "NHDBEngine.h"
#import "NHAFEngine.h"
#import "SWRevealViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "NHUserProfiler.h"
#import <MJRefresh.h>
#import "NHWebBrowser.h"
#import "NHMarqueLabel.h"
#import "NHFlipper.h"
#import "NHNoticeCell.h"
#import "NHImageCell.h"
#import "NHCarouseler.h"
#import "NHActivityCell.h"
#import "NHProductProfiler.h"
#import "NHActivityProfiler.h"
#import "UIBarButtonItem+Badge.h"

@interface ViewController ()<SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, NHFlipperDataSource, NHFlipperDelegate, NHCarouselerDelegate, NHCarouselerDataSource>

@property (nonatomic, strong) UIControl *maskLayer;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UIBarButtonItem *menuBarItem,*noticeBarItem;
@property (nonatomic, strong) NSArray *bannerSource,*newsSource;
@property (nonatomic, strong) NHCarouseler *carouseler;
@property (nonatomic, strong) NHFlipper *flipper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"AiCaiMOMO";
    UIView *tmpBG = [[UIView alloc] initWithFrame:self.view.bounds];
    tmpBG.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tmpBG];
//    [tmpBG mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
#if NH_USE_SWREVAL_FRAMEWORK
    SWRevealViewController *revealController = [self revealViewController];
    revealController.rearViewRevealWidth = PBSCREEN_WIDTH-NH_SIDE_OFF_WIDTH;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    revealController.delegate = self;
#endif
    
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:@"\U0000e600" withTarget:self withSelector:@selector(toggleSideFramework)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    self.menuBarItem = menuBar;
    //right
//    UIBarButtonItem *newsBar = [self barWithIcon:@"\U0000e610" withTarget:self withSelector:@selector(newsShowAction)];
    UIBarButtonItem *newsBar = [self barWithImage:[UIImage imageNamed:@"m_infomention"] withTarget:self withSelector:@selector(newsShowAction)];
//    UIBarButtonItem *msgBar = [self barWithIcon:@"\U0000e604" withTarget:self withSelector:@selector(msgShowAction)];
    UIBarButtonItem *msgBar = [self barWithImage:[UIImage imageNamed:@"m_notice"] withTarget:self withSelector:@selector(msgShowAction)];
    self.navigationItem.rightBarButtonItems = @[spacer ,msgBar,spacer,newsBar];
    self.noticeBarItem = msgBar;
    
    weakify(self)
    PBBACK(^{
        strongify(self)
        [self customSVProgressHUD];
        [[NHAFEngine share] cancelRequestForpath:@""];
    });
    // new thread to check version
    [self performSelectorInBackground:@selector(autoDetectVersion) withObject:nil];
    
}

/**
 *  @brief refresh key
 *
 *  @return the key
 */
- (NSString *)updateKey {
    return NSStringFromClass([self class]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s",__FUNCTION__);
    
    if (!self.table) {
        [self renderDefaultUIBody];
    }else{
        
    }
    
    if (!self.isInitialized) {
        self.isInitialized = true;
        [self __initSetupDataSource];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endRefreshState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    weakify(self);PBBACK(^{strongify(self);[self fetchNewestAD];});
}

#pragma mark -- 渲染主页

- (void)renderDefaultUIBody {
    
    [self removeErrorAlertView];
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    weakify(self)
    //table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    // delete empty cell
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    table.delegate = self;
    table.dataSource = self;
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongify(self)
        [self refreshing];
    }];
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        strongify(self)
        [self loadMore];
    }];
    //table.mj_footer.automaticallyHidden = true;
    table.mj_header.lastUpdatedTimeKey = [self updateKey];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
    }];
    
    //prepare cache'ed datas
    NSDictionary *aDict = [self getBanner];
    NSArray *banner = [aDict objectForKey:@"banner"];
    banner = PBIsEmpty(banner)?@[]:banner;
    NSArray *news = [aDict objectForKey:@"news"];
    news = PBIsEmpty(news)?@[]:news;
    self.bannerSource = [NSArray arrayWithArray:banner];
    self.newsSource = [NSArray arrayWithArray:news];
    [self.carouseler reloadData];[self.flipper reloadData];
    
    [self wetherAutoRefreshData];
}

#pragma mark -- save/get banner

static NSString *bannerPath = @"/Documents/banner.json";

- (void)reloadBannerAndBroadcardInfos {
    PBBACK((^{
        [[NHAFEngine share] GET:@"indexTop" parameters:nil vcr:nil view:nil hudEnable:false success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObj) {
            NSArray *banner = [responseObj objectForKey:@"bannerList"];
            banner = PBIsEmpty(banner)?@[]:banner;
            NSArray *news = [responseObj objectForKey:@"newsList"];
            news = PBIsEmpty(news)?@[]:news;
            self.bannerSource = [NSArray arrayWithArray:banner];
            self.newsSource = [NSArray arrayWithArray:news];
            if (self.table) {
                PBMAINDelay(PBANIMATE_DURATION, ^{[self.carouseler reloadData];[self.flipper reloadData];});
            }
            NSDictionary *tmp = @{@"banner":banner,@"news":news};
            [self saveBanner:tmp];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }));
}

- (void)saveBanner:(NSDictionary *)aDict {
    if (aDict) {
        NSString *path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:bannerPath];
        BOOL ret = [aDict writeToFile:path atomically:false];
        if (!ret) {
            NSLog(@"保存banner失败了");
        }else{
            //数据保护
            NSDictionary *sectDict = @{NSFileProtectionKey:NSFileProtectionComplete};
            [[NSFileManager defaultManager] setAttributes:sectDict ofItemAtPath:path error:nil];
        }
    }
}

- (NSDictionary *)getBanner {
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:bannerPath];
    NSDictionary *aDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (aDict) {
        return aDict;
    }
    return nil;
}

#pragma mark -- 全局配置

- (void)refreshGlobalConfigure {
    //木有网
    
}

#pragma mark -- ADS abouts --

//某个合适的时机去下载广告
- (void)fetchNewestAD {
    
    //保存到数据库
    [[NHDBEngine share] saveAD:nil];
    
    //更新审核开关
    //[[NHDBEngine share] syncronizedConfigReviewed:1];
    
    //最后去后台下载广告图片
    [self autoLoadADs];
}

- (void)autoLoadADs {
    [[NHDBEngine share] clearExpiredADs];
    BOOL ret = ![[NHDBEngine share] adLoading];
    ret &= [[NHAFEngine share] wifiEnable];
    if (![[NHDBEngine share] adLoading] && [[NHAFEngine share] wifiEnable]) {
        NSLog(@"auto download");
        PBBACK(^{[[NHDBEngine share] autoDownloadADsViaWifi];});
    }
}

#pragma mark -- SVProgressHUD Custom --

- (void)customSVProgressHUD {
    UIColor *foregroundColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIColor *backgroundColor = [UIColor lightGrayColor];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:foregroundColor];
    [SVProgressHUD setBackgroundColor:backgroundColor];
    [SVProgressHUD setMinimumDismissTimeInterval:PBANIMATE_DURATION*4];
}

#pragma mark -- navigation bar actions --

- (void)toggleSideFramework {
#if NH_USE_SWREVAL_FRAMEWORK
    SWRevealViewController *revealController = [self revealViewController];
    [self disOrEnableUserInterAction:revealController];
    [revealController revealToggle:nil];
#else
    JASidePanelController *sidePanelControllrt = [self sidePanelController];
    [sidePanelControllrt toggleLeftPanel:nil];
#endif
}

#pragma mark -- SWRevealCongtroller --

- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    BOOL should = true;
    
    return should;
}

- (BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController {
    BOOL should = true;
    NSArray *tmpStacks = [self.navigationController viewControllers];
    should = tmpStacks.count == 1;
    return should;
}

- (BOOL)revealController:(SWRevealViewController *)revealController panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] ||
        [otherGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]] ||
        otherGestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        //        return true;
    }
    
    return false;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    BOOL close = position <= FrontViewPositionLeft;
    if (close) {
        [self.maskLayer removeFromSuperview];
        self.maskLayer = nil;
    }else{
        [self.maskLayer addTarget:self action:@selector(maskToggleEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.maskLayer];
        [self.view bringSubviewToFront:self.maskLayer];
    }
}

/**
 *  @brief show mask when revalController show left panel, otherwise hidden
 *          mask layer
 */
- (void)disOrEnableUserInterAction:(SWRevealViewController *)reveal {
    
}

- (UIControl *)maskLayer {
    if (_maskLayer == nil) {
        UIControl *tmp = [[UIControl alloc] initWithFrame:self.view.bounds];
        //tmp.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        _maskLayer = tmp;
    }
    return _maskLayer;
}

- (void)maskToggleEvent {
    NSLog(@"mask event");
    [self toggleSideFramework];
}

- (void)newsShowAction {
    /*
    Class aClass = NSClassFromString(@"NHFinanceNewsProfiler");
    UIViewController *instance = [[aClass alloc] init];
    if (instance) {
        [self.navigationController pushViewController:instance animated:true];
    }
    //*/
    NSDictionary *js = @{@"idfier":@"active/share?",@"js":@"var style = document.createElement('style');style.type = 'text/css';style.innerHTML = '.download,.gscj-code-div{display: none !important;}';document.head.appendChild(style);"};
    static NSString *url = @"https://caijing.gongshidai.com/active/tlist";
    NHWebBrowser *webBrowser = [NHWebBrowser browser];
    webBrowser.showMoreAction = false;
    webBrowser.externHosts = @[@"gongshidai.com"];
    webBrowser.externJavaScripts = @[js];
    [self.navigationController pushViewController:webBrowser animated:true];
    [webBrowser loadURL:[NSURL URLWithString:url]];
}

- (void)msgShowAction {
    Class aClass = NSClassFromString(@"NHNoticeProfiler");
    UIViewController *instance = [[aClass alloc] init];
    if (instance) {
        [self.navigationController pushViewController:instance animated:true];
    }
}

- (void)testAction {
    NSLog(@"test action");
    NHWebBrowser *webBrowser = [NHWebBrowser browser];
    //[webBrowser setDelegate:self];
    [self.navigationController pushViewController:webBrowser animated:YES];
    [webBrowser loadURL:[NSURL URLWithString:@"https://github.com/iFindTA"]];
}

#pragma mark -- 侧边栏 委托 --

- (void)userProfiler:(NHUserProfiler *)profiler didToggleClass:(NSString *)aClass {
    NSLog(@"toggle to class :%@",aClass);
#if NH_USE_SWREVAL_FRAMEWORK
    SWRevealViewController *revealController = [self revealViewController];
    [self disOrEnableUserInterAction:revealController];
#else
    JASidePanelController *revealController = [self sidePanelController];
#endif
    revealController.view.userInteractionEnabled = false;
    
    Class class__ = NSClassFromString(aClass);
    UIViewController *m_instance = [[class__ alloc] init];
    if (m_instance != nil) {
        NSMutableArray *tmps = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [tmps addObject:m_instance];
        [self.navigationController setViewControllers:[tmps copy] animated:false];
#if NH_USE_SWREVAL_FRAMEWORK
        [revealController revealToggle:nil];
#else
        [revealController toggleLeftPanel:nil];
#endif
    }
    
    revealController.view.userInteractionEnabled = true;
}

- (BOOL)classNeedAuthority:(NSString *)aClass {
    
    BOOL should_author = false;
    if ([aClass isEqualToString:@""]
        ||[aClass isEqualToString:@""]
        ||[aClass isEqualToString:@""]) {
        
        //wether logined
    }
    
    
    return should_author;
}

#pragma mark -- 网络数据 --

- (NSArray *)generateRandomDataSource {
    NSMutableArray *tmps = [NSMutableArray array];
    
    NSDictionary *aDic = @{
                           @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                           @"name":@"钱内助活动专区",
                           @"activity":@[
                                   @{
                                       @"title":@"注册并完成一笔投资",
                                       @"amout":@"5700",
                                       @"unit":@"金币",
                                       @"tags":@[@"新手专享",@"1000起投"]
                                       },
                                   @{
                                       @"title":@"单笔投资10000元",
                                       @"amout":@"1%",
                                       @"unit":@"返现",
                                       @"tags":@[@"定期",@"10000起投",@"单笔投资最高返现10000元"]
                                       }
                                   ]
                           };
    NSDictionary *aDic_1 = @{
                             @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                             @"name":@"懒人投资活动专区",
                             @"activity":@[
                                     @{
                                         @"title":@"单笔投资1000元",
                                         @"amout":@"1000",
                                         @"unit":@"金币",
                                         @"tags":@[@"新手专享",@"1000起投"]
                                         }
                                     ]
                             };
    NSDictionary *aDic_2 = @{
                             @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                             @"name":@"温州贷活动专区",
                             @"activity":@[
                                     @{
                                         @"title":@"单笔投资3000元",
                                         @"amout":@"3000",
                                         @"unit":@"金币",
                                         @"tags":@[@"新手专享",@"3000起投",@"注册并实名认证"]
                                         }
                                     ]
                             };
    [tmps addObject:aDic];
    [tmps addObject:aDic_1];
    [tmps addObject:aDic_2];
    return [tmps copy];
}

- (void)__initSetupDataSource {
    //取缓存
    NSDictionary *tmpBanner = [self getBanner];
    if (tmpBanner) {
        NSArray *arr = [tmpBanner objectForKey:@"banner"];
        self.bannerSource = [NSArray arrayWithArray:arr];
        arr = [tmpBanner objectForKey:@"news"];
        self.newsSource = [NSArray arrayWithArray:arr];
        if (self.carouseler) {
            [self.carouseler reloadData];
        }
        if (self.flipper) {
            [self.flipper reloadData];
        }
    }
//    NSArray *activities = [[NHDBEngine share] getActivities];
//    if (_dataSource) {
//        _dataSource = nil;
//    }
//    self.dataSource = [NSMutableArray arrayWithArray:activities];
//    if (self.table) {
//        [self.table reloadData];
//    }
//    
//    //如果有则刷新
//    if (PBIsEmpty(activities)) {
//        
//    }
    
    //此时联网获取第一页数据 触发自动刷新
    
    //此时刷新用户 审核状态等
    
    //是否今日签到
}

//导航栏状态
- (void)reloadNaviBarState {
    
}

//是否需要自动刷新第一页数据
- (void)wetherAutoRefreshData {
    if (!PBIsEmpty(self.dataSource)) {
        [self refreshing];
        return;
    }
    NSDate *last = self.table.mj_header.lastUpdatedTime;
    if ([[NSDate date] timeIntervalSinceDate:last] > NH_REFRESH_INTERVAL || !last) {
        [self refreshing];
        return;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return pb_autoResize(125, NH_DESIGN_REFRENCE);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //table header
    CGFloat car_h = 90;
    CGFloat flip_h = 35;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, pb_autoResize(car_h+flip_h, NH_DESIGN_REFRENCE))];
    //header.backgroundColor = [UIColor blueColor];
    NHCarouseler *carouseler = [[NHCarouseler alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, car_h)];
    carouseler.dataSource = self;
    carouseler.delegate = self;
    [header addSubview:carouseler];
    self.carouseler = carouseler;
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_SEPERATE_LINE_HEX)].CGColor;
    line.frame = CGRectMake(0, car_h, PBSCREEN_WIDTH, 1);
    [header.layer addSublayer:line];
    UIImage *img = [UIImage imageNamed:@"touzizhinan"];
    CGSize size = img.size;int scale = img.scale;
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = img;
    [header addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(NH_BOUNDARY_OFFSET));
        make.top.equalTo(@(car_h+(flip_h-size.height/scale)*0.5));
        make.width.equalTo(size.width/scale);
        make.height.equalTo(size.height/scale);
    }];
    //竖线
    line = [CALayer layer];
    line.backgroundColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_SEPERATE_LINE_HEX)].CGColor;
    CGFloat line_start_x = NH_BOUNDARY_OFFSET*1.5+size.width/scale;
    line.frame = CGRectMake(line_start_x, car_h+(flip_h-size.height/scale)*0.5, 1, size.height/scale);
    [header.layer addSublayer:line];
    //flipper
    NHFlipper *flipper = [[NHFlipper alloc] init];
    flipper.direction = NHFlipperDirectionDefault;
    flipper.dataSource = self;
    flipper.delegate = self;
    [header addSubview:flipper];
    self.flipper = flipper;
    [flipper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(car_h));
        make.left.equalTo(@(NH_BOUNDARY_OFFSET*2+size.width/scale));
        make.width.equalTo(@(PBSCREEN_WIDTH-NH_BOUNDARY_OFFSET-line_start_x));
        make.height.equalTo(@(flip_h));
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat __h = 0;
    
    NSInteger __row = [indexPath row];
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row];
    __h = [NHActivityCell heightForInfo:aDic];
    
    return __h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NHActivityCell *cell = (NHActivityCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger __row = [indexPath row];
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row];
    
    cell.tag = __row;
    [cell setupForInfo:aDic];
    weakify(self)
    [cell handleActivityTouchEvent:^(NHActivityCell *cl, NSUInteger idx) {
        strongify(self)
//        NSUInteger __tag = cell.tag;
//        NSDictionary *aDic = [self.dataSource objectAtIndex:__row];
//        NSArray *activities = [aDic objectForKey:@"activity"];
//        NSDictionary *tmp = [activities objectAtIndex:__tag];
//        [self didSelectActivity:tmp];
        //TODO:test
        [self didSelectActivity:nil];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger __row = [indexPath row];
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row];
    NSString *name = [aDic objectForKey:@"name"];
    NHProductProfiler *producter = [[NHProductProfiler alloc] init];
    producter.productName = name;
//    producter.productID = @";"
    [self.navigationController pushViewController:producter animated:true];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)didSelectActivity:(NSDictionary *)aDic {
//    NSNumber *numID = [aDic objectForKey:@"id"];
    NHActivityProfiler *activitier = [[NHActivityProfiler alloc] init];
    activitier.activityName = @"活动详情";
//    activitier.activityID = numID;
    [self.navigationController pushViewController:activitier animated:true];
}

#pragma mark -- Marque --

- (int)numberLinesInMarque:(NHMarqueLabel *)marque {
    return 5;
}

- (NSString *)marque:(NHMarqueLabel *)marque infoForIndex:(NSInteger)index {
    return PBFormat(@"公告部区:%zd公告",index);
}

#pragma mark -- Flipper --

- (NSInteger)numberOfRowsForFlipper:(NHFlipper *)flipper {
    return self.newsSource.count;
}

- (NHFlipperCell *)flipper:(NHFlipper *)flipper cellForRowIndex:(NSInteger)index {
    static NSString *identifier = @"flipper";
    NHNoticeCell *cell = (NHNoticeCell *)[flipper dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHNoticeCell alloc] initWithIdentifier:identifier];
    }
    
    NSDictionary *aDict = [self.newsSource objectAtIndex:index];
    NSString *type = [aDict objectForKey:@"type"];
    NSString *title = type.intValue == 1?@"公告":@"资讯";
    NSString *subInfo = [aDict objectForKey:@"title"];
    
    [cell layoutIfNeeded];
    cell.mTitleLabel.text = title;
    cell.mSubLabel.text = subInfo;
    
    return cell;
}

- (void)flipper:(NHFlipper *)flipper didSelectRowIndex:(NSInteger)row {
    NSLog(@"did select flipper's idx :%zd",row);
}

#pragma mark -- Carouser Delegate

- (NSInteger)numberOfRowsForCarouseler:(NHCarouseler *)carouseler {
    return self.bannerSource.count;
}

- (NHCarouselerCell *)carouseler:(NHCarouseler *)view cellForRowIndex:(NSUInteger)index {
    static NSString *identifier = @"carouseler";
    NHImageCell *cell = (NHImageCell *)[view dequeueReusablePageWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHImageCell alloc] initWithIdentifier:identifier];
    }
    
    NSDictionary *aDict = [self.bannerSource objectAtIndex:index];
    NSString *url = [aDict objectForKey:@"img_src"];
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
}

- (void)carouseler:(NHCarouseler *)view didSelectedIndex:(NSUInteger)index {
    NSLog(@"banner idx:%zd",index);
}

#pragma mark -- other things that excute in background modes --

- (void)autoDetectVersion {
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [bundleInfo objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *cnn = [bundleInfo objectForKey:@"CHANNEL"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
