//
//  NHActivityProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/8.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHActivityProfiler.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NHActivityMaskLayer.h"
#import "NHActivityManualAlerter.h"

@interface NHActivityProfiler ()

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIView *container;

@end

static NSString *getRecordAlertKey() {
    return PBFormat(@"NH_MANUAL_RECORD_FLAG_%@",[NSBundle pb_buildVersion]);
}

@implementation NHActivityProfiler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.scroller) {
        [self renderBodyForInfo:nil];
        [self registerNotifiications];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // wether show record alert
    NSString *m_key = getRecordAlertKey();
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool showd = [userDefaults boolForKey:m_key];
    if (!showd) {
        [self showRecordMaskLayerAlert];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setActivityName:(NSString *)activityName {
    _activityName = activityName;
    self.title = activityName;
}

- (void)setActivityID:(NSNumber *)activityID {
    _activityID = activityID;
    //get data
}

- (void)renderBodyForInfo:(NSDictionary *)aDic {
    if (aDic == nil) {
//        return;
    }
    
    //TODO:此页面为共享页面：我的活动、好有的活动均可push此页面 所以需要判断自己是否能参加活动
    
    //审核期间分享、攻略图、app检测不进行
    BOOL inReviewing = true;
    if (!inReviewing) {
        UIBarButtonItem *spacer = [self barSpacer];
        UIBarButtonItem *shareBar = [self barWithIcon:@"\U0000e615" withTarget:self withSelector:@selector(shareAction)];
        self.navigationItem.rightBarButtonItems = @[spacer, shareBar];
    }
    
    UIColor *btnBgColor = [UIColor colorWithRed:127/255.f green:142/255.f blue:227/255.f alpha:1];
    CGFloat mBtnHeight = NH_CUSTOM_BTN_HEIGHT;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = btnBgColor;
    btn.titleLabel.font = PBSysFont(NHFontTitleSize);
    [btn setTitle:@"立即参与" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(joinActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    weakify(self)
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(mBtnHeight));
    }];
    
    //需要指定Scroller的bounds 不然无响应
    CGRect bounds = self.view.bounds;
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:bounds];
    //    scrollV.backgroundColor = color;
    [self.view addSubview:scrollV];
    self.scroller = scrollV;
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, mBtnHeight, 0));
    }];
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollV);
        make.width.equalTo(scrollV);
    }];
    self.container = container;
    
    //banner
    CGFloat m_banner_h = 90;
    NSString *icon_url = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
    UIImageView *img = [[UIImageView alloc] init];
    [container addSubview:img];
    [img sd_setImageWithURL:[NSURL URLWithString:icon_url]];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(container);
        make.height.equalTo(@(m_banner_h));
    }];
    
    
    CGFloat m_sep_line_h = 1;
    CGFloat m_sep_sect_h = 9;
    //分割线
    UIColor *color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_line_h));
    }];
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [container addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_sect_h));
    }];
    //活动奖励标题
    CGFloat m_left_offset = 16;
    color = [UIColor colorWithRed:227/255.f green:229/255.f blue:244/255.f alpha:1];
    CGFloat m_title_h = 35;
    CGFloat m_info_h = 45;
    UILabel *title_bg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, m_title_h)];
    title_bg.backgroundColor = color;
    [container addSubview:title_bg];
    [title_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_title_h));
    }];
    color = [UIColor colorWithRed:149/255.f green:156/255.f blue:195/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontSubSize);
    label.textColor = color;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"投资额(元)";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_title_h));
    }];
    label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontSubSize);
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"投资期限";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_title_h));
    }];
    label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontSubSize);
    label.textColor = color;
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"活动奖励";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_title_h));
    }];
    NSArray *tmpArrs = @[
  @{@"amout":@"1000",
    @"date":@"7天",
    @"jiangli":@"100金币"},
  @{@"amout":@"10000",
    @"date":@"30天",
    @"jiangli":@"1000金币"}];
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    UIColor *lineColor = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    __block UILabel *last_label = nil;
    [tmpArrs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *amout = [obj objectForKey:@"amout"];
        UILabel *tmp = [[UILabel alloc] init];
        tmp.font = PBSysFont(NHFontSubSize-3);
        tmp.textColor = color;
        tmp.textAlignment = NSTextAlignmentLeft;
        tmp.text = amout;
        [container addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_label == nil)?label.mas_bottom:last_label.mas_bottom);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
            make.height.equalTo(@(m_info_h));
        }];
        NSString *date = [obj objectForKey:@"date"];
        tmp = [[UILabel alloc] init];
        tmp.font = PBSysFont(NHFontSubSize-3);
        tmp.textColor = color;
        tmp.textAlignment = NSTextAlignmentCenter;
        tmp.text = date;
        [container addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_label == nil)?label.mas_bottom:last_label.mas_bottom);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
            make.height.equalTo(@(m_info_h));
        }];
        NSString *jiangli = [obj objectForKey:@"jiangli"];
        tmp = [[UILabel alloc] init];
        tmp.font = PBSysFont(NHFontSubSize-3);
        tmp.textColor = color;
        tmp.textAlignment = NSTextAlignmentRight;
        tmp.text = jiangli;
        [container addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_label == nil)?label.mas_bottom:last_label.mas_bottom);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
            make.height.equalTo(@(m_info_h));
        }];
        //line
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = lineColor;
        [container addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tmp.mas_bottom);
            make.left.right.equalTo(container);
            make.height.equalTo(@(m_sep_line_h));
        }];
        
        last_label = line;
    }];
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [container addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_sect_h));
    }];
    //活动规则标题
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
    m_title_h = 40;
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = PBSysFont(NHFontTitleSize);
    label.text = @"活动规则";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_title_h));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_line_h));
    }];
    CGFloat m_height = 25;
    NSArray *comInfos = @[@"1.点击立即参与，注册懒人投资",
                          @"2.登录懒人投资，投资其任意一款理财产品",
                          @"3.投资成功后，金币即发放到您的爱财帮账户",
                          @"另：懒人投资注册赠送10元红包，实名认证赠送26元红包，总计36元红包，可在投资时进行抵扣。到期后与投资本金一起返回您的余额。",
                          @"累计收益约47元＋5000爱财帮金币",
                          @"本活动仅限懒人投资新用户参加"];
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontTitleSize);
    __block UILabel *last_info = nil;
    [comInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *info = [[UILabel alloc] init];
        info.font = font;
        info.textColor = color;
        info.numberOfLines = 0;
        info.lineBreakMode = NSLineBreakByWordWrapping;
        info.text = obj;
        [info sizeToFit];
        [container addSubview:info];
        [info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_info == nil)?label.mas_bottom:last_info.mas_bottom).offset((last_info == nil)?m_height:m_sep_sect_h);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
        }];
        
        last_info = info;
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_info.mas_bottom).offset(m_height);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_line_h));
    }];
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [container addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_sect_h));
    }];
    //活动攻略
    UIView *last_v = sect;
    if (!inReviewing) {
        //活动攻略标题
        color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
        m_title_h = 40;
        label = [[UILabel alloc] init];
        label.textColor = color;
        label.font = PBSysFont(NHFontTitleSize);
        label.text = @"活动攻略";
        [container addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sect.mas_bottom);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
            make.height.equalTo(@(m_title_h));
        }];
        //分割线
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [container addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom);
            make.left.right.equalTo(container);
            make.height.equalTo(@(m_sep_line_h));
        }];
        NSArray *coms = @[
                          @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"},
                          @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"},
                          @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"}];
        CGFloat m_tmp_h = 216;
        CGFloat m_tmp_w = (PBSCREEN_WIDTH-m_left_offset*2)/3;
        UIScrollView *scroller = [self assembleImageScroller:coms forHeight:m_tmp_h optionWidth:m_tmp_w];
        [container addSubview:scroller];
        [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(m_left_offset);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
            make.height.equalTo(@(m_tmp_h));
        }];
        //分割线
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [container addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scroller.mas_bottom).offset(m_left_offset);
            make.left.right.equalTo(container);
            make.height.equalTo(@(m_sep_line_h));
        }];
        //分割区
        color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
        sect = [[UILabel alloc] init];
        sect.backgroundColor = color;
        [container addSubview:sect];
        [sect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.right.equalTo(container);
            make.height.equalTo(@(m_sep_sect_h));
        }];
        
        last_v = sect;
    }
    
    //重要说明标题
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:102/255.f alpha:1];
    m_title_h = 40;
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = PBSysFont(NHFontTitleSize);
    label.text = @"重要说明";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_v.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_title_h));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_line_h));
    }];
    comInfos = @[@"进行活动时，须遵循以下规则：",
                 @"1.使用同一设备进行操作；",
                 @"2.投资金额不进行累加计算，须一次性完成平台的投资金额、期限等要求，具体要求视活动流程而定；",
                 @"若由于用户自身原因导致奖励无法正常领取。爱财帮不进行奖励补发。若已按照流程完成活动，但未获得奖励，请联系爱财帮客服。"
                 ];
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    last_info = nil;
    [comInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *info = [[UILabel alloc] init];
        info.font = font;
        info.textColor = color;
        info.numberOfLines = 0;
        info.lineBreakMode = NSLineBreakByWordWrapping;
        info.text = obj;
        [info sizeToFit];
        [container addSubview:info];
        [info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_info == nil)?label.mas_bottom:last_info.mas_bottom).offset((last_info == nil)?m_height:m_sep_sect_h);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
        }];
        
        last_info = info;
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_info.mas_bottom).offset(m_height);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_sep_line_h));
    }];
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
    UIColor *bgColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:240/255.f alpha:1];
    NSString *title = @"活动的奖励均由平台及爱财帮提供，与设备生产商\nApple Inc.公司无关。特此声明！";
    label = [[UILabel alloc] init];
    label.backgroundColor = bgColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = PBSysFont(NHFontSubSize-3);
    label.textColor = color;
    label.numberOfLines = 0;
    label.text = title;
    [label sizeToFit];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_height*3));
    }];
    
    //tel it layout was ended
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_bottom);
    }];
    //记录投资按钮
    UIImage *imgs = [UIImage imageNamed:@"m_manual_record"];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:imgs forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(manualRecordBehavior) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view).offset(-mBtnHeight-16);
        make.width.height.equalTo(@(mBtnHeight));
    }];
}

