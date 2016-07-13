//
//  NHADFlasher.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHADFlasher.h"
#import "NHCountingHUD.h"
#import "NHDBEngine.h"

#ifndef NH_AD_FLASH_TIMEINTERVAL
static const CGFloat NH_AD_FLASH_TIMEINTERVAL           = 3.5f;
#endif

@interface NHADFlasher ()

@property (nonatomic) CGFloat flashInterval;
@property (nonatomic) BOOL statusBarHiddenInited, dismissing;
@property (nonatomic, strong, nullable) UIWindow *mainWin;
@property (nonatomic, strong) NSDictionary *adInfo;
@property (nonatomic, assign) CGFloat downSize;
@property (nonatomic, strong) UIImageView *adImgView;
@property (nonatomic, copy) NHADEvent event;

@end

@implementation NHADFlasher

- (void)loadView {
    
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    //hidden the stausBar
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    CGSize viewSize  = (CGSize){mainSize.width*PBSCREEN_SCALE,mainSize.height*PBSCREEN_SCALE};
    self.downSize = 100;
    NSString * launchImage = @"acb_lanunch_7501134";
    NSArray * imageDict = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"NHLaunchImages"];
    for (NSDictionary  * dict in imageDict) {
        CGSize imageSize = CGSizeFromString(dict[@"NHLaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize)) {
            launchImage = dict[@"NHLaunchImageName"];
            self.downSize = [dict[@"NHLaunchImageDownSize"] floatValue];
            break;
        }
    }
    
    //启动图
    UIImage *bgImg = [UIImage imageNamed:launchImage];
    UIImageView *bgView = [[UIImageView alloc] init];
    [self.view addSubview:bgView];
    weakify(self)
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bgView.image = bgImg;
    
    //广告图
    UIImageView *adImgView = [[UIImageView alloc] init];
    //adImgView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:adImgView];
    self.adImgView = adImgView;
    [adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-self.downSize);
    }];
    
    NHColorBox box = {
        .bgColor = 0x1B191D,
        .bdColor = 0xD41617,
        .duration = NH_AD_FLASH_TIMEINTERVAL,
        .info = [@"跳过" UTF8String]
    };
    CGSize hudSize = (CGSize){50,50};
    NHCountingHUD *countHUD = [[NHCountingHUD alloc] initWithFrame:(CGRect){.origin = CGPointZero,.size = hudSize} withColorBox:box];
    [countHUD handleCountingEvent:^{
        strongify(self)
        [self dismiss:false];
    }];
    countHUD.backgroundColor = [UIColor clearColor];
    [self.view addSubview:countHUD];
    [countHUD mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view).offset(hudSize.height);
        make.right.equalTo(self.view).offset(-hudSize.width);
        make.width.height.equalTo(@(hudSize.width));
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.y + self.downSize < PBSCREEN_HEIGHT) {
        [self dismiss:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAD:(NSDictionary *)ad withEvent:(NHADEvent)event{
    self.adInfo = [NSDictionary dictionaryWithDictionary:ad];
    self.event = [event copy];
    //setup ad flash image
    NSString *img_url_str = [ad pb_stringForKey:@"imgurl"];
    SDImageCache *imgCache = [[SDImageCache alloc] initWithNamespace:NH_ADS_CACHE_NAMESPACE diskCacheDirectory:NH_ADS_CACHE_DIRECTORY];
    UIImage *image = [imgCache imageFromDiskCacheForKey:img_url_str];
    self.adImgView.image = image;
    //[self.adImgView sd_setImageWithURL:[NSURL URLWithString:img_url_str]];
    
    [self showInWindow];
}

- (UIWindow *)mainWin {
    if (_mainWin == nil) {
        CGRect mainBounds = [UIScreen mainScreen].bounds;
        _mainWin = [[UIWindow alloc] initWithFrame:mainBounds];
        _mainWin.backgroundColor = [UIColor whiteColor];
//        UIWindowLevel level = UIWindowLevelStatusBar + 10.f;
//        if (_statusBarHiddenInited) {
//            level = UIWindowLevelNormal + 10.f;
//        }
        _mainWin.windowLevel = UIWindowLevelNormal;
    }
    return _mainWin;
}

- (void)showInWindow {
    
    UIWindow *mainWindow = self.mainWin;
    mainWindow.rootViewController = self;
    //mainWindow.layer.opacity = 0.01f;
    [mainWindow makeKeyAndVisible];
}

- (void)dismiss:(BOOL)show {
    
    if (self.dismissing) {
        return;
    }
    if (!self.dismissing) {
        self.dismissing = true;
    }
//    _mainWin.rootViewController = nil;
//    [_mainWin removeFromSuperview];
//    _mainWin = nil;
    [self.mainWin removeFromSuperview];
    [self.mainWin resignKeyWindow];
    self.mainWin = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationFade];
    if (_event) {
        _event(show);
    }
}

+ (instancetype)init {
    return [[self alloc] init];
}

+ (void)makeKeyAndVisible:(NSDictionary *)info withEvent:(nonnull NHADEvent)event{
    [[NHADFlasher init] showAD:info withEvent:event];
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
