//
//  NHActivityMaskLayer.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/8.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHActivityMaskLayer.h"
#import "NHDatePicker.h"
#import "NHConditionPicker.h"

@interface NHActivityMaskLayer ()<UITextFieldDelegate>

@property (nonatomic, copy) NHRecordEvent event;
@property (nonatomic) BOOL statusBarHiddenInited, dismissing;
@property (nonatomic, strong, nullable) UIWindow *mainWin;
@property (nonatomic, assign) NHMaskType type;
@property (nonatomic, strong) UIView *contanier,*alertView,*inputView;
@property (nonatomic, strong) UITextField *mAmount_tfd;
@property (nonatomic, strong) UIButton *mDate_btn,*mWay_btn;

@end

@implementation NHActivityMaskLayer

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithType:(NHMaskType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        
    }
    return self;
}

- (void)loadView {
    
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    //hidden the stausBar
    //[[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    UIColor *bgColor = [[UIColor clearColor] colorWithAlphaComponent:0.25];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = bgColor;
}

- (void)viewDidLoad {
    //[super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderBody];
    [self registerKeyboardEvent];
}

- (void)registerKeyboardEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    [self resetContanierUpOffset];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignFirstResnponder];
    [self resetContanierCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    [self dismiss:true];
//    
//}

//- (UIWindow *)mainWin {
//    if (_mainWin == nil) {
//        UIColor *bgColor = [[UIColor clearColor] colorWithAlphaComponent:0.25];
//        bgColor = [UIColor whiteColor];
//        CGRect mainBounds = [UIScreen mainScreen].bounds;
//        _mainWin = [[UIWindow alloc] initWithFrame:mainBounds];
//        _mainWin.backgroundColor = bgColor;
//        _mainWin.opaque = true;
//        _mainWin.windowLevel = UIWindowLevelNormal+10;
//    }
//    return _mainWin;
//}

- (void)show {
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIWindow *window = [[UIWindow alloc] initWithFrame:bounds];
//    window.opaque = YES;
    UIWindowLevel level = UIWindowLevelNormal;
//    if (_statusBarHiddenInited) {
//        level = UIWindowLevelNormal+10.0f;
//    }
    window.windowLevel = level;
    __weak typeof(self) weakSelf = self;
    window.rootViewController = weakSelf;
    window.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.25];
    [window makeKeyAndVisible];
    self.mainWin = window;
    
}

- (void)dismiss:(BOOL)show {
    NSLog(@"dismiss");
    if (self.dismissing) {
        return;
    }
    self.dismissing = true;
    [_mainWin.rootViewController.view removeFromSuperview];
    [_mainWin.rootViewController removeFromParentViewController];
    //    _mainWin = nil;
    self.mainWin.hidden = true;
//    [self.mainWin removeFromSuperview];
//    [self.mainWin resignKeyWindow];
    self.mainWin = nil;
    //[[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationFade];
//    if (_event) {
//        _event(show);
//    }
}

- (void)renderBody {
    
    CGFloat m_left_offset = 50;
    CGFloat m_con_h = PBSCREEN_HEIGHT-(40*3+20)*2;
    m_con_h = MAX(m_con_h, 240);
    UIView *m_tmp = [[UIView alloc] init];
    m_tmp.layer.cornerRadius = NH_CORNER_RADIUS;
    m_tmp.layer.masksToBounds = true;
    m_tmp.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_tmp];
    weakify(self)
    self.contanier = m_tmp;
    [m_tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(PBSCREEN_WIDTH-m_left_offset*2));
        make.height.equalTo(@(m_con_h));
    }];
#pragma mark -- alert view
    //alertview
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = NH_CORNER_RADIUS;
    view.layer.masksToBounds = true;
    view.backgroundColor = [UIColor whiteColor];
    [m_tmp addSubview:view];
    self.alertView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(m_tmp);
    }];
    
    CGFloat m_img_scale = 2.f/7;
    CGFloat m_img_wh_scale = 240.f/202;
    CGFloat m_img_h = m_con_h*m_img_scale;
    CGFloat m_img_w = m_img_wh_scale*m_img_h;
    CGFloat m_img_top_offset = 20;
    UIImage *image = [UIImage imageNamed:@"recordalert"];
    UIImageView *imgV = [[UIImageView alloc] init];