- (UIScrollView *)assembleImageScroller:(NSArray *)info forHeight:(CGFloat)height optionWidth:(CGFloat)width{
    CGRect bounds = CGRectMake(0, 0, PBSCREEN_WIDTH, height);
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:bounds];
    //settings
    CGFloat cap = NH_BOUNDARY_OFFSET;
    NSUInteger counts = [info count];
    CGFloat mWidth = width>0?width:(PBSCREEN_WIDTH-cap*4)/3;
    for (int i = 0; i < counts; i++) {
        NSDictionary *aDic = [info objectAtIndex:i];
        NSString *url = [aDic objectForKey:@"url"];
        //TODO:test
        url = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
        bounds = CGRectMake((mWidth+cap)*i, 0, mWidth, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.tag = i;
        [btn addTarget:self action:@selector(imageScrollerTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:btn];
        [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    }
    
    CGFloat m_width = cap+(mWidth+cap)*counts;
    CGSize mContent = CGSizeMake(m_width, height);
    scroller.contentSize = mContent;
    
    return scroller;
}

- (void)imageScrollerTouchEvent:(UIButton *)btn {
    //TODO:image browser
}

- (void)shareAction {
    //TODO:share
}

- (void)manualRecordBehavior {
    [self showRecordMaskLayerInput];
}

- (void)showRecordMaskLayerAlert {
    NSString *m_key = getRecordAlertKey();
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool showd = [userDefaults boolForKey:m_key];
    if (!showd) {
        NHActivityManualAlerter *alertView = [[NHActivityManualAlerter alloc] init];
        [alertView handleActivityManualAlertEvent:^(BOOL success) {
            if (success) {
                [userDefaults setBool:true forKey:m_key];
                [userDefaults synchronize];
            }
        }];
        [alertView show];
    }
}

- (void)showRecordMaskLayerInput {
    NHActivityMaskLayer *maskLayer = [[NHActivityMaskLayer alloc] initWithType:NHMaskTypeInputMode];
    [maskLayer show];
}

#pragma mark -- register notification

- (void)registerNotifiications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)_applicationWillEnterForeground {
    weakify(self)
    PBMAINDelay(0.5, ^{
        strongify(self)
        [self showRecordMaskLayerInput];
    });
}

- (void)joinActivity {
    [SVProgressHUD showErrorWithStatus:@"error occured!"];
    BOOL inreviewing = false;
    if (inreviewing) {
        //call wap
    }else{
        //call js
        NSString *js = @"setTimeout(function () {window.location =\"https://itunes.apple.com/cn/app/ren-ren-mei-yan-zhi-bo.-hu/id316709252?mt=8\"; }, 25);window.location = \"weixin:// \";";
    }
}

@end
