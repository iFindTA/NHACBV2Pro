//
//  NHBankCardAdder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBankCardAdder.h"
#import "WTReTextField.h"
#import "NHRealAuthor.h"

@interface NHBankCardAdder ()<UITextFieldDelegate>

@property (nonatomic, copy) NHBankCardAddEvent event;

@property (nonatomic, strong) WTReTextField *card_tfd;
@property (nonatomic, strong) UIButton *submit_btn;

@end

@implementation NHBankCardAdder

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"添加银行卡";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.card_tfd) {
        [self renderBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.card_tfd) {
        [self.card_tfd becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBankCardAddEvent:(NHBankCardAddEvent)event {
    self.event = [event copy];
}

- (void)renderBody {
    
    //TODO:未实名认证 时弹框提示
    weakify(self)
    BOOL isAuthority = false;
    if (!isAuthority) {
        DQAlertView *alert = [[DQAlertView alloc] initWithTitle:nil message:@"你尚未实名认证，实名认证后再绑定银行卡" cancelButtonTitle:@"暂不认证" otherButtonTitle:@"马上认证"];
        [alert actionWithBlocksCancelButtonHandler:^{
            strongify(self);
            [self popUpLayer];
        } otherButtonHandler:^{
            strongify(self);
            [self realNameAuthorityAction];
        }];
        [alert show];
        return;
    }
    
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    //bg
    CGFloat m_bg_h = 50;
    UILabel *bg = [[UILabel alloc] init];
    bg.backgroundColor = color;
    [self.view addSubview:bg];
    
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(m_bg_h);
    }];
    //title
    color = [UIColor colorWithRed:143/255.f green:145/255.f blue:149/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontSubSize);
    UILabel *title = [[UILabel alloc] init];
    title.font = font;
    title.textColor = color;
    title.text = @"请绑定持卡人本人的银行卡";
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.right.bottom.equalTo(bg);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        //make.height.equalTo(m_bg_h);
    }];
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.mas_bottom);
        make.left.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    
    //内容
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    CGFloat m_pre_width = 60;
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"持卡人";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(title.mas_left);
        make.size.equalTo(CGSizeMake(m_pre_width, m_bg_h));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [self.view addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_right);
        make.size.equalTo(CGSizeMake(1, m_bg_h*0.33));
    }];
    //人
    //TODO:test
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    NSString *mName = @"乐纯";
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = mName;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_bg_h);
    }];
    //横线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(bg).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    //卡号
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"卡号";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(title.mas_left);
        make.size.equalTo(CGSizeMake(m_pre_width, m_bg_h));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [self.view addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_right);
        make.size.equalTo(CGSizeMake(1, m_bg_h*0.33));
    }];
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    mName = @"输入银行卡号";
    WTReTextField *tfd = [[WTReTextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = mName;
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNumberPad;
    tfd.pattern = @"^(\\d{4}(?: )){5}\\d{4}$";
    [self.view addSubview:tfd];
    self.card_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    
    //横线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    //button
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
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.submit_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
}

#pragma mark -- UITextFiled delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *tmp = [NSMutableString stringWithString:textField.text];
    NSString *tmpStr = [tmp stringByReplacingCharactersInRange:range withString:string];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.submit_btn.enabled = tmpStr.length >= 16;
    
    return true;
}
#pragma mark -- 实名认证
- (void)realNameAuthorityAction {
    NHRealAuthor *nameAuthor = [[NHRealAuthor alloc] init];
    weakify(self)
    [nameAuthor handleUsrRealAuthorEvent:^(NSString *name, BOOL success) {
        if (success) {
            strongify(self)
            [self popUpLayer];
        }
    }];
    [self.navigationController pushViewController:nameAuthor animated:true];
}

- (void)submitAction {
    //TODO:联网提交
    
    //结果返回
    if (_event) {
        _event(nil, true);
    }
}

@end
