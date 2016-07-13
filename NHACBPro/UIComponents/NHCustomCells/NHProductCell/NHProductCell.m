//
//  NHProductCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHProductCell.h"

@implementation NHProductCell

@end

#pragma mark -- model

@interface NHProductModel ()

@property (nonatomic, assign)CGFloat closeHeight,openHeight;

@end

@implementation NHProductModel

- (id)init {
    self = [super init];
    if (self) {
        self.closeHeight = self.openHeight = 0;
    }
    return self;
}

- (CGFloat)heightForState:(NHCellExpandState)state {
    CGFloat tmp__ = (state == NHCellExpandStateOpen)? self.openHeight:self.closeHeight;
    if (tmp__ <= 0) {
        tmp__ = [self caculateForState:state];
        if (state == NHCellExpandStateOpen) {
            self.openHeight = tmp__;
        }else{
            self.closeHeight = tmp__;
        }
    }
    return tmp__;
}

- (CGFloat)caculateForState:(NHCellExpandState)state {
    CGFloat __tmp = 0;
    if (state == NHCellExpandStateOpen) {
        
    }else{
        __tmp = 340;
    }
    return __tmp;
}

@end