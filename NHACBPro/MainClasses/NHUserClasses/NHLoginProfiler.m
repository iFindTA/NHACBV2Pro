//
//  NHLoginProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHLoginProfiler.h"
#import "WTReTextField.h"
#import "NHFindPasswder.h"
#import "NHUserProfileCenter.h"
#import "NHRegisterGraphCoder.h"

@interface NHLoginProfiler ()<UITextFieldDelegate>

@property (nonatomic, strong) WTReTextField *acc_tfd;
@property (nonatomic, strong) UITextField *pwd_tfd;
@property (nonatomic, strong) UIButton *next_btn;

@end

@implementation NHLoginProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"klogin");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:@"\U0000e60a" withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.next_btn) {
        [self renderLoginBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderLoginBody {
    
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
    UILabel *pre_icon = [[UILabel alloc] init];
//    pre_lab.backgroundColor = [UIColor redColor];
    pre_icon.font = font;
    pre_icon.textColor = color;
    pre_icon.text = @"\U0000e618";
    [self.view addSubview:pre_icon];
    [pre_icon mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerY.equalTo(pre_icon.mas_centerY);
        make.left.equalTo(pre_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pre_icon.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
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
    //passwd pre
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    pre_icon = [[UILabel alloc] init];
    //pre_lab.backgroundColor = [UIColor redColor];
    pre_icon.font = font;
    pre_icon.textAlignment = NSTextAlignmentCenter;
    pre_icon.textColor = color;
    pre_icon.text = @"\U0000e619";
    [self.view addSubview:pre_icon];
    [pre_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_pre_width));
    }];
    //eye
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBFont(@"iconfont", NHFontTitleSize);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitle:@"\U0000e61a" forState:UIControlStateSelected];
    [btn setTitle:@"\U0000e61c" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(passwdEyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_icon.mas_centerY);
        make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_BTN_HEIGHT, NH_CUSTOM_BTN_HEIGHT));
    }];
    //passwd
    UITextField *pwd_tfd = [[UITextField alloc] init];
    pwd_tfd.secureTextEntry = true;
    pwd_tfd.placeholder = PBFormat(@"输入%d-%d位密码",NH_PASSWD_MIN_LEN,NH_PASSWD_MAX_LEN);
    pwd_tfd.delegate = self;
    pwd_tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd_tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    pwd_tfd.secureTextEntry = true;
    [self.view addSubview:pwd_tfd];
    self.pwd_tfd = pwd_tfd;
    [pwd_tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pre_icon.mas_centerY);
        make.left.equalTo(pre_icon.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(btn.mas_left).offset(-NH_CONTENT_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pre_icon.mas_bottom).offset((mSect_H-NH_CUSTOM_LAB_HEIGHT)*0.5);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    
    //sign in btn
    color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIColor *disColor = [UIColor colorWithRed:181/255.f green:190/255.f blue:240/255.f alpha:1];
    UIImage *enableImg = [UIImage pb_imageWithColor:color];
    UIImage *disImg = [UIImage pb_imageWithColor:disColor];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    //    btn.backgroundColor = color;
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    [btn setBackgroundImage:enableImg forState:UIControlStateNormal];
    [btn setBackgroundImage:disImg forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(signinAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.next_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    //forget passwd
    NSString *title = @"忘记密码？";
    font = PBSysFont(NHFontSubSize);
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize size = [title sizeWithAttributes:attributes];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(findPasswd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.next_btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT*0.5));
        make.width.equalTo(@(size.width+NH_BOUNDARY_OFFSET));
    }];
    //sign up
    title = @"注册";
    size = [title sizeWithAttributes:attributes];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:font];
    //    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.next_btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT*0.5));
        make.width.equalTo(@(size.width+NH_BOUNDARY_OFFSET));
    }];
}

- (void)passwdEyeAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.pwd_tfd.secureTextEntry = !btn.selected;
}