//    imgV.backgroundColor = [UIColor redColor];
    imgV.image = image;
    [view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(@(m_img_top_offset));
        make.width.equalTo(@(m_img_w));
        make.height.equalTo(@(m_img_h));
    }];
    
    CGFloat m_btn_height = NH_CUSTOM_BTN_HEIGHT;
    CGFloat m_text_w = PBSCREEN_WIDTH-m_left_offset*2-m_img_top_offset*2;
    CGFloat m_text_h = m_con_h-m_img_top_offset*4-m_btn_height-m_img_h;
    NSString *text = @"由于该平台未与爱财帮进行数据对接，所以需要你在完成活动之后，手动记录你的投资记录。爱财帮会根据记录与平台进行结算，结算完成后，对应的活动奖励会发放到你的帐户中。记录虚假的投资数据将会被视为无效记录。";
    UITextView *textV = [[UITextView alloc] init];
//    textV.backgroundColor = [UIColor blueColor];
    textV.editable = false;
    textV.font = PBSysFont(NHFontTitleSize);
    textV.textColor = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    textV.text = text;
    textV.textContainerInset = UIEdgeInsetsMake(0, -NH_TEXT_PADDING*0.5, 0, -NH_TEXT_PADDING*1.5);
    [view addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(m_img_top_offset);
        make.centerX.equalTo(view);
        make.width.equalTo(@(m_text_w));
        make.height.equalTo(@(m_text_h));
    }];
    
    UIColor *bgColor = [UIColor colorWithRed:127/255.f green:142/255.f blue:227/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = PBSysBoldFont(NHFontTitleSize);
    if (self.type == NHMaskTypeInitAlert) {
        [btn setTitle:@"我知道了" forState:UIControlStateNormal];
        [btn setTitleColor:bgColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = NH_CORNER_RADIUS*5;
        btn.layer.masksToBounds = true;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = bgColor.CGColor;
        [btn addTarget:self action:@selector(gotitAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:@"返回记一笔" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = NH_CORNER_RADIUS*5;
        btn.layer.masksToBounds = true;
        btn.backgroundColor = bgColor;
        [btn addTarget:self action:@selector(back2RecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(view.mas_bottom).offset(-m_img_top_offset);
        make.width.equalTo(@(m_text_w));
        make.height.equalTo(@(m_btn_height));
    }];
    
#pragma mark -- input view
    if (self.type == NHMaskTypeInitAlert) {
        return;
    }
    //self.alertView.hidden = true;
    
    CGFloat m_margin = NH_BOUNDARY_OFFSET;
    CGFloat m_in_title_h = 25;
    CGFloat m_s_h = NH_CUSTOM_LAB_HEIGHT;
    
    UIView *inputV = [[UIView alloc] init];
    inputV.backgroundColor = [UIColor whiteColor];
    [m_tmp addSubview:inputV];
    self.inputView = inputV;
    [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(m_tmp);
    }];
    //close
    bgColor = [UIColor colorWithRed:185/255.f green:188/255.f blue:203/255.f alpha:1];
    UIImage *close_img = [UIImage pb_iconFont:nil withName:@"\U0000e603" withSize:m_s_h withColor:bgColor];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:close_img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [inputV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputV).offset(@(m_margin));
        make.right.equalTo(inputV).offset(-m_margin);
        make.width.height.equalTo(@(m_s_h));
    }];
    //title
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysBoldFont(NHFontTitleSize);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.text = @"记录你的活动";
    [inputV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom);
        make.left.right.equalTo(inputV);
        make.height.equalTo(@(m_in_title_h));
    }];
    //为什么记录
    color = [UIColor colorWithRed:147/255.f green:156/255.f blue:203/255.f alpha:1];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = PBFont(@"iconfont", NHFontSubSize);
    [btn setTitle:@"为什么记录\U0000e607" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back2AlertAction) forControlEvents:UIControlEventTouchUpInside];
    [inputV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inputV).offset(@(-m_in_title_h));
        make.left.right.equalTo(inputV);
        make.height.equalTo(@(m_s_h));
    }];
    //提交
    bgColor = [UIColor colorWithRed:127/255.f green:142/255.f blue:227/255.f alpha:1];
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.titleLabel.font = PBSysBoldFont(NHFontTitleSize);
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.backgroundColor = bgColor;
    submit.layer.cornerRadius = NH_CORNER_RADIUS;
    submit.layer.masksToBounds = true;
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [inputV addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_top).offset(@(-m_margin));
        make.left.equalTo(inputV).offset(@(m_margin*2));
        make.right.equalTo(-m_margin*2);
        make.height.equalTo(@(m_btn_height));
    }];
    
    //剩下的空间
    CGFloat m_remain_h = m_con_h-m_in_title_h-m_s_h - m_margin-m_btn_height-m_margin-m_margin-m_s_h-m_in_title_h-m_margin;
    CGFloat m_cap = m_margin;
    CGFloat m_input_h = (m_remain_h-m_cap*2)/3.f;
    if (m_input_h < m_s_h) {
        m_input_h = m_s_h;m_cap = (m_remain_h-m_input_h*3)/2.f;
    }
    //投资金额
    bgColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
    UIView *input1 = [[UIView alloc] init];
    input1.backgroundColor = bgColor;
    input1.layer.cornerRadius = NH_CORNER_RADIUS;
    input1.layer.masksToBounds = true;
    input1.layer.borderWidth = 1;
    input1.layer.borderColor = color.CGColor;
    [inputV addSubview:input1];
    [input1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(m_margin);
        make.left.equalTo(inputV).offset(@(m_margin*2));
        make.right.equalTo(-m_margin*2);
        make.height.equalTo(@(m_input_h));
    }];
    UIView *input2 = [[UIView alloc] init];
    input2.backgroundColor = bgColor;
    input2.layer.cornerRadius = NH_CORNER_RADIUS;
    input2.layer.masksToBounds = true;
    input2.layer.borderWidth = 1;
    input2.layer.borderColor = color.CGColor;
    [inputV addSubview:input2];
    [input2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input1.mas_bottom).offset(m_cap);
        make.left.equalTo(inputV).offset(@(m_margin*2));
        make.right.equalTo(-m_margin*2);
        make.height.equalTo(@(m_input_h));
    }];
    UIView *input3 = [[UIView alloc] init];
    input3.backgroundColor = bgColor;
    input3.layer.cornerRadius = NH_CORNER_RADIUS;
    input3.layer.masksToBounds = true;
    input3.layer.borderWidth = 1;
    input3.layer.borderColor = color.CGColor;
    [inputV addSubview:input3];
    [input3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(input2.mas_bottom).offset(m_cap);
        make.left.equalTo(inputV).offset(@(m_margin*2));
        make.right.equalTo(-m_margin*2);
        make.height.equalTo(@(m_input_h));
    }];
    //左边占位
    UIFont *font = PBSysFont(NHFontSubSize);
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = @"投资金额 |";
    [input1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(input1).insets(UIEdgeInsetsMake(0, m_margin, 0, 0));
    }];
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentRight;
    label.font = font;
    label.textColor = color;
    label.text = @"元";
    [input1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(input1).insets(UIEdgeInsetsMake(0, 0, 0, m_margin));
    }];
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = @"到期日期 |";
    [input2 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(input2).insets(UIEdgeInsetsMake(0, m_margin, 0, 0));
    }];
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = @"还款方式 |";
    [input3 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(input3).insets(UIEdgeInsetsMake(0, m_margin, 0, 0));
    }];
    //输入框
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
//    tfd.backgroundColor = [UIColor redColor];
    tfd.textColor = color;
    tfd.keyboardType = UIKeyboardTypeDecimalPad;
