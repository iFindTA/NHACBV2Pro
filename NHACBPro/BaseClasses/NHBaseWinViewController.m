//
//  NHBaseWinViewController.m
//  NHACBPro
//
//  Created by hu jiaju on 16/7/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseWinViewController.h"

@interface NHBaseWinViewController ()

@property (nonatomic) BOOL statusBarHiddenInited, dismissing;
@property (nonatomic, strong, nullable) UIWindow *mainWin;

@end

@implementation NHBaseWinViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    // do not call super method
    //[super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- getter

- (UIWindow *)mainWin {
    if (_mainWin == nil) {
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
        _mainWin = window;
    }
    return _mainWin;
}

- (void)show {
    if (self.mainWin) {
        [self.mainWin makeKeyAndVisible];
    }
}

- (void)dismiss:(BOOL)animate {
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
