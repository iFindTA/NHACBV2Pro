//
//  NHTimelineProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHTimelineProfiler.h"
#import "NHInvestorRingCell.h"
#import "NHTimeLineCell.h"
#import "NHEmitterButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NHCommenter.h"

@interface NHTimelineProfiler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *headerDic;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NHEmitterButton *praiseBtn;

@property (nonatomic, strong) NHInvestorRingCell *ringCell;
@property (nonatomic, strong) NHTimeLineCell *timeLineCell;

@property (nonatomic, strong) NHCommenter *commenter;

@end

static const NSString *constString = @"相声（Crosstalk），一种民间说唱曲艺。相声一词，古作象生，原指模拟别人的言行，后发展为象声。象声又称隔壁象声。相声起源于华北地区的民间说唱曲艺，在明朝即已盛行。经清朝时期的发展直至民国初年，相声逐渐从一个人摹拟口技发展成为单口笑话，名称也就随之转变为相声。一种类型的单口相声，后来逐步发展为多种类型：单口相声、对口相声、群口相声，综合为一体。";

static NSString *randomString() {
    int minLen = 7;
    int maxLen = (int)[constString length];
    int tmp_len = arc4random()%(maxLen - minLen) + minLen;
    return [constString substringToIndex:tmp_len];
}

static NSArray *randomComments() {
    int minLen = 0;
    int maxLen = 25;
    int tmp_len = arc4random()%(maxLen - minLen) + minLen;
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < tmp_len; i++) {
        NSDictionary *coms = @{
                               @"from":(i%2 == 0)?@"寂寞大贪官":@"帅🐔哥哥",
                               @"to":(i%2 == 0)?@"帅🐔哥哥":@"寂寞大贪官",
                               @"content":randomString()
                               };
        [arrs addObject:coms];
    }
    return [arrs copy];
}

@implementation NHTimelineProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"详情";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test data
    NSMutableArray *arrs = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
//        NSDictionary *tmp = @{
//                              @"icon":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
//                              @"nick":@"天边那云彩",
//                              @"time":@"2天前",
//                              @"content":randomString(),
//                              @"comments":randomComments()
//                              };
        NHTimelineModel *model = [[NHTimelineModel alloc] init];
        model.icon = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
        model.nick = @"天边那云彩";
        model.time = @"2天前";
        model.content = randomString();
        NSArray *comss = randomComments();
        NSUInteger counts = [comss count];
        model.numsCount = [NSNumber numberWithInteger:counts];
        model.disCount = [NSNumber numberWithInteger:(counts > 3)?3:counts];
        model.comments = comss;
        [arrs addObject:model];
    }
    self.dataSource = arrs;
    
    NSDictionary *aDic = @{
                           @"comcount" : @"3",
                           @"content" :[constString substringToIndex:56],
                           @"icon" : @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                           @"image" : @[
                                   @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg",
                                   @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"
                                   ],
                           @"nick" : @"那一抹阳光",
                           @"praise" : @"4",
                           @"task" : @[
                                   @"任务一完成了",
                                   @"完成了新手注册",
                                   @"完成了投资1000块首笔"
                                   ],
                           @"time" : @"2天前"
                           };
    self.headerDic = [NSDictionary dictionaryWithDictionary:aDic];
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
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    /**when cell's data was dynamic, you should not use estimateHeight method!**/
    /*when use estimateHeight method, note 3line code below than*/
    //table.rowHeight = UITableViewAutomaticDimension;
    //table.estimatedRowHeight = 300;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    
    [self.table registerClass:[NHInvestorRingCell class] forCellReuseIdentifier:@"codeCell"];
    [self.table registerClass:[NHTimeLineCell class] forCellReuseIdentifier:@"timeLineCell"];
    // 初始化 dynamic cell 以便复用
    _ringCell = [self.table dequeueReusableCellWithIdentifier:@"codeCell"];
    _timeLineCell = [self.table dequeueReusableCellWithIdentifier:@"timeLineCell"];
    
    [self.table reloadData];
}

#pragma mark -- generate header 

