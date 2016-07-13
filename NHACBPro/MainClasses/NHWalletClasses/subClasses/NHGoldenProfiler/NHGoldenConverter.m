//
//  NHGoldenConverter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHGoldenConverter.h"
#import "WTReTextField.h"

@interface NHGoldenConverter ()<UITextFieldDelegate>

@property (nonatomic, copy) NHConvertGoldenEvent event;
@property (nonatomic, strong) UITextField *amount_tfd;
@property (nonatomic, strong) UIButton *submit_btn;
@property (nonatomic, strong) UILabel *cash_lab;

@end

@implementation NHGoldenConverter

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"金币兑换";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderBody];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBody {
    
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    //bg
    CGFloat m_bg_h = 50;
    UILabel *bg = [[UILabel alloc] init];
    bg.backgroundColor = color;
    [self.view addSubview:bg];
    weakify(self)
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(m_bg_h);
    }];
    //title
    //TODO:test
    NSString *amount = @"1129";NSString *unit = @"枚";
    NSString *amountInfo = PBFormat(@"当前金币数量：%@%@",amount,unit);
    NSRange range = [amountInfo rangeOfString:amount];
    UIColor *rangeColor = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
    color = [UIColor colorWithRed:143/255.f green:145/255.f blue:149/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontSubSize);
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:color
                                 };
    NSMutableAttributedString *attsString = [[NSMutableAttributedString alloc] initWithString:amountInfo attributes:attributes];
    [attsString addAttribute:NSForegroundColorAttributeName value:rangeColor range:range];
    UILabel *title = [[UILabel alloc] init];
    title.font = font;
    title.textColor = color;
    title.attributedText = attsString;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.right.bottom.equalTo(bg);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        //make.height.equalTo(m_bg_h);
    }];
    
    //全部
    color = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:@"全部兑换" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(allGoldenOutterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title.mas_centerY);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(70, NH_CUSTOM_BTN_HEIGHT));
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
    //兑换数量
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    CGFloat m_pre_width = 80;
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"兑换数量";
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
    //unit
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"x 100枚";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.mas_bottom);
        make.right.equalTo(bg);
        make.size.equalTo(CGSizeMake(m_pre_width, m_bg_h));
    }];
    //输入
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"100金币＝1元";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeNumberPad;
    //tfd.pattern = @"^(0|[1-9][0-9]*)$";
    [self.view addSubview:tfd];
    self.amount_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(label.mas_left).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfd.mas_bottom);
        make.left.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    //amount
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UIColor *bgColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.backgroundColor = bgColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(line);
        make.height.equalTo(m_bg_h);
    }];
    label = [[UILabel alloc] init];
    label.backgroundColor = bgColor;
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"可兑换：0元";
    [self.view addSubview:label];
    self.cash_lab = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(m_bg_h);
    }];
    //btn
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
    [btn setTitle:@"兑现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(convertAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.submit_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
}

#pragma mark -- textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.submit_btn.enabled = newString.length > 0;
        [self updateCashOutter:newString];
        return true;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateCashOutter:newString];
    NSString *expression = @"^\\+?[1-9][0-9]*$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    BOOL match = (numberOfMatches != 0);
    self.submit_btn.enabled = (newString.length > 0)&&match;
    return match;
}

- (void)updateCashOutter:(NSString *)text {
    NSInteger amount = text.integerValue;
    NSString *info = PBFormat(@"可兑换：%zd元",amount);
    self.cash_lab.text = info;
}

- (void)handleConvertGoldenEvent:(NHConvertGoldenEvent)event {
    self.event = [event copy];
}

//全部兑换
- (void)allGoldenOutterAction {
    //TODO:test
    NSInteger tmp = 1129;
    NSUInteger max = tmp / 100;
    NSString *tmpInfo = PBFormat(@"%zd",max);
    self.amount_tfd.text = tmpInfo;
    [self updateCashOutter:tmpInfo];
    self.submit_btn.enabled = (tmpInfo.length > 0)&&(max>0);
}

- (void)convertAction {
    //TODO:test
    //TODO:test
    NSInteger tmp = 1129;
    NSUInteger max = tmp / 100;
    NSUInteger input = self.amount_tfd.text.integerValue;
    if (input > max) {
        [SVProgressHUD showErrorWithStatus:@"你的金币数量不够！"];
        return;
    }
    //联网兑换
    if (_event) {
        _event(10, true);
    }
}

@end