//    tfd.textAlignment = NSTextAlignmentRight;
    tfd.delegate = self;
    [input1 addSubview:tfd];
    self.mAmount_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(input1.mas_centerY);
        make.left.equalTo(input1).offset(@(font.pointSize*6));
        make.right.equalTo(input1).offset(@(-font.pointSize*2));
        make.height.greaterThanOrEqualTo(@(font.pointSize+4));
    }];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:self action:@selector(selectDateAction) forControlEvents:UIControlEventTouchUpInside];
    [input2 addSubview:btn];
    self.mDate_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(input2.mas_centerY);
        make.left.equalTo(input2).offset(@(font.pointSize*5));
        make.right.equalTo(input2);
        make.height.greaterThanOrEqualTo(@(font.pointSize+4));
    }];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:self action:@selector(selectWayAction) forControlEvents:UIControlEventTouchUpInside];
    [input3 addSubview:btn];
    self.mWay_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(input3.mas_centerY);
        make.left.equalTo(input3).offset(@(font.pointSize*5));
        make.right.equalTo(input3);
        make.height.greaterThanOrEqualTo(@(font.pointSize+4));
    }];
}

- (void)gotitAction {
    [self dismiss:true];
}

- (void)back2RecordAction {
    [self resignFirstResnponder];
    self.inputView.hidden = false;
    [UIView transitionWithView:self.contanier duration:PBANIMATE_DURATION*2 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.contanier bringSubviewToFront:self.inputView];
    } completion:^(BOOL finished) {
        self.alertView.hidden = true;
    }];
}

