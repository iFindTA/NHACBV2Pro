//
//  NHBaseTextView.m
//  NHACBPro
//
//  Created by hu jiaju on 16/7/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseTextView.h"

@implementation NHBaseTextView

- (BOOL)canBecomeFirstResponder {
    return false;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuCtr = [UIMenuController sharedMenuController];
    if (menuCtr) {
        menuCtr.menuVisible = false;
    }
    return false;
    //return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
