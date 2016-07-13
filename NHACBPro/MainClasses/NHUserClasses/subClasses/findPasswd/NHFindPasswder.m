//
//  NHFindPasswder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFindPasswder.h"
#import "NHResetPasswder.h"
#import "WTReTextField.h"

@interface NHFindPasswder ()<UITextFieldDelegate>

/**
 *  @brief 页面剩余读秒数 防止push再pop反复刷短信接口
 */
@property (nonatomic, assign) NSUInteger mRemaindCount,mCurIdx;

@property (nonatomic, strong) WTReTextField *acc_tfd;
@property (nonatomic, strong) UITextField *code_tfd;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *code_btn,*next_btn;

@end

@implementation NHFindPasswder

- (void)dealloc {
    if (_timer != nil) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"找回密码";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.next_btn) {
        [self renderFoundPasswdBody];
    }else{
        if (self.mRemaindCount > 10) {
            self.code_btn.enabled = false;
            [self launchTimer];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self invalidTimer];
    self.mRemaindCount = self.mCurIdx;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderFoundPasswdBody {
    weakify(self)
    CGFloat mSect_H = NH_CUSTOM_TFD_HEIGHT + NH_BOUNDARY_OFFSET;
    //分割区
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.view addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(NH_CONTENT_MARGIN);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    //占位符
    CGFloat m_pre_width = NH_CUSTOM_LAB_HEIGHT;
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    UIFont *font = PBFont(@"iconfont", NHFontTitleSize);
    UILabel *pre_lab = [[UILabel alloc] init];
    //pre_lab.backgroundColor = [UIColor redColor];
    pre_lab.font = font;
    pre_lab.textAlignment = NSTextAlignmentCenter;
    pre_lab.textColor = color;
    pre_lab.text = @"\U0000e618";
    [self.view addSubview:pre_lab];
    [pre_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
    }];
    //account
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    WTReTextField *tfd = [[WTReTextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"输入手机号码";
    tfd.delegate = self;
    tfd.pattern = NH_PHONE_REGEXP;
    tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfd.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:tfd];
    self.acc_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(pre_lab.mas_centerY);
        make.left.equalTo(pre_lab.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pre_lab.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.view addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(NH_CONTENT_MARGIN);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    //占位符
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    pre_lab = [[UILabel alloc] init];
    //pre_lab.backgroundColor = [UIColor redColor];
    pre_lab.font = font;
    pre_lab.textAlignment = NSTextAlignmentCenter;
    pre_lab.textColor = color;
    pre_lab.text = @"\U0000e61b";
    [self.view addSubview:pre_lab];
    [pre_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
    }];
    
    CGFloat m_code_width = 85;
    //sms code
    color = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    UIColor *disColor = [UIColor colorWithRed:118/255.f green:120/255.f blue:129/255.f alpha:1];
    UIImage *img = [UIImage pb_imageWithColor:[UIColor whiteColor]];
    img = [img pb_scaleToSize:CGSizeMake(m_code_width, NH_CUSTOM_BTN_HEIGHT) keepAspect:false];
    UIImage *disimg = [img pb_roundCornerWithRadius:NH_CORNER_RADIUS withBorderWidth:1 withBorderColor:disColor];
    img = [img pb_roundCornerWithRadius:NH_CORNER_RADIUS withBorderWidth:1 withBorderColor:color];
    font = PBSysFont(NHFontTitleSize);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:disColor forState:UIControlStateDisabled];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:disimg forState:UIControlStateDisabled];
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshSMSCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.code_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_lab.mas_centerY);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_code_width, NH_CUSTOM_BTN_HEIGHT-NH_BOUNDARY_OFFSET));
    }];
    // input
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UITextField *code_tfd = [[UITextField alloc] init];
    code_tfd.font = font;
    code_tfd.textColor = color;
    code_tfd.placeholder = @"输入短信验证码";
    code_tfd.delegate = self;
    code_tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    code_tfd.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:code_tfd];
    self.code_tfd = code_tfd;
    [code_tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_lab.mas_centerY);
        make.left.equalTo(pre_lab.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(btn.mas_left).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pre_lab.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    // next step btn
    color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    disColor = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
    UIImage *enableImg = [UIImage pb_imageWithColor:color];
    UIImage *disImg = [UIImage pb_imageWithColor:disColor];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    [btn setBackgroundImage:enableImg forState:UIControlStateNormal];
    [btn setBackgroundImage:disImg forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.next_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
}

#pragma mark -- UITextField Delegate --

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.next_btn.enabled = false;
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.acc_tfd) {
        NSString *oldString = textField.text;
        NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL accept = newString.length <= 11;
        [self updateNextBtnStateWhileInputAccount:accept?newString:oldString];
        return accept;
    }else if (textField == self.code_tfd){
        NSString *oldString = textField.text;
        NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
        BOOL accept = newString.length <= 6;
        [self updateNextBtnStateWhileInputCode:accept?newString:oldString];
        
        return accept;
    }
    return true;
}

- (BOOL)phoneNumMatch:(NSString *)acc {
    NSString *expression = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:acc options:0 range:NSMakeRange(0, [acc length])];
    return numberOfMatches != 0;
}

- (void)updateNextBtnStateWhileInputAccount:(NSString *)acc {
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *code = self.code_tfd.text;
    BOOL acc_match = [self phoneNumMatch:acc] && (code.length > 3);
    if (acc_match) {
        //此处会少输入最后一个字符
        //[self.view endEditing:true];
    }
    self.next_btn.enabled = acc_match ;
}

- (void)updateNextBtnStateWhileInputCode:(NSString *)code {
    NSString *acc = self.acc_tfd.text;
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL acc_match = [self phoneNumMatch:acc] && (code.length > 3);
    if (acc_match) {
        //此处会少输入最后一个字符
        //[self.view endEditing:true];
    }
    self.next_btn.enabled = acc_match ;
}

#pragma mark -- timer

- (void)invalidTimer {
    if (_timer != nil) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)launchTimer {
    [self invalidTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredAction) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)timerFiredAction {
    
    self.mCurIdx --;
    if (self.mCurIdx <= 0) {
        self.code_btn.enabled = true;
        [self.code_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    [self updateCodeTitle];
}

- (void)updateCodeTitle {
    //    //灰化send 按钮
    //    self.code_btn.enabled = false;
    NSString *info = PBFormat(@"%zd \"",self.mCurIdx);
    [self.code_btn setTitle:info forState:UIControlStateDisabled];
}

- (void)refreshSMSCodeAction {
    
    //TODO:联网发送短信验证码
    
    //灰化send 按钮
    self.code_btn.enabled = false;
    
    //开始倒计时
    self.mCurIdx = NH_DESC_COUNTS-1;
    NSString *info = PBFormat(@"%zd \"",self.mCurIdx);
    [self.code_btn setTitle:info forState:UIControlStateDisabled];
    
    //计时开始
    [self launchTimer];
}

- (void)nextStepAction {
    
    //TODO:判断条件
    //联网判断
    
    NHResetPasswder *pwder = [[NHResetPasswder alloc] initWithPwdType:NHResetPWDTypeFind];
    pwder.aBackClass = NSClassFromString(@"NHLoginProdiler");
    [self.navigationController pushViewController:pwder animated:true];
}

@end
