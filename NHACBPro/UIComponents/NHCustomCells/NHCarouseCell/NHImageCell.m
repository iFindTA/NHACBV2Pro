//
//  NHImageCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/22.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHImageCell.h"

@interface NHImageCell ()

@end

@implementation NHImageCell

- (NHImageCell *)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    [self addSubview:self.imgv];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIImageView *)imgv {
    if (!_imgv) {
        UIImageView *imgv = [[UIImageView alloc] init];
        _imgv = imgv;
    }
    return _imgv;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    weakify(self)
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self);
        make.size.equalTo(CGSizeMake(PBSCREEN_WIDTH, 90));
    }];
}

@end
