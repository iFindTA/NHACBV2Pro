//
//  NHActivityManualAlerter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/7/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHActivityManualAlerter.h"
#import "NHBaseTextView.h"

@interface NHActivityManualAlerter ()

@property (nonatomic, copy) NHManualAlertEvent event;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation NHActivityManualAlerter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.bgView) {
        [self renderActivityManualRecordAlertBody];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleActivityManualAlertEvent:(NHManualAlertEvent)event {
    self.event = [event copy];
}

static NSString *alertInfo = @"由于该平台未与爱财帮进行数据对接，所以需要你在完成活动之后，手动记录你的投资记录。爱财帮会根据记录与平台进行结算，结算完成后，对应的活动奖励会发放到你的帐户中。记录虚假的投资数据将会被视为无效记录。";

- (void)renderActivityManualRecordAlertBody {
    weakify(self)
    
    int mRecord_H = 48;
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"m_manual_record"];
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.bottom.equalTo(self.view).offset(-NH_CUSTOM_BTN_HEIGHT-NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.width.height.equalTo(mRecord_H);
    }];
    int mArrowWidth = 63;
    int mArrrowHeight = 55;
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"m_manual_record_arrow"];
    [self.view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgv.mas_left).offset(-NH_CONTENT_MARGIN);
        make.bottom.equalTo(imgv.mas_centerY);
        make.size.equalTo(CGSizeMake(mArrowWidth, mArrrowHeight));
    }];
    int mOffset = NH_CUSTOM_BTN_HEIGHT+mRecord_H+mArrrowHeight;
    int mBoundaryOffset = 50;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = NH_CORNER_RADIUS;
    bgView.layer.masksToBounds = true;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(mOffset, mBoundaryOffset, mOffset, mBoundaryOffset));
    }];
    CGFloat mContentOffset = NH_BOUNDARY_MARGIN+NH_CONTENT_MARGIN;
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:109/255.f green:125/255.f blue:224/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = NH_CUSTOM_BTN_HEIGHT*0.25;
    btn.layer.masksToBounds = true;
    btn.layer.borderWidth = NH_CUSTOM_LINE_HEIGHT;
    btn.layer.borderColor = color.CGColor;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(iKnowWhyNeedManualRecord) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(mContentOffset+NH_CONTENT_MARGIN);
        make.right.equalTo(bgView).offset(-mContentOffset-NH_CONTENT_MARGIN);
        make.bottom.equalTo(bgView).offset(-NH_BOUNDARY_MARGIN);
    }];
    
    //icon
    int mIconWidth = 118;
    CGFloat mIconScale = 118/100.f;
    mIconWidth = pb_autoResize(mIconWidth,NH_DESIGN_REFRENCE);
    CGFloat mIconHeight = mIconWidth/mIconScale;
    imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"m_manual_record_alert"];
    [bgView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(NH_BOUNDARY_MARGIN);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.equalTo(CGSizeMake(mIconWidth, mIconHeight));
    }];
    
    //text
    color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    NHBaseTextView *textV = [[NHBaseTextView alloc] init];
    //textV.backgroundColor = [UIColor blueColor];
    textV.editable = false;
    textV.font = PBSysFont(NHFontTitleSize);
    textV.textColor = color;
    textV.text = alertInfo;
    //textV.textContainerInset = UIEdgeInsetsMake(0, -NH_TEXT_PADDING*0.5, 0, -NH_TEXT_PADDING*1.5);
    [bgView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgv.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.equalTo(bgView).offset(mContentOffset);
        make.right.equalTo(bgView).offset(-mContentOffset+NH_TEXT_PADDING*1.5);
        make.bottom.equalTo(btn.mas_top).offset(-NH_BOUNDARY_MARGIN);
    }];
}

- (void)iKnowWhyNeedManualRecord {
    if (_event) {
        _event(true);
    }
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
