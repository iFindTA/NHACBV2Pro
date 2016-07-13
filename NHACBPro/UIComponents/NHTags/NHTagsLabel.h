//
//  NHTagsLabel.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHTagsLabel : UIView

- (NHTagsLabel *)initWithFrame:(CGRect)frame withTags:(NSArray *)tags;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CGFloat cap;

//行间距
@property (nonatomic, assign) CGFloat lineCap;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIColor *tagColor;

@property (nonatomic, strong) NSArray *tags;

NS_ASSUME_NONNULL_END

@end
