//
//  NHInvestorRinger.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/8.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHInvestorRinger.h"
#import <MJRefresh.h>
#import "NHInvestorRingCell.h"
#import "TTTAttributedLabel.h"
#import "NHPublicTopicer.h"
#import "NHTimelineProfiler.h"

@interface NHInvestorRinger ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NHInvestorRingCell *dynamicCell;

@end

static const NSString *constString = @"相声（Crosstalk），一种民间说唱曲艺。相声一词，古作象生，原指模拟别人的言行，后发展为象声。象声又称隔壁象声。相声起源于华北地区的民间说唱曲艺，在明朝即已盛行。经清朝时期的发展直至民国初年，相声逐渐从一个人摹拟口技发展成为单口笑话，名称也就随之转变为相声。一种类型的单口相声，后来逐步发展为多种类型：单口相声、对口相声、群口相声，综合为一体。相声在两岸三地有不同的发展模式。中国相声有三大发源地：北京天桥、天津劝业场、三不管儿和南京夫子庙。相声艺术源于华北，流行于京津冀，普及于全国及海内外，始于明清，盛于当代。主要采用口头方式表演。表演形式有单口相声、对口相声、群口相声等，是扎根于民间、源于生活、又深受群众欢迎的曲艺表演艺术形式。相声鼻祖为张三禄，著名流派有“马（三立）派”、“侯（宝林）派”、“常（宝堃）派”、“苏（文茂）派”、“马（季）派”等。著名相声表演大师有马三立、侯宝林、常宝堃、苏文茂、刘宝瑞等多人。二十世纪晚期，以侯宝林、马三立为首的一代相声大师相继陨落，相声事业陷入低谷。2005年起，凭借在网络视频网站等新兴媒体的传播，相声演员郭德纲及其德云社异军突起，使公众重新关注相声这一艺术门类，实现了相声的二次复兴。";

static NSString *randomString() {
    int minLen = 7;
    int maxLen = (int)[constString length];
    int tmp_len = arc4random()%(maxLen - minLen) + minLen;
    return [constString substringToIndex:tmp_len];
}

static NSArray *randomTasks() {
    int minLen = 1;
    int maxLen = 5;
    int tmp_len = arc4random()%(maxLen - minLen) + minLen;
    NSMutableArray *tmp_arrs = [NSMutableArray array];
    for (int i = 0; i < tmp_len; i ++) {
        NSString *task = PBFormat(@"完成了任务%d奖励100金币",i);
        [tmp_arrs addObject:task];
    }
    return [tmp_arrs copy];
}
static NSArray *randomImages() {
    int minLen = 0;
    int maxLen = 9;
    int tmp_len = arc4random()%(maxLen - minLen) + minLen;
    NSMutableArray *tmp_arrs = [NSMutableArray array];
    for (int i = 0; i < tmp_len; i ++) {
        [tmp_arrs addObject:@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"];
    }
    return [tmp_arrs copy];
}

@implementation NHInvestorRinger

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"投友圈";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    
    //TODO:test data
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSDictionary *tmp = @{
                              @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                              @"nick":@"天边那云彩",
                              @"time":@"2天前",
                              @"praise":PBFormat(@"%d",i),
                              @"comcount":PBFormat(@"%d",i),
                              @"content":randomString(),
                              @"task":randomTasks(),
                              @"image":randomImages()
                              };
        [arrs addObject:tmp];
    }
    self.dataSource = arrs;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderBodyWithInfos:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBodyWithInfos:(NSArray *)infos {
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = UITableViewAutomaticDimension;
    table.estimatedRowHeight = 80;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, NH_CUSTOM_BTN_HEIGHT, 0));
    }];
    // 初始化 dynamic cell 以便复用
    _dynamicCell = [self.table dequeueReusableCellWithIdentifier:@"codeCell"];
    //发表话题
    UIColor *btnBgColor = [UIColor colorWithRed:127/255.f green:142/255.f blue:227/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = btnBgColor;
    btn.titleLabel.font = PBSysFont(NHFontTitleSize);
    [btn setTitle:@"发表话题" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publicTopicEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 80;
//}

- (CGFloat)calculateHeightForCell:(NHInvestorRingCell *)cell {
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NHInvestorRingCell *cell = _dynamicCell;
//    
//    NSDictionary *info = [_dataSource objectAtIndex:[indexPath row]];
//    [cell setupForDataSource:info];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    CGFloat height = size.height + 1;
//    NSLog(@"heigt row : %f",height);
//    return height;
//}

/**
 *  @brief 注意：UITableViewAutomaticDimension在iOS7下只支持header、footer的估值
 *          不支持row的估值，会返回负值
 *          在iOS8下可以估算rowHeight
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"codeCell";
    NHInvestorRingCell *cell = (NHInvestorRingCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHInvestorRingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
//  [cell setNeedsUpdateConstraints];
//  [cell updateConstraintsIfNeeded];
    
    
    NSDictionary *info = [_dataSource objectAtIndex:[indexPath row]];
    [cell setupForDataSource:info];
    weakify(self)
    [cell handlePraiseEvent:^(NHInvestorRingCell * _Nonnull cl, BOOL praised) {
        
    }];
    [cell handleReportEvent:^(NHInvestorRingCell * _Nonnull cl) {
        strongify(self)
        [self reportTimeLine];
    }];
    [cell handleCommentEvent:^(NHInvestorRingCell * _Nonnull cl) {
        strongify(self)
        [self wentTimeLineDetailer];
    }];
    [cell handleImageBrowseEvent:^(NHInvestorRingCell * _Nonnull cl, NSUInteger idx) {
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self wentTimeLineDetailer];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)wentTimeLineDetailer {
    NHTimelineProfiler *timeLineDetail = [[NHTimelineProfiler alloc] init];
    [self.navigationController pushViewController:timeLineDetail animated:true];
}

- (void)reportTimeLine {
    //TODO:举报什么呢？
}

- (void)publicTopicEvent {
    NHPublicTopicer *publicer = [[NHPublicTopicer alloc] init];
    [self.navigationController pushViewController:publicer animated:true];
}

@end
