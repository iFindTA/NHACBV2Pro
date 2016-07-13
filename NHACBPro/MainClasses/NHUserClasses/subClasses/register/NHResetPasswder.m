//
//  NHResetPasswder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHResetPasswder.h"

@interface NHResetPasswder ()<UITextFieldDelegate>

@property (nonatomic, assign) NHResetPWDType type;

@property (nonatomic, strong) UITextField *mold_pwd_tfd,*mnew_pwd_tfd,*mcon_pwd_tfd;

@property (nonatomic, strong) UIButton *next_btn;

@end

@implementation NHResetPasswder

- (void)dealloc {
    
}

- (id)initWithPwdType:(NHResetPWDType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = (NHResetPWDTypeModify == self.type)?@"修改密码":(NHResetPWDTypeInit == self.type)?@"注册（3/3）":@"设置密码";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.next_btn) {
        [self renderRegisterStep3Body];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderRegisterStep3Body {
    weakify(self)
    CGFloat mSect_H = NH_CUSTOM_TFD_HEIGHT + NH_BOUNDARY_OFFSET;
    
    UIView *last_v = nil;
    // step alert
    UIFont *font = PBSysBoldFont(NHFontSubSize);
    UIColor *color = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
    UIColor *stepColor = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    if (NHResetPWDTypeInit == self.type) {
        UILabel *step1 = [[UILabel alloc] init];
        step1.font = font;
        step1.textAlignment = NSTextAlignmentCenter;
        step1.textColor = color;
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
        step3.textColor = stepColor;
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
        
        last_v = step1;
    }
    
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.view addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo((last_v == nil)?self.view:last_v.mas_bottom);
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
    UIView *last_view = line;
    BOOL isModifyMode = (self.type == NHResetPWDTypeModify);
    if (isModifyMode) {
        UILabel *pre_lab = [[UILabel alloc] init];
        //pre_lab.backgroundColor = [UIColor redColor];
        pre_lab.font = font;
        pre_lab.textAlignment = NSTextAlignmentCenter;
        pre_lab.textColor = color;
        pre_lab.text = @"\U0000e619";
        [self.view addSubview:pre_lab];
        [pre_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
            make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
            make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
        }];
        //eye
        color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
        font = PBFont(@"iconfont", NHFontTitleSize);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = true;
        btn.titleLabel.font = font;
        [btn setTitle:@"\U0000e61a" forState:UIControlStateSelected];
        [btn setTitle:@"\U0000e61c" forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(oldPWDEyeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(pre_lab.mas_centerY);
            make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
            make.size.equalTo(CGSizeMake(NH_CUSTOM_BTN_HEIGHT, NH_CUSTOM_BTN_HEIGHT));
        }];
        color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
        UITextField *tfd = [[UITextField alloc] init];
        tfd.font = font;
        tfd.textColor = color;
        tfd.placeholder = @"旧密码";
        tfd.delegate = self;
        tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
        tfd.keyboardType = UIKeyboardTypeNamePhonePad;
        tfd.secureTextEntry = true;
        [self.view addSubview:tfd];
        self.mold_pwd_tfd = tfd;
        [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(pre_lab.mas_centerY);
            make.left.equalTo(pre_lab.mas_right).offset(NH_CONTENT_MARGIN);
            make.right.equalTo(btn.mas_left).offset(-NH_BOUNDARY_MARGIN);
            make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
        }];
        //分割线
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pre_lab.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
            make.left.right.equalTo(sect);
            make.height.equalTo(@1);
        }];
        //分割区
        color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
        UILabel *sect = [[UILabel alloc] init];
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
        
        last_view = line;
    }
    
    //新密码
    UILabel *pre_lab = [[UILabel alloc] init];
    //pre_lab.backgroundColor = [UIColor redColor];
    pre_lab.font = font;
    pre_lab.textAlignment = NSTextAlignmentCenter;
    pre_lab.textColor = color;
    pre_lab.text = @"\U0000e619";
    [self.view addSubview:pre_lab];
    [pre_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(last_view.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.equalTo(last_view).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
    }];
    //eye
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:@"\U0000e61a" forState:UIControlStateSelected];
    [btn setTitle:@"\U0000e61c" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(mnewPWDEyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_lab.mas_centerY);
        make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_BTN_HEIGHT, NH_CUSTOM_BTN_HEIGHT));
    }];
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = isModifyMode?@"新密码，6-16位":@"设置你的密码，6-16位";
    tfd.delegate = self;
    tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    tfd.secureTextEntry = true;
    [self.view addSubview:tfd];
    self.mnew_pwd_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
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
    //确认密码
    pre_lab = [[UILabel alloc] init];
    //pre_lab.backgroundColor = [UIColor redColor];
    pre_lab.font = font;
    pre_lab.textAlignment = NSTextAlignmentCenter;
    pre_lab.textColor = color;
    pre_lab.text = @"\U0000e619";
    [self.view addSubview:pre_lab];
    [pre_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
    }];
    //eye
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:@"\U0000e61a" forState:UIControlStateSelected];
    [btn setTitle:@"\U0000e61c" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(mconPWDEyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_lab.mas_centerY);
        make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_BTN_HEIGHT, NH_CUSTOM_BTN_HEIGHT));
    }];
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = isModifyMode?@"确认新密码":@"再次确认你的密码";
    tfd.delegate = self;
    tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    tfd.secureTextEntry = true;
    [self.view addSubview:tfd];
    self.mcon_pwd_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
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
    //next
    color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIColor *disColor = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
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
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitStepAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.next_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    
}

#pragma mark -- UITextField Delegate 

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.next_btn.enabled = false;
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldString = textField.text;
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    BOOL accept = newString.length <= NH_PASSWD_MAX_LEN;
    
    if (textField == self.mold_pwd_tfd) {
        self.next_btn.enabled = (self.mnew_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN&&self.mcon_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN)&&((accept?newString.length:oldString.length)>=NH_PASSWD_MIN_LEN);
    }else if (textField == self.mnew_pwd_tfd){
        self.next_btn.enabled = (((self.mold_pwd_tfd==nil)?1:self.mold_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN)&&self.mcon_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN)&&((accept?newString.length:oldString.length)>=NH_PASSWD_MIN_LEN);
    }else if (textField == self.mcon_pwd_tfd){
        self.next_btn.enabled = (((self.mold_pwd_tfd==nil)?1:self.mold_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN)&&self.mnew_pwd_tfd.text.length >= NH_PASSWD_MIN_LEN)&&((accept?newString.length:oldString.length)>=NH_PASSWD_MIN_LEN);
    }
    
    return accept;
}

- (void)oldPWDEyeAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.mold_pwd_tfd) {
        self.mold_pwd_tfd.secureTextEntry = !btn.selected;
    }
}
- (void)mnewPWDEyeAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.mnew_pwd_tfd.secureTextEntry = !btn.selected;
}
- (void)mconPWDEyeAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.mcon_pwd_tfd.secureTextEntry = !btn.selected;
}

- (void)submitStepAction {
    
    //TODO:联网提交
    if (self.aBackClass != nil) {
        NSArray *tmps = self.navigationController.viewControllers;
        __block NSMutableArray *__tmp = [NSMutableArray array];
        [tmps enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [__tmp addObject:obj];
            if ([obj isKindOfClass:self.aBackClass] ||
                [obj isMemberOfClass:self.aBackClass] ||
                obj.class == self.aBackClass) {
                *stop = true;
            }
        }];
        [self.navigationController setViewControllers:[__tmp copy] animated:true];
    }else{
        //默认返回上一页
        [self popUpLayer];
    }
}

@end
