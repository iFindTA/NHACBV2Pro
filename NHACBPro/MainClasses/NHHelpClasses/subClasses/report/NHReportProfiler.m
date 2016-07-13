//
//  NHReportProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHReportProfiler.h"
#import "NHLoginProfiler.h"
#import "NHPlatformPicker.h"

@interface NHReportProfiler ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *info_tvw;
@property (nonatomic, strong) UITextField *name_tfd;

@end

@implementation NHReportProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"kplatform");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    weakify(self)
    UITextField *tfd = [[UITextField alloc] init];
    tfd.placeholder = @"input a platform";
    tfd.delegate = self;
    tfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfd.borderStyle = UITextBorderStyleLine;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.name_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.top.equalTo(self.view).offset(NH_NAVIBAR_HEIGHT);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@(NH_CUSTOM_TFD_HEIGHT));
    }];
    UITextView *tvw = [[UITextView alloc] init];
    tvw.font = PBSysFont(NHFontTitleSize);
    tvw.backgroundColor = [UIColor lightGrayColor];
    tvw.keyboardType = UIKeyboardTypeNamePhonePad;
    tvw.delegate = self;
    [self.view addSubview:tvw];
    self.info_tvw = tvw;
    [tvw mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(tfd.mas_bottom).offset(NH_BOUNDARY_OFFSET);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@(PBSCREEN_WIDTH*0.5));
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:PBLocalized(@"ksubmit") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(tvw.mas_bottom).offset(NH_BOUNDARY_OFFSET);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_OFFSET);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_OFFSET);
        make.height.equalTo(@(NH_CUSTOM_BTN_HEIGHT));
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitAction {
    //TODO:login check
    BOOL logined = [[NHDBEngine share] logined];
    if (!logined) {
        
        DQAlertView *alert = [[DQAlertView alloc] initWithTitle:PBLocalized(@"kalert") message:@"此操作需要授权登录." cancelButtonTitle:PBLocalized(@"kcancel") otherButtonTitle:@"授权"];
        weakify(self)
        [alert actionWithBlocksCancelButtonHandler:^{
            
        } otherButtonHandler:^{
            strongify(self)
            [self pushLoginProfiler];
        }];
        [alert show];
        return;
    }
}

- (void)pushLoginProfiler {
    NHLoginProfiler *loginCenter = [[NHLoginProfiler alloc] init];
    loginCenter.aBackClass = [self class];
    [self.navigationController pushViewController:loginCenter animated:true];
}

#pragma mark -- UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSString *tmp = textField.text;
    NHPlatformPicker *platformer = [[NHPlatformPicker alloc] initWithDefaultPlatform:tmp];
    weakify(self);
    [platformer handlePlatformSelectedEvent:^(BOOL success, NSString *plat) {
        if (success) {
            strongify(self)
            self.name_tfd.text = plat;
            [self popUpLayer];
        }
    }];
    [self.navigationController pushViewController:platformer animated:true];

    return false;
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
