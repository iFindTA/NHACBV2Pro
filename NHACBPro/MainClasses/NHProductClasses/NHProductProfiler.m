//
//  NHProductProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHProductProfiler.h"
#import "NHActivityCell.h"
#import "TTTAttributedLabel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NHWhoInProfiler.h"
#import "NHInvestorRinger.h"
#import "NHReportProfiler.h"
#import "NHActivityProfiler.h"
#import "NHPhoto.h"
#import "NHPhotoBrowser.h"

static const int max_show_line_num          =       7;

@interface NHProductProfiler ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UILabel *platformIntro;
@property (nonatomic, strong) UIButton *foldBtn;

@end

static int caculateLines(NSString *info, UIFont *font, CGSize size){
    int charSize = (int)lroundf(font.pointSize);
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect bounds = [info boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    int rHeight = (int)lroundf(bounds.size.height);
    int lineCount = rHeight/charSize;
    return lineCount;
}

@implementation NHProductProfiler

- (void)dealloc {
    
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
    //TODO:test for render view
    if (!self.scroller) {
        [self renderBodyWithInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductName:(NSString *)productName {
    _productName = productName;
    self.title = productName;
}

- (void)setProductID:(NSNumber *)productID {
    _productID = productID;
    //get data
}

static const NSString * constStr = @"Easily create complex shapes with our state-of-the-art vector boolean operations and take advantage of our extensive layer styles. Sketch’s fully vector-based workflow makes it easy to create beautiful, high-quality artwork from start to finish.Easily create complex shapes with our state-of-the-art vector boolean operations and take advantage of our extensive layer styles. Sketch’s fully vector-based workflow makes it easy to create beautiful, high-quality artwork from start to finish.";

#pragma mark -- lazy render body

- (void)renderBodyWithInfo:(NSDictionary *)aDic {
    
    if (aDic == nil) {
        //return;
    }
    //需要指定Scroller的bounds 不然无响应
    weakify(self)
    UIColor *color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    CGRect bounds = self.view.bounds;
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:bounds];
//    scrollV.backgroundColor = color;
    [self.view addSubview:scrollV];
    self.scroller = scrollV;
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));;
    }];
    UILabel *bgView = [[UILabel alloc] initWithFrame:CGRectMake(0, -PBSCREEN_HEIGHT, PBSCREEN_WIDTH, PBSCREEN_HEIGHT)];
    bgView.backgroundColor = color;
    [scrollV insertSubview:bgView atIndex:0];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollV);
        make.width.equalTo(scrollV);
    }];
    self.container = container;
    
    CGFloat m_white_top_offset = 135;
    CGFloat m_white_height = 130;
    //blue bg
    UILabel *blueBg = [[UILabel alloc] init];
    blueBg.backgroundColor = color;
    [container addSubview:blueBg];
    [blueBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(container);
        make.height.equalTo(@(m_white_top_offset));
    }];
    //white bg
    
    UILabel *whiteBg = [[UILabel alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [container addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(m_white_top_offset));
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_white_height));
    }];
    
    CGFloat m_top_offset = 9;
    CGFloat m_top_height = 126;
    CGFloat m_real_height = m_top_height + m_white_height;
    CGFloat m_left_offset = 16;
    UIView *m_top = [[UIView alloc] init];
    m_top.layer.cornerRadius = NH_CORNER_RADIUS;
    m_top.layer.masksToBounds = true;
    m_top.backgroundColor = [UIColor whiteColor];
    [container addSubview:m_top];
    [m_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(m_top_offset));
        make.left.equalTo(@(m_left_offset));
        make.right.equalTo(container).offset(-m_left_offset);
        make.height.equalTo(@(m_real_height));
    }];
    
    //上部内容
    m_top_offset = 25;
    m_left_offset = 20;
    CGFloat m_icon_size = 43;
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.cornerRadius = NH_CORNER_RADIUS*2;
    icon.layer.masksToBounds = true;
    [m_top addSubview:icon];
    //TODO:test
    NSString *iconURL = [aDic objectForKey:@"icon"];
    iconURL = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
    [icon sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(m_top_offset));
        make.left.equalTo(@(m_left_offset));
        make.width.height.equalTo(@(m_icon_size));
    }];
    CGFloat m_offset = 12;
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    NSString *title = [aDic objectForKey:@"title"];
    title = @"杭州懒人网络科技有限公司";
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysBoldFont(NHFontTitleSize);
    label.textColor = color;
    label.text = title;
    [label sizeToFit];
    [m_top addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_top);
        make.left.equalTo(icon.mas_right).offset(m_offset);
        make.right.equalTo(m_top);
        //make.height.equalTo(@(NHFontTitleSize));
    }];
    //tags
    NSArray *tags = [aDic objectForKey:@"tags"];
    tags = @[@"国资背景",@"上市公司",@"专注车贷",@"证监会合作伙伴"];
    CGFloat m_width = PBSCREEN_WIDTH-16*2-25*2-43-m_offset;
    NHTagsLabel *tagLabel = [[NHTagsLabel alloc] initWithFrame:CGRectMake(0, 0, m_width, 25) withTags:tags];
    [container addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(icon.mas_right).offset(m_offset);
    }];
    
    //注册 年化
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    m_width += m_offset+m_icon_size;
    CGFloat m_scale = 0.5;
    title = @"平均年化：5.98%";
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = PBSysFont(NHFontSubSize);
    label.text = title;
    [m_top addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLabel.mas_bottom).offset(m_top_offset*2);
        make.left.equalTo(icon.mas_left);
        make.width.equalTo(m_width * m_scale);
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
    }];
    //注册资本
    title = @"注册资本：5000万";
    UILabel *capital = [[UILabel alloc] init];
    capital.textColor = color;
    capital.font = PBSysFont(NHFontSubSize);
    capital.text = title;
    [m_top addSubview:capital];
    [capital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(m_offset);
        make.left.equalTo(label.mas_left);
        make.width.equalTo(m_width * m_scale);
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
    }];
    //所在地区
    title = @"所在地区：浙江｜杭州";
    UILabel *zone = [[UILabel alloc] init];
    zone.textColor = color;
    zone.font = PBSysFont(NHFontSubSize);
    zone.numberOfLines = 0;
    zone.lineBreakMode = NSLineBreakByWordWrapping;
    zone.text = title;
    [m_top addSubview:zone];
    [zone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.left.equalTo(m_top.mas_centerX);
        make.width.equalTo(m_width * m_scale);
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT*2));
    }];
    //上线时间
    title = @"上线时间：2014－11-8";
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.textColor = color;
    lineLabel.font = PBSysFont(NHFontSubSize);
    lineLabel.numberOfLines = 0;
    lineLabel.lineBreakMode = NSLineBreakByWordWrapping;
    lineLabel.text = title;
    [m_top addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(capital.mas_top);
        make.left.equalTo(m_top.mas_centerX);
        make.width.equalTo(m_width * m_scale);
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT*2));
    }];
    
    //line height
    color = [UIColor colorWithRed:218/255.f green:219/255.f blue:220/255.f alpha:1];
    CGFloat m_line_height = 85;
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [m_top addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(m_top.mas_centerX);
        make.bottom.equalTo(m_top.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@(m_line_height));
    }];
    //谁投了
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIButton *whoIn = [[UIButton alloc] init];
    [whoIn setTitleColor:color forState:UIControlStateNormal];
    whoIn.titleLabel.font = PBSysBoldFont(NHFontTitleSize);
    [whoIn setTitle:@"谁投了" forState:UIControlStateNormal];
    [whoIn addTarget:self action:@selector(whoInvised) forControlEvents:UIControlEventTouchUpInside];
    [m_top addSubview:whoIn];
    [whoIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_left);
        make.top.mas_equalTo(label.mas_top).offset(m_top_offset);
        make.width.equalTo(@(m_width * m_scale));
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
    }];
    whoIn = [[UIButton alloc] init];
    [whoIn setTitleColor:color forState:UIControlStateNormal];
    whoIn.titleLabel.font = PBSysBoldFont(NHFontTitleSize);
    [whoIn setTitle:@"投友圈" forState:UIControlStateNormal];
    [whoIn addTarget:self action:@selector(friendTimeLine) forControlEvents:UIControlEventTouchUpInside];
    [m_top addSubview:whoIn];
    [whoIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_top).offset(m_top_offset);
        make.right.equalTo(m_top.mas_right).offset(-m_left_offset);
        make.width.equalTo(@(m_width * m_scale));
        make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
    }];
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    title = @"已有200人获得了奖励";
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = PBSysFont(NHFontSubSize);
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = title;
    [m_top addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whoIn.mas_bottom);
        make.left.equalTo(icon.mas_left);
        make.width.equalTo(@(m_width * m_scale));
        make.bottom.equalTo(m_top.mas_bottom);
    }];
    title = @"已有110人发表了话题";
    label = [[UILabel alloc] init];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = PBSysFont(NHFontSubSize);
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = title;
    [m_top addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whoIn.mas_bottom);
        make.right.equalTo(whoIn.mas_right);
        make.width.equalTo(@(m_width * m_scale));
        make.bottom.equalTo(m_top.mas_bottom);
    }];
    //分割线
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    m_top_offset = 9;
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_top.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_top_offset));
    }];
    //在推活动
    NSArray *activities = [aDic objectForKey:@"activity"];
    //TODO:test
    activities = @[
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
                   ];
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:104/255.f alpha:1];
    m_left_offset = 16;
    CGFloat m_title_height = 40;
    UILabel *act_title = [[UILabel alloc] init];
    act_title.backgroundColor = [UIColor whiteColor];
    act_title.textColor = color;
    act_title.font = PBSysFont(NHFontTitleSize);
    act_title.text = @"在推活动";
    [container addSubview:act_title];
    [act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container);
        make.height.equalTo(@(m_title_height));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(act_title.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //
    NSUInteger count = [activities count];
    __block UIControl *last_tmp = nil;CGFloat m_height = 110;
    NHActivityCell *cell = [[NHActivityCell alloc] init];
    color = [UIColor colorWithRed:250/255.f green:251/255.f blue:252/255.f alpha:1];
    [activities enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIControl *tmp = [cell assembleAccessableActivityInfo:obj lineHead:(idx == count-1)];
        tmp.tag = idx;
        strongify(self)
        [tmp addTarget:self action:@selector(activityTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_tmp == nil)?label.mas_bottom:last_tmp.mas_bottom);
            //make.left.equalTo(container).offset(m_left_offset);
            //make.right.equalTo(container).offset(-m_left_offset);
            make.left.right.equalTo(container);
            make.height.equalTo(@(m_height));
        }];
        
        last_tmp = tmp;
    }];
    //分割线
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_tmp.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_top_offset));
    }];
    //平台简介
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:104/255.f alpha:1];
    act_title = [[UILabel alloc] init];
    act_title.backgroundColor = [UIColor whiteColor];
    act_title.textColor = color;
    act_title.font = PBSysFont(NHFontTitleSize);
    act_title.text = @"平台简介";
    [container addSubview:act_title];
    [act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container);
        make.height.equalTo(@(m_title_height));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(act_title.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //平台内容
    
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    m_width = PBSCREEN_WIDTH-m_left_offset*2;
    CGSize size = CGSizeMake(m_width, MAXFLOAT);
    UIFont *font = PBSysFont(NHFontTitleSize);
    int lineNum = caculateLines(constStr, font, size);
    BOOL shouldFold = lineNum > max_show_line_num;
    UILabel *info = [[UILabel alloc] init];
    info.font = font;
    info.textColor = color;
    info.numberOfLines = shouldFold?max_show_line_num:lineNum;
    info.lineBreakMode = NSLineBreakByTruncatingTail;
    info.text = constStr;
    [info sizeToFit];
    [container addSubview:info];
    self.platformIntro = info;
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(container).offset(@(m_left_offset));
        make.right.equalTo(container).offset(@(-m_left_offset));
    }];
    UIView *last_v = info;
    if (shouldFold) {
        color = [UIColor colorWithRed:104/255.f green:119/255.f blue:203/255.f alpha:1];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"展开" forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        [btn addTarget:self action:@selector(foldEvent) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:btn];
        self.foldBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(info.mas_bottom);
            make.left.equalTo(info.mas_left);
            make.width.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
            make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
        }];
        last_v = btn;
    }
    //公司信息
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_v.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //分割线
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = color;
    [container addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_top_offset));
    }];
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:104/255.f alpha:1];
    act_title = [[UILabel alloc] init];
    act_title.backgroundColor = [UIColor whiteColor];
    act_title.textColor = color;
    act_title.font = PBSysFont(NHFontTitleSize);
    act_title.text = @"公司信息";
    [container addSubview:act_title];
    [act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container);
        make.height.equalTo(@(m_title_height));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(act_title.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //公司详细信息
    m_height = 25;
    NSArray *comInfos = @[@"企业名称：宁波懒人投资管理有限公司",
                          @"企业法人：陈斌",
                          @"企业类型：民营企业",
                          @"注册资本：5000万",
                          @"注册地址：宁波市金州区天潼路700号401室－B401",
                          @"开业日期：2014年11月18日",
                          @"登记机关：宁波市金州区市场监管管理局",
                          @"组织机构代码：30909852-8"];
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
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
            make.top.equalTo((last_info == nil)?label.mas_bottom:last_info.mas_bottom).offset(m_top_offset);
            make.left.equalTo(container).offset(m_left_offset);
            make.right.equalTo(container).offset(-m_left_offset);
        }];
        
        last_info = info;
    }];
    //资质
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_info.mas_bottom).offset(m_left_offset);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //分割线
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = color;
    [container addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_top_offset));
    }];
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:104/255.f alpha:1];
    act_title = [[UILabel alloc] init];
    act_title.backgroundColor = [UIColor whiteColor];
    act_title.textColor = color;
    act_title.font = PBSysFont(NHFontTitleSize);
    act_title.text = @"资质证明";
    [container addSubview:act_title];
    [act_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.equalTo(container).offset(m_left_offset);
        make.right.equalTo(container);
        make.height.equalTo(@(m_title_height));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(act_title.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //TODO:test
    NSArray *coms = @[
  @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"},
  @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"},
  @{@"url":@"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg"}];
    CGFloat mScroller_h = 70;
    UIScrollView *scroller = [self assembleImageScroller:coms forHeight:mScroller_h optionWidth:0];
    [container addSubview:scroller];
    [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(m_height);
        make.left.right.equalTo(container);
        make.height.equalTo(@(mScroller_h));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroller.mas_bottom).offset(m_height);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    //分割线
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = color;
    [container addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_top_offset));
    }];
    //平台热线
    UIControl *hotLine = [[UIControl alloc] init];
    [hotLine addTarget:self action:@selector(callHotCustomer) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:hotLine];
    [hotLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_title_height));
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotLine.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    title = @"400-655-6990";
    NSString *lineInfo = PBFormat(@"平台热线 %@",title);
    bounds = CGRectMake(m_left_offset, 0, PBSCREEN_WIDTH-m_left_offset*2, m_title_height);
    color = [UIColor colorWithRed:93/255.f green:94/255.f blue:104/255.f alpha:1];
    TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
    attributeLabel.userInteractionEnabled = false;
    attributeLabel.font = PBSysFont(NHFontSubSize+2);
    attributeLabel.textColor = color;
    [attributeLabel setText:lineInfo afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange colorRange = [[mutableAttributedString string] rangeOfString:title options:NSNumericSearch];
        
        CGColorRef color = [UIColor colorWithRed:98/255.f green:112/255.f blue:203/255.f alpha:1].CGColor;
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id _Nonnull)(color) range:colorRange];
        
        return mutableAttributedString;
    }];
    [hotLine addSubview:attributeLabel];
    //arrow
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
    lineLabel = [[UILabel alloc] init];
    lineLabel.font = PBFont(@"iconfont", NHFontSubSize);
    lineLabel.textColor = color;
    lineLabel.text = @"\U0000e605";
    [hotLine addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hotLine.mas_centerY);
        make.right.equalTo(hotLine.mas_right).offset(-NH_BOUNDARY_OFFSET);
        make.width.height.equalTo(@(NH_BOUNDARY_OFFSET));
    }];
    //举报
    bounds = CGRectMake(0, 0, PBSCREEN_WIDTH, m_title_height*3);
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
    UIColor *bgColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:240/255.f alpha:1];
    title = @"我要举报";
    lineInfo = PBFormat(@"本页面信息由杭州懒人网络科技有限公司提供\n如有虚假，欢迎举报 %@",title);
    attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
    attributeLabel.backgroundColor = bgColor;
    attributeLabel.font = PBSysFont(NHFontSubSize-3);
    attributeLabel.textAlignment = NSTextAlignmentCenter;
    attributeLabel.numberOfLines = 0;
    attributeLabel.textColor = color;
    attributeLabel.delegate = self;
    attributeLabel.lineSpacing = m_top_offset;
    [attributeLabel setText:lineInfo afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange colorRange = [[mutableAttributedString string] rangeOfString:title options:NSNumericSearch];
        
        CGColorRef color = [UIColor colorWithRed:98/255.f green:112/255.f blue:203/255.f alpha:1].CGColor;
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id _Nonnull)(color) range:colorRange];
        
        return mutableAttributedString;
    }];
    [container addSubview:attributeLabel];
    NSRange colorRange = [lineInfo rangeOfString:title options:NSNumericSearch];
    [attributeLabel addLinkToURL:[NSURL URLWithString:@"native://alert"] withRange:colorRange];
    [attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(container);
        make.height.equalTo(@(m_height*3));
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(attributeLabel.mas_bottom);
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
        bounds = CGRectMake(cap+(mWidth+cap)*i, 0, mWidth, height);
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
    //NHPhotoBrowser
}

