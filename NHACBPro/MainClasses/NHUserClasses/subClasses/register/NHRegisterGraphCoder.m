//
//  NHRegisterGraphCoder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHRegisterGraphCoder.h"
#import "NHRegisterSMSCoder.h"
#import "TTTAttributedLabel.h"
#import "NHGraphCoder.h"
#import "NHWebBrowser.h"
#import "WTReTextField.h"

@interface NHRegisterGraphCoder ()<UITextFieldDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, strong) WTReTextField *acc_tfd;
@property (nonatomic, strong) NHGraphCoder *graphCoder;
@property (nonatomic, strong) UIButton *next_btn;
@property (nonatomic, assign) NSUInteger m_code_count;
@property (nonatomic, assign) BOOL codeVerified;

@end

@implementation NHRegisterGraphCoder

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"注册（1/3）";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
    public.frame = CGRectMake(0, 0, 50, 31);
    public.titleLabel.font = PBSysFont(NHFontSubSize);
    [public setTitle:@"登录" forState:UIControlStateNormal];
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [public addTarget:self action:@selector(popUpLayer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *loginBar = [[UIBarButtonItem alloc] initWithCustomView:public];
    self.navigationItem.rightBarButtonItems = @[spacer,loginBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.graphCoder) {
        [self renderRegisterStep1Body];
    }else{
        [self refreshGraphCoder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderRegisterStep1Body {
    
    weakify(self)
    CGFloat mSect_H = NH_CUSTOM_TFD_HEIGHT + NH_BOUNDARY_OFFSET;
    
    // step alert
    UIFont *font = PBSysBoldFont(NHFontSubSize);
    UIColor *color = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
    UIColor *stepColor = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    UILabel *step1 = [[UILabel alloc] init];
    step1.font = font;
    step1.textAlignment = NSTextAlignmentCenter;
    step1.textColor = stepColor;
    step1.text = @"1.图形验证码";
    [self.view addSubview:step1];
    [step1 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self.view);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH/3.f, mSect_H));
    }];
    UILabel *step3 = [[UILabel alloc] init];
    step3.font = font;
    step3.textAlignment = NSTextAlignmentCenter;
    step3.textColor = color;
    step3.text = @"3.设置密码";
    [self.view addSubview:step3];
    [step3 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.right.equalTo(self.view);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH/3.f, mSect_H));
    }];
    UILabel *step2 = [[UILabel alloc] init];
    step2.font = font;
    step2.textAlignment = NSTextAlignmentCenter;
    step2.textColor = color;
    step2.text = @"2.短信验证码";
    [self.view addSubview:step2];
    [step2 mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view);
        make.left.equalTo(step1.mas_right);
        make.right.equalTo(step3.mas_left);
        make.height.equalTo(mSect_H);
    }];
    //arrows
    UILabel *arrow = [[UILabel alloc] init];
    arrow.font = PBFont(@"iconfont", NHFontSubSize);
    arrow.textColor = color;
    arrow.textAlignment = NSTextAlignmentCenter;
    arrow.text = @"\U0000e605";
    [self.view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(step1.mas_centerY);
        make.left.equalTo(step1.mas_centerX);
        make.right.equalTo(step2.mas_centerX);
        make.height.equalTo(mSect_H);
    }];
    arrow = [[UILabel alloc] init];
    arrow.font = PBFont(@"iconfont", NHFontSubSize);
    arrow.textColor = color;
    arrow.textAlignment = NSTextAlignmentCenter;
    arrow.text = @"\U0000e605";
    [self.view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(step1.mas_centerY);
        make.left.equalTo(step2.mas_centerX);
        make.right.equalTo(step3.mas_centerX);
        make.height.equalTo(mSect_H);
    }];
    
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.view addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(step1.mas_bottom);
        make.left.right.equalTo(self.view);
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
    font = PBFont(@"iconfont", NHFontTitleSize);
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
    //图形验证码
    NSString *url = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
    NHGraphCoder *coder = [NHGraphCoder codeWithURL:url];
    [self.view addSubview:coder];
    CGSize size = coder.bounds.size;
    self.graphCoder = coder;
    [coder handleGraphicCoderVerifyEvent:^(NHGraphCoder * _Nonnull cd, BOOL success) {
        strongify(self)
        if (success) {
            self.codeVerified = true;
            [self updateNextBtnStateWhileInputAccount:self.acc_tfd.text];
        }else{
            self.m_code_count++;
            if (self.m_code_count > 5) {
                self.m_code_count = 0;
                [cd resetStateForDetect];
                [SVProgressHUD showErrorWithStatus:@"有这么难么？^_^"];
            }
        }
    }];
    [coder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.centerX.equalTo(line.mas_centerX);
        make.size.equalTo(size);
    }];
    
    //sign in btn
    color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIColor *disColor = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
    UIImage *enableImg = [UIImage pb_imageWithColor:color];
    UIImage *disImg = [UIImage pb_imageWithColor:disColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //    btn.backgroundColor = color;
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
        make.top.equalTo(coder.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    //protocol
    CGRect bounds = CGRectMake(0, 0, PBSCREEN_WIDTH, NH_CUSTOM_LAB_HEIGHT);
    color = [UIColor colorWithRed:143/255.f green:145/255.f blue:149/255.f alpha:1];
    stepColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    NSString *ptotocol = @"《爱财帮用户注册协议》";
    NSString *text = PBFormat(@"点击下一步,即表示你已阅读并同意%@",ptotocol);
    __block NSRange linkRange = [text rangeOfString:ptotocol];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:stepColor range:linkRange];
    TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
    //attributeLabel.userInteractionEnabled = false;
    attributeLabel.font = PBSysFont(NHFontSubSize);
    attributeLabel.textColor = color;
    attributeLabel.textAlignment = NSTextAlignmentCenter;
    attributeLabel.delegate = self;
    attributeLabel.attributedText = attributeStr;
    attributeLabel.linkAttributes = @{
                                      NSLinkAttributeName:@(NSUnderlineStyleNone)
                                      };
    attributeLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:disColor};
    [attributeLabel addLinkToURL:[NSURL URLWithString:@"native://usrRegisterProtocol"] withRange:linkRange];
    [self.view addSubview:attributeLabel];
    [attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.right.equalTo(self.view);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
}

