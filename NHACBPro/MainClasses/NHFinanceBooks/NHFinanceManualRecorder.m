//
//  NHFinanceManualRecorder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/21.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFinanceManualRecorder.h"
#import "NHBaseScrollView.h"
#import "NHDatePicker.h"
#import "NHConditionPicker.h"
#import "NHPlatformPicker.h"

@interface NHFinanceManualRecorder ()<UITextFieldDelegate>

@property (nonatomic, assign) NHManualType type;
@property (nonatomic, strong) NSDictionary *recorderInfo;

@property (nonatomic, copy) NHManualRecordEvent event;
@property (nonatomic, strong) NHBaseScrollView *scroller;

@property (nonatomic, strong) UITextField *amount_tfd,*platform_tfd,*start_tfd,*end_tfd,*way_tfd;

@property (nonatomic, strong) UIButton *submit_btn;
@property (nonatomic, strong) NHConditionPicker *singlePicker;
@property (nonatomic, strong) NHDatePicker *datePicker;

@end

@implementation NHFinanceManualRecorder

- (id)initWithType:(NHManualType)type withInfo:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        self.type = type;
        if (aDict) {
            self.recorderInfo = [NSDictionary dictionaryWithDictionary:aDict];
        }
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"添加投资记录";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.scroller) {
        [self renderManualRecordBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleManualRecordEditOrAddEvent:(NHManualRecordEvent)event {
    self.event = [event copy];
}

- (void)renderManualRecordBody {
    weakify(self)
    //需要指定Scroller的bounds 不然无响应
    CGRect bounds = self.view.bounds;
    NHBaseScrollView *scroller = [[NHBaseScrollView alloc] initWithFrame:bounds];
    [scroller enableEndEditing:true];
//    scroller.backgroundColor = color;
    [self.view addSubview:scroller];
    self.scroller = scroller;
    [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroller);
        make.width.equalTo(scroller);
    }];
    
    CGFloat mSect_H = NH_CUSTOM_TFD_HEIGHT + NH_BOUNDARY_OFFSET;
    //分割区
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [container addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(container);
        make.height.equalTo(mSect_H);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(sect);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //提示
    color = [UIColor colorWithRed:143/255.f green:145/255.f blue:149/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontSubSize);
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.text = @"请完善你在平台的投资数据";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sect).insets(UIEdgeInsetsMake(0, NH_BOUNDARY_MARGIN, 0, 0));
    }];
    
    //投资金额
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    CGFloat m_pre_width = 80;
    UILabel *preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"投资金额";
    [container addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, mSect_H));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, mSect_H*0.33));
    }];
    
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"输入平台投资金额";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:tfd];
    self.amount_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //投资平台
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"投资平台";
    [container addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(container).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, mSect_H));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, mSect_H*0.33));
    }];
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"选择投资平台";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.platform_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //投资开始日期
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"开始日期";
    [container addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(container).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, mSect_H));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, mSect_H*0.33));
    }];
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"选择开始日期";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.start_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //投资结束日期
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"到期日期";
    [container addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(container).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, mSect_H));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, mSect_H*0.33));
    }];
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"选择到期日期";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.end_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //投资返现方式
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"还款方式";
    [container addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(container).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, mSect_H));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, mSect_H*0.33));
    }];
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"选择还款方式";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.way_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    
    //submit
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
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btn];
    self.submit_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line);
        make.right.equalTo(container).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
    }];
}


#pragma mark -- textField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.amount_tfd) {
        return true;
    }
    [self.view endEditing:true];
    if (textField == self.platform_tfd) {
        [self platformExchangeEvent];
    }else if (textField == self.start_tfd){
        [self startDateExchangeEvent];
    }else if (textField == self.end_tfd){
        [self endDateExchangeEvent];
    }else if (textField == self.way_tfd){
        [self paybackWayExchangeEvent];
    }
    return false;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amount_tfd) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,2})?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        [self checkAndUpdateSubmitState];
        return numberOfMatches != 0;
    }
    
    return false;
}

#pragma mark -- getter

- (NHConditionPicker *)singlePicker {
    if (!_singlePicker) {
        NHConditionPicker *picker = [[NHConditionPicker alloc] initWithFrame:CGRectZero];
        _singlePicker = picker;
    }
    return _singlePicker;
}

- (NHDatePicker *)datePicker {
    if (!_datePicker) {
        NHDatePicker *datePicker = [[NHDatePicker alloc] initWithFrame:CGRectZero];
        _datePicker = datePicker;
    }
    return _datePicker;
}

#pragma mark -- Picker Event 
- (void)platformExchangeEvent {
    NSString *tmp = self.platform_tfd.text;
    NHPlatformPicker *platformer = [[NHPlatformPicker alloc] initWithDefaultPlatform:tmp];
    weakify(self);
    [platformer handlePlatformSelectedEvent:^(BOOL success, NSString *plat) {
        if (success) {
            strongify(self)
            self.platform_tfd.text = plat;
            [self checkAndUpdateSubmitState];
            [self popUpLayer];
        }
    }];
    [self.navigationController pushViewController:platformer animated:true];
}

- (void)startDateExchangeEvent {
    weakify(self)
    [self.datePicker handlePickerSelectBlock:^(BOOL cancel, NSString *dateString) {
        if (!cancel) {
            strongify(self)
            [self.start_tfd setText:dateString];
            [self checkAndUpdateSubmitState];
        }
    }];
    [self.datePicker showInView:self.view];
}

- (void)endDateExchangeEvent {
    weakify(self)
    [self.datePicker handlePickerSelectBlock:^(BOOL cancel, NSString *dateString) {
        if (!cancel) {
            strongify(self)
            [self.end_tfd setText:dateString];
            [self checkAndUpdateSubmitState];
        }
    }];
    [self.datePicker showInView:self.view];
}

- (void)paybackWayExchangeEvent {
    NSArray *tmp = @[@"一次性还款",@"按月付息到期还本",@"等额本金",@"每日计息到期还本"];
    weakify(self)
    [self.singlePicker handlePickerSelectBlock:^(BOOL cancel, NSString *info) {
        if (!cancel) {
            strongify(self)
            [self.way_tfd setText:info];
            [self checkAndUpdateSubmitState];
        }
    }];
    self.singlePicker.dataSource = tmp;
    [self.singlePicker showInView:self.view];
}

- (void)checkAndUpdateSubmitState {
    //TODO:check state
    NSString *amount = self.amount_tfd.text;
    NSString *plat = self.platform_tfd.text;
    NSString *start = self.start_tfd.text;
    NSString *end = self.end_tfd.text;
    NSString *way = self.way_tfd.text;
    self.submit_btn.enabled = (amount.length > 0 &&
                               plat.length > 0 &&
                               start.length > 0 &&
                               end.length > 0 &&
                               way.length > 0);
    
}

- (void)submitAction {
    
    //TODO:联网提交
}

@end
