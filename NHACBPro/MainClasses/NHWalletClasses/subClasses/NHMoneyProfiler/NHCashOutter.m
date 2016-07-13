//
//  NHCashOutter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHCashOutter.h"
#import "NHBankCarder.h"
#import "NHBaseScrollView.h"
#import "NHWXProfiler.h"

//最少体现金额
static const int NH_CASH_MIN_OUTTER             =       50;

@interface NHCashOutter ()<UITextFieldDelegate>

@property (nonatomic, copy) NHCashOutterEvent event;

@property (nonatomic, strong) NHBaseScrollView *scroller;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITextField *cash_tfd;
@property (nonatomic, strong) UIButton *submit_btn,*bank_btn,*switch_btn;
@property (nonatomic, strong) UIImageView *bank_icon_img;
@property (nonatomic, strong) UILabel *outterFlag;

/**
 *  @brief 银行卡信息
 */
@property (nonatomic, strong) NSDictionary *mCardInfo;

@end

@implementation NHCashOutter

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"提现";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.cash_tfd) {
        [self renderBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBody {
    
    //需要指定Scroller的bounds 不然无响应
    CGRect bounds = self.view.bounds;
    NHBaseScrollView *scrollV = [[NHBaseScrollView alloc] initWithFrame:bounds];
    [scrollV enableEndEditing:true];
    //    scrollV.backgroundColor = color;
    [self.view addSubview:scrollV];
    self.scroller = scrollV;
    weakify(self)
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollV);
        make.width.equalTo(scrollV);
    }];
    self.container = container;
    
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    //bg
    CGFloat m_bg_h = 50;
    UILabel *bg = [[UILabel alloc] init];
    bg.backgroundColor = color;
    [container addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(container);
        make.height.equalTo(m_bg_h);
    }];
    //title
    //TODO:test
    NSString *amount = @"50.29";NSString *unit = @"元";
    NSString *amountInfo = PBFormat(@"可提现金额：%@%@",amount,unit);
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
    [container addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(bg);
        make.left.equalTo(container).offset(NH_BOUNDARY_MARGIN);
        //make.height.equalTo(m_bg_h);
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.mas_bottom);
        make.left.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    //金额
    font = PBSysFont(NHFontTitleSize);
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    CGFloat m_pre_width = 50;
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"金额";
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(title.mas_left);
        make.size.equalTo(CGSizeMake(m_pre_width, m_bg_h));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [container addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_right);
        make.size.equalTo(CGSizeMake(1, m_bg_h*0.33));
    }];
    //全部
    color = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    [btn setTitle:@"全部提现" forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(allCashOutterAction) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(container).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(70, NH_CUSTOM_BTN_HEIGHT));
    }];
    
    //输入
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"输入提现金额";
    tfd.delegate = self;
    tfd.keyboardType = UIKeyboardTypeDecimalPad;
    //tfd.pattern = @"^(0|[1-9][0-9]*)$";
    [self.view addSubview:tfd];
    self.cash_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(btn.mas_left).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(bg);
        make.height.equalTo(@1);
    }];
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [container addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(line);
        make.height.equalTo(NH_CONTENT_MARGIN);
    }];
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sect.mas_bottom);
        make.left.right.equalTo(sect);
        make.height.equalTo(@1);
    }];
    //icon
    UIImageView *imgv = [[UIImageView alloc] init];
//    imgv.backgroundColor = [UIColor redColor];
    [container addSubview:imgv];
    self.bank_icon_img = imgv;
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(m_bg_h*0.25);
        make.left.equalTo(line).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_bg_h*0.5, m_bg_h*0.5));
    }];
    //exchange
    font = PBSysFont(NHFontSubSize);
    NSString *info = @"选择银行卡";
    attributes = @{NSFontAttributeName:font};
    CGFloat m_tmp_width = [info sizeWithAttributes:attributes].width;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
//    btn.backgroundColor = [UIColor redColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:info forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exChangeBankCardAction) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btn];
    self.bank_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgv.mas_centerY);
        make.right.equalTo(line).offset(-NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_tmp_width, NH_CUSTOM_BTN_HEIGHT));
    }];
    
    //提现信息
    color = [UIColor colorWithRed:54/255.f green:54/255.f blue:54/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *outter_flag = [[UILabel alloc] init];
//    outter_flag.backgroundColor = [UIColor blueColor];
    outter_flag.font = font;
    outter_flag.textColor = color;
    [container addSubview:outter_flag];
    self.outterFlag = outter_flag;
    [outter_flag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgv.mas_centerY);
        make.left.equalTo(imgv.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(btn.mas_left).offset(-NH_CONTENT_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgv.mas_bottom).offset(m_bg_h*0.25);
        make.left.right.equalTo(container);
        make.height.equalTo(@1);
    }];
    
    //银行卡 微信 切换
    m_tmp_width = 100;
    font = PBSysFont(NHFontSubSize);
    NSString *preInfo = @"提现到";
    NSString *wx = @"微信钱包";
    NSString *cashWX = PBFormat(@"%@%@",preInfo,wx);
    UIColor *greenColor = [UIColor colorWithRed:112/255.f green:181/255.f blue:92/255.f alpha:1];
    NSDictionary *attrs = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cashWX attributes:attrs];
    NSRange colorRange = [cashWX rangeOfString:wx];
    [attrString addAttribute:NSForegroundColorAttributeName value:greenColor range:colorRange];
    NSString *card = @"银行卡";
    NSString *cashCD = PBFormat(@"%@%@",preInfo,card);
    NSMutableAttributedString *cardAttrString = [[NSMutableAttributedString alloc] initWithString:cashCD attributes:attrs];
    colorRange = [cashCD rangeOfString:card];
    [cardAttrString addAttribute:NSForegroundColorAttributeName value:rangeColor range:colorRange];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btn setTitle:@"提现到微信钱包" forState:UIControlStateNormal];