- (void)refreshGraphCoder {
    [self.graphCoder resetStateForDetect];
    self.codeVerified = false;
    [self updateNextBtnStateWhileInputAccount:self.acc_tfd.text];
}

#pragma mark -- UITextField --

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldString = textField.text;
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL accept = newString.length <= 11;
    [self updateNextBtnStateWhileInputAccount:accept?newString:oldString];
    return accept;
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
    BOOL acc_match = [self phoneNumMatch:acc] && self.codeVerified;
    if (acc_match) {
        //此处会少输入最后一个字符
        //[self.view endEditing:true];
    }
    self.next_btn.enabled = acc_match ;
}

#pragma mark -- TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"native://usrRegisterProtocol"]) {
        NHWebBrowser *webBrowser = [NHWebBrowser browser];
        webBrowser.showMoreAction = false;
        //TODO:协议
        [self.navigationController pushViewController:webBrowser animated:true];
        [webBrowser loadURL:[NSURL URLWithString:@"https://youtuker.com"]];
    }
}
//TODO:测试步骤
- (void)testNextStep {
    NHRegisterSMSCoder *smsCoder = [[NHRegisterSMSCoder alloc] init];
    smsCoder.account = @"130 2362 2337";
    [self.navigationController pushViewController:smsCoder animated:true];
}

- (void)nextStepAction {
    //TODO:判断下一步
    
    NSString *account = self.acc_tfd.text;
    NHRegisterSMSCoder *smsCoder = [[NHRegisterSMSCoder alloc] init];
    smsCoder.account = account;
    [self.navigationController pushViewController:smsCoder animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