- (UIView *)headerTimeLine {
    
    NSDictionary *aDic = self.headerDic;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, MAXFLOAT)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    int m_left_offset = NH_BOUNDARY_MARGIN;
    int m_icon_size = 25;
    NSString *url = [aDic objectForKey:@"icon"];
    UIImageView *img_v = [[UIImageView alloc] initWithFrame:CGRectZero];
    //TODO:优化点，裁剪图片遮罩不使用圆角
    img_v.layer.cornerRadius = m_icon_size*0.5;
    img_v.layer.masksToBounds = true;
    [contentView addSubview:img_v];
    [img_v sd_setImageWithURL:[NSURL URLWithString:url]];
    //weakify(self)
    [img_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(contentView).offset(m_left_offset);
        make.width.height.equalTo(@(m_icon_size));
    }];
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    UILabel *nick = [[UILabel alloc] init];
    nick.font = font;
    nick.textColor = color;
    nick.text = @"贝西";
    [contentView addSubview:nick];
    [nick mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(img_v.mas_top);
        make.bottom.equalTo(img_v.mas_bottom);
        make.left.equalTo(img_v.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(contentView).offset(-m_left_offset);
    }];
    //time
    font = PBSysFont(NHFontSubSize);
    UILabel *time = [[UILabel alloc] init];
    time.font = font;
    time.textColor = color;
    time.textAlignment = NSTextAlignmentRight;
    time.text = @"一天前";
    [contentView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(img_v.mas_top);
        make.bottom.equalTo(img_v.mas_bottom);
        make.left.equalTo(img_v.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(contentView).offset(-m_left_offset);
    }];
    //content
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *content = [[UILabel alloc] init];
    content.font = font;
    content.textColor = color;
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.preferredMaxLayoutWidth = PBSCREEN_WIDTH-m_left_offset*2-NH_CONTENT_MARGIN;
    content.text = constString;
    [contentView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(img_v.mas_bottom).offset(m_left_offset);
        make.left.equalTo(contentView).offset(m_left_offset);
        make.right.equalTo(time).offset(-NH_CONTENT_MARGIN);
        //make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    //*
    UIView *tmp_algin_view = content;
    //images: broke old layout and build new layout
    NSArray *images = [aDic objectForKey:@"image"];
    if (images.count) {
        CGFloat m_img_h = 85;
        CGFloat m_img_cap = NH_BOUNDARY_MARGIN;
        int m_img_num_per_line = 3;
        CGFloat m_img_w = (PBSCREEN_WIDTH-m_img_cap*(m_img_num_per_line+1))/m_img_num_per_line;
        __block UIButton *last_btn = nil;
        __block NSUInteger line_row_idx = 0;
        __block NSUInteger last_line_row_idx = 0;
        weakify(self)
        [images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            strongify(self)
            //行数 索引
            line_row_idx = idx / m_img_num_per_line;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000+idx;
            [btn addTarget:self action:@selector(imageBrwoserAction:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];
            [btn sd_setImageWithURL:[NSURL URLWithString:obj] forState:UIControlStateNormal];
            //weakify(self)
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                //strongify(self)
                make.top.equalTo((last_btn==nil)?tmp_algin_view.mas_bottom:((line_row_idx==last_line_row_idx)?last_btn.mas_top:last_btn.mas_bottom)).offset((last_btn==nil)?NH_BOUNDARY_MARGIN:((line_row_idx==last_line_row_idx)?0:NH_BOUNDARY_MARGIN));
                make.left.equalTo((last_btn==nil)?contentView:(line_row_idx==last_line_row_idx)?(last_btn.mas_right):(contentView)).offset(NH_BOUNDARY_MARGIN);
                make.width.equalTo(@(m_img_w));
                make.height.equalTo(@(m_img_h));
            }];
            
            last_btn = btn;
            last_line_row_idx = line_row_idx;
        }];
        
        tmp_algin_view = last_btn;
    }
    
    //tasks:broke the layout and build new layout
    NSArray *tasks = [aDic objectForKey:@"task"];
    if (tasks.count) {
        CGFloat m_task_h = 35;
        UIColor *color = [UIColor colorWithRed:161/255.f green:163/255.f blue:178/255.f alpha:1];
        UIColor *bgColor = [UIColor colorWithRed:243/255.f green:244/255.f blue:250/255.f alpha:1];
        UIFont *font = PBFont(@"iconfont", NHFontSubSize);
        __block UILabel *last_view = nil;
        //weakify(self)
        [tasks enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //strongify(self)
            NSMutableString *tmp = [NSMutableString stringWithString:obj];
            [tmp insertString:@"  \U0000e611 " atIndex:0];
            UILabel *label = [[UILabel alloc] init];
            label.tag = 1000+idx;
            label.font = font;
            label.textColor = color;
            label.backgroundColor = bgColor;
            label.text = [tmp copy];
            [contentView addSubview:label];
            //weakify(self)
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                //strongify(self)
                make.top.equalTo((last_view == nil)?tmp_algin_view.mas_bottom:last_view.mas_bottom).offset((last_view == nil)?NH_BOUNDARY_MARGIN:NH_CONTENT_MARGIN);
                make.left.equalTo(contentView).offset(NH_BOUNDARY_MARGIN);
                make.right.equalTo(contentView).offset(-NH_BOUNDARY_MARGIN);
                make.height.equalTo(@(m_task_h));
            }];
            
            last_view = label;
        }];
        
        tmp_algin_view = last_view;
    }
    //*/
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(tmp_algin_view.mas_bottom).offset(m_left_offset);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@1);
    }];
    //竖线
    CGFloat mSeperate3_w = PBSCREEN_WIDTH/3.f;
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.left.equalTo(contentView).offset(mSeperate3_w);
        make.width.equalTo(@1);
        make.height.equalTo(@(m_icon_size));
    }];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.right.equalTo(contentView).offset(-mSeperate3_w);
        make.width.equalTo(@1);
        make.height.equalTo(@(m_icon_size));
    }];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(vLine.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@1);
    }];
    //btn
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:198/255.f alpha:1];
    UIImage *img_s = [UIImage imageNamed:@"praise_select"];
    UIImage *img_n = [UIImage imageNamed:@"praise_unselect"];
    NHEmitterButton *praise = [NHEmitterButton buttonWithType:UIButtonTypeCustom];
    [praise setImage:img_s forState:UIControlStateSelected];
    [praise setImage:img_n forState:UIControlStateNormal];
    [praise addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    praise.exclusiveTouch = true;
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, NH_CONTENT_MARGIN, 0, 0);
    praise.titleLabel.font = PBSysFont(NHFontSubSize);
    [praise setTitleColor:color forState:UIControlStateNormal];
    [contentView addSubview:praise];
    self.praiseBtn = praise;
    [praise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.centerY.equalTo(vLine.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    //comment
    NSString *comments = [aDic objectForKey:@"comcount"];
    NSMutableString *tmpComms = [NSMutableString stringWithString:comments];
    [tmpComms insertString:@"\U0000e613 " atIndex:0];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = PBFont(@"iconfont", NHFontSubSize);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:[tmpComms copy] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(praise.mas_right);
        make.centerY.equalTo(praise.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    //举报
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = PBFont(@"iconfont", NHFontTitleSize);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:@"\U0000e606" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.centerY.equalTo(praise.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [contentView addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(NH_CONTENT_MARGIN));
    }];
    //全部评论
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
    CGFloat m_tmp_h = 40;
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontSubSize);
    label.textColor = color;
    label.text = @"全部评论";
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(contentView).offset(m_left_offset);
        make.height.equalTo(@(m_tmp_h));
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@1);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(@0);
        make.width.equalTo(@(PBSCREEN_WIDTH));
        make.bottom.equalTo(line.mas_bottom);
    }];
