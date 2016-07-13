//
//  NHNoticeCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/22.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHNoticeCell.h"

@implementation NHNoticeCell

- (NHNoticeCell *)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    [self addSubview:self.mTitleLabel];
    UIColor *color = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)];
    UIFont *font = PBSysFont(NHFontSubSize-2);
    self.mTitleLabel.font = font;
    self.mTitleLabel.textColor = color;
    self.mTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.mTitleLabel.layer.cornerRadius = NH_CORNER_RADIUS;
    self.mTitleLabel.layer.masksToBounds = true;
    self.mTitleLabel.layer.borderWidth = NH_CUSTOM_LINE_HEIGHT;
    self.mTitleLabel.layer.borderColor = [color CGColor];
    
    [self addSubview:self.mSubLabel];
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    self.mSubLabel.font = font;
    self.mSubLabel.textColor = color;
}

- (UILabel *)mTitleLabel {
    if (!_mTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.clipsToBounds = true;
        _mTitleLabel = label;
    }
    return _mTitleLabel;
}

- (UILabel *)mSubLabel {
    if (!_mSubLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.clipsToBounds = true;
        _mSubLabel = label;
    }
    return _mSubLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    weakify(self)
    CGFloat m_h = 18;CGFloat m_w = m_h * 1.7;
    [self.mTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self);
        make.left.equalTo(@(NH_BOUNDARY_OFFSET));
        make.height.equalTo(@(m_h));
        make.width.equalTo(@(m_w));
    }];
    [self.mSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self);
        make.left.equalTo(self.mTitleLabel.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self);
        make.height.equalTo(@(m_h));
    }];
}

@end