//    [btn setTitle:@"提现到银行卡" forState:UIControlStateSelected];
    [btn setAttributedTitle:attrString.copy forState:UIControlStateNormal];
    [btn setAttributedTitle:cardAttrString.copy forState:UIControlStateSelected];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(swtichOutterWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.switch_btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT*0.5);
        make.width.equalTo(m_tmp_width);
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
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(outterCashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.submit_btn = btn;btn.enabled = false;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.switch_btn.mas_bottom).offset(NH_CONTENT_MARGIN);
        make.left.equalTo(line.mas_left).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(line.mas_right).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    //说明
    font = PBSysFont(NHFontSubSize);
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    title = [[UILabel alloc] init];
    title.font = font;
    title.textColor = color;
    title.text = @"说明：";
    [container addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.right.equalTo(btn);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    NSArray *arrs = @[
                      @"1.提现金额不能少于50元",
                      @"2.每笔提现需要扣除5%的手续费",
                      @"3.提现将在2-3个工作日到账，双休节假日顺延",
                      @"4.其他情况请关注站内公告",
                      ];
    __block UILabel *last_lab = nil;
    
    [arrs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *mLabel = [[UILabel alloc] init];
        mLabel.font = font;
        mLabel.textColor = color;
        mLabel.numberOfLines = 0;
        mLabel.lineBreakMode = NSLineBreakByWordWrapping;
        mLabel.text = obj;
        [mLabel sizeToFit];
        [container addSubview:mLabel];
        [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_lab == nil)?title.mas_bottom:last_lab.mas_bottom).offset(NH_CONTENT_MARGIN);
            make.left.right.equalTo(title);
        }];
        
        last_lab = mLabel;
    }];
    
    //tel its layout was ended
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(last_lab.mas_bottom).offset(NH_BOUNDARY_MARGIN);
    }];
}

#pragma mark -- textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self updateCashOutterState:newString];
        return true;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateCashOutterState:newString];
    NSString *expression = @"^\\+?[1-9][0-9]*((\\.|,)[0-9]{0,2})?$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:& error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
    BOOL match = (numberOfMatches != 0);
    return match;
}

- (void)updateCashOutterState:(NSString *)text {
    CGFloat cash_mount = [text floatValue];
    self.submit_btn.enabled = (cash_mount >= NH_CASH_MIN_OUTTER);
}

- (void)handleCashOutterEvent:(NHCashOutterEvent)event {
    self.event = [event copy];
}

- (void)exChangeBankCardAction {
    NHBankCarder *bankCarder = [[NHBankCarder alloc] init];
    weakify(self)
    [bankCarder handleBankCardEvent:^(NSDictionary *card) {
        if (card) {
            NSLog(@"card:%@",card);
            _mCardInfo = nil;
            self.mCardInfo = [NSDictionary dictionaryWithDictionary:card];
            strongify(self)
            NSString *icon = [card objectForKey:@"icon"];
            NSString *name = [card objectForKey:@"name"];
            NSString *nums = [card objectForKey:@"cardnum"];
            nums = [[nums componentsSeparatedByString:@" "] lastObject];
            [self.bank_icon_img sd_setImageWithURL:[NSURL URLWithString:icon]];
            [self.outterFlag setText:PBFormat(@"%@(尾号：%@)",name,nums)];
            [self popUpLayer];
        }
    }];
    [self.navigationController pushViewController:bankCarder animated:true];
}

- (void)swtichOutterWay:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.bank_btn.hidden = btn.selected;
    
    //TODO:微信是否绑定
    BOOL isBindWX = false;
    if (!isBindWX) {
        NHWXProfiler *wxProfiler = [[NHWXProfiler alloc] init];
        weakify(self)
        [wxProfiler handleBindpublicWXEvent:^(BOOL success, NSString *wx) {
            if (success) {
                strongify(self)
                self.outterFlag.text = wx;
            }
        }];
        [self.navigationController pushViewController:wxProfiler animated:true];
    }
}

- (void)allCashOutterAction {
    NSInteger tmp = 1314.25;
    NSString *tmpInfo = PBFormat(@"%zd",tmp);
    self.cash_tfd.text = tmpInfo;
    [self updateCashOutterState:tmpInfo];
}

- (void)outterCashAction {
    //判断条件
    NSString *text = self.cash_tfd.text;
    CGFloat cash_mount = [text floatValue];
    if (cash_mount < NH_CASH_MIN_OUTTER) {
        NSString *alert = PBFormat(@"提现金额需不能少于%zd元！",NH_CASH_MIN_OUTTER);
        [SVProgressHUD showErrorWithStatus:alert];
        return;
    }
    if (!self.mCardInfo) {
        [SVProgressHUD showErrorWithStatus:@"请选择银行卡！"];
        return;
    }
    //TODO:联网提现
    if (_event) {
        _event(cash_mount, true);
    }
}

@end