- (void)activityTouchEvent:(UIControl *)ctr {
    NSLog(@"hd:%zd",ctr.tag);
    NHActivityProfiler *activitier = [[NHActivityProfiler alloc] init];
    activitier.activityName = @"活动详情";
    [self.navigationController pushViewController:activitier animated:true];
}

- (void)foldEvent {
    self.isOpen = !self.isOpen;
    NSString *title = self.isOpen?@"收起":@"展开";
    [self.foldBtn setTitle:title forState:UIControlStateNormal];
    self.platformIntro.numberOfLines = self.isOpen?0:max_show_line_num;
}

- (void)callHotCustomer {
    NSString *url = @"tel://400-600-9900";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    UIWebView *webCall = [[UIWebView alloc] init];
    [self.view addSubview:webCall];
    [webCall loadRequest:request];
}

- (void)whoInvised {
    NHWhoInProfiler *whoInner = [[NHWhoInProfiler alloc] init];
    [self.navigationController pushViewController:whoInner animated:true];
}

- (void)friendTimeLine {
    NHInvestorRinger *investorRinger = [[NHInvestorRinger alloc] init];
    [self.navigationController pushViewController:investorRinger animated:true];
}

#pragma mark -- TTT ---

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    //NSLog(@"link :%@",url.absoluteString);
    if ([url.absoluteString isEqualToString:@"native://alert"]) {
        NHReportProfiler *reporter = [[NHReportProfiler alloc] init];
        [self.navigationController pushViewController:reporter animated:true];
    }
}

@end
