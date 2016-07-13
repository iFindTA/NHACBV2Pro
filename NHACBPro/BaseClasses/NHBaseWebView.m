//
//  NHBaseWebView.m
//  NHACBPro
//
//  Created by hu jiaju on 16/7/1.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseWebView.h"

@implementation NHBaseWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuCtr = [UIMenuController sharedMenuController];
    if (menuCtr) {
        menuCtr.menuVisible = false;
    }
    return false;
}

@end
