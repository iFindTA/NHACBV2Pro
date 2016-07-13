//
//  NHBaseScrollView.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseScrollView.h"

@interface NHBaseScrollView ()

@property (nonatomic, assign) BOOL autoResignFirstResponder;

@end

@implementation NHBaseScrollView

- (id)init {
    self = [super init];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    self.autoResignFirstResponder = false;
}

- (void)enableEndEditing:(BOOL)end {
    self.autoResignFirstResponder = end;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.autoResignFirstResponder) {
        UIView *superView = self.superview;
        while (superView) {
            [superView endEditing:true];
            superView = superView.superview;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
