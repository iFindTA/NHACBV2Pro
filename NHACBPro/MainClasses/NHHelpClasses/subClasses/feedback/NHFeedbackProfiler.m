//
//  NHFeedbackProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFeedbackProfiler.h"

@interface NHFeedbackProfiler ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *info_tvw;

@end

@implementation NHFeedbackProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"kfeedback");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    weakify(self)
    UITextView *tvw = [[UITextView alloc] init];
    tvw.font = PBSysFont(NHFontTitleSize);
    tvw.backgroundColor = [UIColor lightGrayColor];
    tvw.keyboardType = UIKeyboardTypeNamePhonePad;
    tvw.delegate = self;
    [self.view addSubview:tvw];
    self.info_tvw = tvw;
    [tvw mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
//        make.top.equalTo(self.view).offset(NH_NAVIBAR_HEIGHT);
        make.top.and.left.and.right.equalTo(self.view);
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