#pragma mark -- UITextField --

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.acc_tfd) {
        [self updateSignBtnStateWhileInputAccount:nil];
    }else if (textField == self.pwd_tfd){
        [self updateSignBtnStateWhileInputAccount:nil];
    }
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.acc_tfd) {
        
        NSString *oldString = textField.text;
        NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL accept = newString.length <= 11;
        [self updateSignBtnStateWhileInputAccount:accept?newString:oldString];
        return accept;
        
        /*
         //TODO:此处为TextField不使用Regex作为输入限制时的判断
         //若使用Regex作为pattenstring做限制 则此处仅仅限制长度即可
        if (range.length == 1 && string.length == 0) {
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateSignBtnStateWhileInputAccount:newString];
            return true;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^\\+?[1-9][0-9]*$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        BOOL match = (numberOfMatches != 0) && (newString.length <= 11);
        if (match) {
            [self updateSignBtnStateWhileInputAccount:newString];
        }
        return match ;
        //*/
    }else if (textField == self.pwd_tfd){
        if (range.length == 1 && string.length == 0) {
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateSignBtnStateWhileInputPasswd:newString];
            return true;
        }
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = NH_PASSWD_REGEXP;
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        BOOL match = (numberOfMatches != 0) && (newString.length <= NH_PASSWD_MAX_LEN);
        if (match) {
            [self updateSignBtnStateWhileInputPasswd:newString];
        }
        return match ;
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

- (void)updateSignBtnStateWhileInputAccount:(NSString *)acc {
    if (!acc) {
        self.next_btn.enabled = false;
        return;
    }
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwd = self.pwd_tfd.text;
    BOOL pwd_match = (pwd.length>=NH_PASSWD_MIN_LEN&&pwd.length<=NH_PASSWD_MAX_LEN);
    BOOL acc_match = [self phoneNumMatch:acc];
    self.next_btn.enabled = pwd_match && acc_match;
}

- (void)updateSignBtnStateWhileInputPasswd:(NSString *)pwd {
    if (!pwd) {
        self.next_btn.enabled = false;
        return;
    }
    NSString *acc = self.acc_tfd.text;
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL pwd_match = (pwd.length>=NH_PASSWD_MIN_LEN&&pwd.length<=NH_PASSWD_MAX_LEN);
    BOOL acc_match = [self phoneNumMatch:acc];
    self.next_btn.enabled = pwd_match && acc_match;
}

- (void)findPasswd {
    NHFindPasswder *loginPwdCoder = [[NHFindPasswder alloc] init];
    [self.navigationController pushViewController:loginPwdCoder animated:true];
}

- (void)registerAction {
    NHRegisterGraphCoder *graphCoder = [[NHRegisterGraphCoder alloc] init];
    [self.navigationController pushViewController:graphCoder animated:true];
}

- (void)signinAction {
    NSString *pwd = self.pwd_tfd.text;
    NSString *acc = self.acc_tfd.text;
    //TODO:登录
    
    //刷新当前登录用户数据
    
    //本地刷新
    NSUserDefaults *mDefaults = [NSUserDefaults standardUserDefaults];
    [mDefaults setBool:false forKey:NH_USR_AUTO_LOGOUT_KEY];
    [mDefaults synchronize];
    
    //测试跳转
    self.aReplaceClass = NSClassFromString(@"NHUserProfileCenter");
    [self autoPopWhenDoneAuthorized];
}

- (void)autoPopWhenDoneAuthorized {
    if (self.aReplaceClass != nil) {
        NSArray *tmps = self.navigationController.viewControllers;
        __block NSMutableArray *__tmp = [NSMutableArray array];
        [tmps enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[self class]] ||
                [obj isMemberOfClass:[self class]] ||
                obj.class == self.class) {
                *stop = true;
            }else{
                [__tmp addObject:obj];
            }
        }];
        UIViewController *m_instance = [[self.aReplaceClass alloc] init];
        if (m_instance != nil) {
            [__tmp addObject:m_instance];
            [self.navigationController setViewControllers:[__tmp copy] animated:true];
        }
    }else if (self.aBackClass != nil) {
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