//    [contentView layoutSubviews];
    [contentView layoutIfNeeded];
    
    return contentView;
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_SHOW_COMMENT_STEP           =       10;
static const int NH_TIMELINE_SETION_HEIGHT      =       50;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = 1;
    }else if (section == 1){
        __rows = 1;
    }else if (section == 2){
        __rows = self.dataSource.count;
    }
    return __rows;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger __row_height = 0;
    if (section == 0) {
        __row_height = 0;
    }else if (section == 1){
        __row_height = 40;
    }
    return __row_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectView = nil;
    if (section == 0) {
        
    }else if (section == 1){
        //全部评论
        UIColor *color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
        CGFloat m_tmp_h = 40;
        CGRect bounds = CGRectMake(0, 0, PBSCREEN_WIDTH, m_tmp_h);
        sectView = [[UIView alloc] initWithFrame:bounds];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, m_tmp_h)];
        label.font = PBSysFont(NHFontSubSize);
        label.textColor = color;
        label.text = @"全部评论";
        [sectView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sectView);
            make.left.right.equalTo(sectView).offset(NH_BOUNDARY_MARGIN);
            make.height.equalTo(@(m_tmp_h));
        }];
        //line
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [sectView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            //strongify(self)
            make.top.equalTo(label.mas_bottom);
            make.left.right.equalTo(sectView);
            make.height.equalTo(@1);
        }];
    }
    
    return sectView;
}
//*/

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    /*
//    NSInteger __section = indexPath.section; NSInteger __rows = indexPath.row;
//    CGFloat estimate_h = 1;
//    if (__section == 0) {
//        estimate_h = 80;
//    }else if (__section == 1){
//        estimate_h = 80;
//    }else if (__section == 2){
//    
//    NHTimelineModel *info = [_dataSource objectAtIndex:__rows];
//    [self.dynamicCell updateForInfo:info];
//    CGSize size = [self.dynamicCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    estimate_h = size.height + 1;
//    }
//    return estimate_h;
//    //*/
//    /*
//    NSInteger __section = indexPath.section; NSInteger __rows = indexPath.row;
//    CGFloat estimate_h = 1;
//    if (__section == 0) {
//        estimate_h = 300;
//    }else if (__section == 1){
//        estimate_h = 80;
//    }else if (__section == 2){
//        NHTimelineModel *aModel = [self.dataSource objectAtIndex:__rows];
//        estimate_h = 300+100*aModel.disCount.intValue;
//    }
//    
//    return estimate_h;
//     //*/
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __section = indexPath.section; NSInteger __rows = indexPath.row;
    CGFloat estimate_h = 1;
    if (__section == 0) {
        [self.ringCell setupForDataSource:self.headerDic];
        CGSize size = [self.ringCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        estimate_h = size.height + 1;
    }else if (__section == 1){
        estimate_h = NH_TIMELINE_SETION_HEIGHT;
    }else if (__section == 2){
        
        NHTimelineModel *info = [_dataSource objectAtIndex:__rows];
        [self.timeLineCell updateForInfo:info];
        CGSize size = [self.timeLineCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        estimate_h = size.height + 1;
    }
    return estimate_h;
    //return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger __section__ = indexPath.section;
    NSInteger __row__ = indexPath.row;
    if (__section__ == 0) {
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
        
        
        NSDictionary *info = self.headerDic;
        [cell setupForDataSource:info];
        weakify(self)
        [cell handlePraiseEvent:^(NHInvestorRingCell * _Nonnull cl, BOOL praised) {
            
        }];
        [cell handleReportEvent:^(NHInvestorRingCell * _Nonnull cl) {
            //strongify(self)
            //[self reportTimeLine];
        }];
        [cell handleCommentEvent:^(NHInvestorRingCell * _Nonnull cl) {
            strongify(self)
            [self commentAction];
        }];
        [cell handleImageBrowseEvent:^(NHInvestorRingCell * _Nonnull cl, NSUInteger idx) {
            
        }];
        
        return cell;
    }else if (__section__ == 1){
        static NSString *identifier = @"emptyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //全部评论
        UIColor *color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
        UILabel *label = [[UILabel alloc] init];
        label.font = PBSysFont(NHFontSubSize);
        label.textColor = color;
        label.text = @"全部评论";
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.right.equalTo(cell.contentView).offset(NH_BOUNDARY_MARGIN);
        }];
        //line
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            //strongify(self)
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.left.right.equalTo(cell.contentView);
            make.height.equalTo(@1);
        }];
        
        return cell;
        
    }else if(__section__ == 2){
        static NSString *identifier = @"timeLineCell";
        NHTimeLineCell *cell = (NHTimeLineCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NHTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        //*
        NHTimelineModel *aModel = [self.dataSource objectAtIndex:__row__];
        [cell updateForInfo:aModel];
        [cell layoutIfNeeded];
        weakify(self)
        [cell handleShowMoreEvent:^( NHTimelineModel *ds) {
            strongify(self)
            self.view.userInteractionEnabled = false;
            NSUInteger dis = ds.disCount.integerValue;
            NSUInteger nums = ds.numsCount.integerValue;
            if (dis < nums) {
                if (dis + NH_SHOW_COMMENT_STEP > nums) {
                    dis = nums;
                }else{
                    dis += NH_SHOW_COMMENT_STEP;
                }
                
                NSUInteger __row = indexPath.row;
                NSLog(@"index:%zd--sect:%zd",__row,indexPath.section);
                NHTimelineModel *tmp_model = [self.dataSource objectAtIndex:__row];
                tmp_model.disCount = [NSNumber numberWithInteger:dis];
                [self performSelector:@selector(reloadRowsAtIndexPath:) withObject:indexPath afterDelay:2];
            }
            
            self.view.userInteractionEnabled = true;
        }];
        
        [cell handleTimeLineCommentTouchEvent:^(NSString *to, NHReplyType type) {
            strongify(self)
            NSString *info = PBFormat(@"%@%@",(type == NHReplyTypeReply?@"回复":@"评论"),to);
            NHCommenter *commenter = [[NHCommenter alloc] initWithPlaceHolder:info];
            weakify(self)
            [commenter handleCommenterEvent:^(NSString *info, BOOL cancel) {
                if (!cancel) {
                    strongify(self)
                    [self comment:to info:info type:type];
                }
            }];
            [commenter showInView:self.view];
        }];
        //*/
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)reloadRowsAtIndexPath:(NSIndexPath *)idxPath {
    [self.table beginUpdates];
    [self.table reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.table endUpdates];
}

- (void)comment:(NSString *)usr info:(NSString *)info type:(NHReplyType)type {
    //TODO:联网评论\回复
}

#pragma mark -- Header Actions

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.praiseBtn) {
        [self.praiseBtn setup];
    }
}

- (void)praiseAction:(NHEmitterButton *)btn {
    btn.selected = !btn.selected;
}

- (void)commentAction {
    //NSLog(@"%s",__func__);
    
}

- (void)reportAction {
    //NSLog(@"%s",__func__);
    
}

- (void)imageBrwoserAction:(UIButton *)btn {
    //NSLog(@"%s:\n__tag:%zd",__func__,btn.tag);
    
}

@end
