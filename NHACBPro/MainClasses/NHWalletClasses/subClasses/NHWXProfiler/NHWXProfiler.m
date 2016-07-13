//
//  NHWXProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHWXProfiler.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface NHWXProfiler ()

@property (nonatomic, copy) NHBindWXEvent event;

@property (nonatomic, strong) UIButton *bind_btn;

@end

@implementation NHWXProfiler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"微信支付";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    UIBarButtonItem *helpBar = [self barWithIcon:@"\U0000e607" withTarget:self withSelector:@selector(problemForHelpAction)];
    self.navigationItem.rightBarButtonItems = @[spacer, helpBar];
    
    //TODO:注册监听 回到此页面刷新用户信息 后以block方式回到提现页面
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.bind_btn) {
        [self renderBody];
        [self registerApplicationNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerApplicationNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)_applicationWillEnterForeground {
    //TODO:刷新用户信息
    
    BOOL isBinded = false;
    if (isBinded) {
        if (_event) {
            _event(true, @"balabala");
        }
    }
}

- (void)renderBody {
    NSArray *tmp = @[
                     @"1,bababababablalalala",
                     @"2,bababababablalalala",
                     @"3,bababababablalalala",
                     @"4,bababababablalalala",
                     @"5,bababababablalalala",
                     @"6,bababababablalalala",
                     ];
    
    //分割区
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.view addSubview:sect];
    weakify(self)
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(NH_CONTENT_MARGIN));
    }];
    
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    //title
    UIFont *font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    NSString *title = @"微信支付需要绑定你的微信号到爱财帮的公众号，请按照以下流程操作：";
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = title;
    [label sizeToFit];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
    }];
    
    __block UILabel *last_lab = nil;
    [tmp enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strongify(self)
        UILabel *info = [[UILabel alloc] init];
        info.numberOfLines = 0;
        info.lineBreakMode = NSLineBreakByWordWrapping;
        info.font = font;
        info.textColor = color;
        info.text = obj;
        [self.view addSubview:info];
        weakify(self)
        [info mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo((last_lab == nil)?label.mas_bottom:last_lab.mas_bottom).offset((last_lab==nil)?NH_BOUNDARY_MARGIN:NH_CONTENT_MARGIN);
            make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
            make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        }];
        
        last_lab = info;
    }];
    
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(last_lab.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    btn.backgroundColor = color;
    btn.titleLabel.font = PBSysFont(NHFontTitleSize);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"马上去绑定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openWXProfileAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.bind_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
    }];
}

- (void)handleBindpublicWXEvent:(NHBindWXEvent)event {
    self.event = [event copy];
}

- (void)problemForHelpAction {
    //TODO:帮助 常见问题 网页
}

- (void)openWXProfileAction {
    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
//    req.bText = YES;
//    req.scene = WXSceneSession;
//    
//    [WXApi sendReq:req];
//    return;
    
//    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
//    req.profileType = WXBizProfileType_Normal;
//    req.username = @"gh_4975ada43584";
//    /*微信暂时不支持下字段的跳转*/
//    //req.extMsg = @"用户打开了爱财帮公众号!";
//    req.extMsg = @"";
//    [WXApi sendReq:req];
    
    NSString *urlScheme = @"weixin://?";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
}

@end
