//
//  NHBaseWinViewController.h
//  NHACBPro
//
//  Created by hu jiaju on 16/7/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

@interface NHBaseWinViewController : NHBaseViewController

@property (nonatomic, assign, readonly) BOOL statusBarHiddenInited;

@property (nonatomic, assign, readonly) BOOL dismissing;

@property (nonatomic, strong, readonly) UIWindow *mainWin;

- (void)show NS_REQUIRES_SUPER;

- (void)dismiss:(BOOL)animate NS_REQUIRES_SUPER;

@end
