//
//  NHInsetLabel.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/29.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHInsetLabel.h"

int const NH_INSERT_HORIZONTAL_PADDING                     =        16;
int const NH_INSERT_VERTICAL_PADDING                       =        0;

@implementation NHInsetLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(NH_INSERT_VERTICAL_PADDING, NH_INSERT_HORIZONTAL_PADDING, NH_INSERT_VERTICAL_PADDING, NH_INSERT_HORIZONTAL_PADDING))];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil], -NH_INSERT_HORIZONTAL_PADDING, 0);
}

@end
