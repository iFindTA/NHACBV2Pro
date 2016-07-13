//
//  NHBaseTextField.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseTextField.h"

@implementation NHBaseTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return false;
    }else if (action == @selector(paste:)){
        return false;
    }
    return true;
}

@end