- (void)back2AlertAction {
    [self resignFirstResnponder];
    [self resignFirstResnponder];
    self.alertView.hidden = false;
    [UIView transitionWithView:self.contanier duration:PBANIMATE_DURATION*2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.contanier bringSubviewToFront:self.alertView];
    } completion:^(BOOL finished) {
        self.inputView.hidden = true;
    }];
}
//置为正中
- (void)resetContanierCenter {
    if (self.contanier) {
        
        [self.contanier mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY);
        }];
        [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}
//上偏移
- (void)resetContanierUpOffset {
    if (self.contanier) {
        
        [self.contanier mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY).offset(64-140);
        }];
        [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)closeAction {
    [self dismiss:true];
}

- (void)resignFirstResnponder {
    [self.view endEditing:true];
}

- (void)selectDateAction {
    [self resignFirstResnponder];
    [self resetContanierUpOffset];
    weakify(self)
    NHDatePicker *datePicker = [[NHDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker handlePickerSelectBlock:^(BOOL cancel, NSString *dateString) {
        strongify(self)
        if (!cancel) {
            [self.mDate_btn setTitle:dateString forState:UIControlStateNormal];
        }
        [self resetContanierCenter];
    }];
    [datePicker showInView:self.view];
}

- (void)selectWayAction {
    [self resignFirstResnponder];
    [self resetContanierUpOffset];
    NSArray *tmp = @[@"一次性还款",@"按月付息到期还本",@"等额本金",@"每日计息到期还本"];
    weakify(self)
    NHConditionPicker *picker = [[NHConditionPicker alloc] initWithFrame:CGRectZero];
    [picker handlePickerSelectBlock:^(BOOL cancel, NSString *info) {
        strongify(self)
        if (!cancel) {
            [self.mWay_btn setTitle:info forState:UIControlStateNormal];
        }
        [self resetContanierCenter];
    }];
    picker.dataSource = tmp;
    [picker showInView:self.view];
}

- (void)submitAction {
    
    CGFloat amount = [[self.mAmount_tfd text] floatValue];
    if (amount <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效投资金额！"];
        [self.mAmount_tfd becomeFirstResponder];
        return;
    }
    NSString *date = self.mDate_btn.titleLabel.text;
    if (PBIsEmpty(date)) {
        [SVProgressHUD showErrorWithStatus:@"请选择到期日期！"];
        [self selectDateAction];
        return;
    }
    NSString *way = self.mWay_btn.titleLabel.text;
    if (PBIsEmpty(way)) {
        [SVProgressHUD showErrorWithStatus:@"请选择还款方式！"];
        [self selectWayAction];
        return;
    }
    
    [self resignFirstResnponder];
    [self resetContanierCenter];
    
    //TODO:联网post记录
    self.contanier.hidden = true;
    [SVProgressHUD showWithStatus:@"请稍候..."];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu) {
        menu.menuVisible = false;
    }
    return false;
}

- (void)handleRecordEvent:(NHRecordEvent)event {
    _event = [event copy];
}

#pragma mark -- textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,2})?$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    return numberOfMatches != 0;
}

@end
