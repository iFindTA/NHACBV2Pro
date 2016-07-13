//
//  NHUserGuider.m
//  NHACBPro
//
//  Created by hu jiaju on 16/7/1.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHUserGuider.h"

@interface NHUserGuider ()<UIScrollViewDelegate>

@property (nonatomic, copy) NHUsrGuideEvent event;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation NHUserGuider

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.scroller) {
        [self renderUsrGuiderBody];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderUsrGuiderBody {
    weakify(self)
    CGRect bounds = self.view.bounds;
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:bounds];
    scroller.backgroundColor = [UIColor whiteColor];
    scroller.showsVerticalScrollIndicator = false;
    scroller.showsHorizontalScrollIndicator = false;
    scroller.pagingEnabled = true;
    scroller.bounces = false;
    scroller.delegate = self;
    [self.view addSubview:scroller];
    self.scroller = scroller;
    [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
    
    CGFloat wh_scale = 734.f/645;
    CGFloat mWidth = PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2;
    CGFloat mHeight = mWidth/wh_scale;
    CGFloat mUPSection = 120;
    mUPSection = pb_autoResize(mUPSection,NH_DESIGN_REFRENCE);
    int mPageCounts = 3;
    UIFont *titleFont = PBSysFont(21);
    UIFont *subFont = PBSysFont(NHFontTitleSize);
    UIColor *titleColor = [UIColor colorWithRed:50/255.f green:54/255.f blue:75/255.f alpha:1];
    UIColor *subColor = [UIColor colorWithRed:151/255.f green:153/255.f blue:160/255.f alpha:1];
    NSArray *titles = @[@"参与活动即享高额奖励",@"为投资保驾护航",@"爱财帮让你理财更轻松"];
    NSArray *subs = @[@"金币好礼拿到你手软",@"平台风控＋风险保证金 双重保障",@"立即体验"];
    for (int i = 0; i < mPageCounts; i++) {
        bounds = CGRectMake(NH_BOUNDARY_MARGIN+PBSCREEN_WIDTH*i, mUPSection, mWidth, mHeight);
        UIImage *img = [UIImage imageNamed:PBFormat(@"m_usr_guide_%d",i)];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:bounds];
        imgV.image = img;
        [scroller addSubview:imgV];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = titleFont;
        titleLab.textColor = titleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = titles[i];
        [scroller addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(imgV);
            make.top.equalTo(imgV.mas_bottom).offset(NH_BOUNDARY_MARGIN);
            make.height.equalTo(NH_CUSTOM_LAB_HEIGHT*2);
        }];
        NSString *subTitle = subs[i];
        if (i != mPageCounts-1) {
            UILabel *subLab = [[UILabel alloc] init];
            subLab.font = subFont;
            subLab.textColor = subColor;
            subLab.textAlignment = NSTextAlignmentCenter;
            subLab.text = subTitle;
            [scroller addSubview:subLab];
            [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(titleLab);
                make.top.equalTo(titleLab.mas_bottom);
                make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
            }];
        }else{
            subColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.exclusiveTouch = true;
            btn.titleLabel.font = subFont;
            btn.backgroundColor = subColor;
            btn.layer.cornerRadius = NH_CUSTOM_BTN_HEIGHT*0.5;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:subTitle forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(usrDidJoinAction) forControlEvents:UIControlEventTouchUpInside];
            [scroller addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLab.mas_bottom).offset(NH_CONTENT_MARGIN);
                make.centerX.equalTo(titleLab.mas_centerX);
                make.width.equalTo(pb_autoResize(200, NH_DESIGN_REFRENCE));
                make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
            }];
        }
    }
    
    CGSize mSize = CGSizeMake(PBSCREEN_WIDTH*mPageCounts, PBSCREEN_HEIGHT);
    self.scroller.contentSize = mSize;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = mPageCounts;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset_x = scrollView.contentOffset.x;
    CGFloat mWidth = floorf(CGRectGetWidth(self.scroller.bounds));
    NSUInteger mPageIdx = (offset_x + mWidth * 0.5) / mWidth;
    self.pageControl.currentPage = mPageIdx;
}

- (void)handleUserGuiderEnJoyEvent:(NHUsrGuideEvent)event {
    self.event = [event copy];
}

- (void)usrDidJoinAction {
    if (_event) {
        _event(self,true);
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
