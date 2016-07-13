//
//  NHActivityCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHActivityCell.h"
#import "TTTAttributedLabel.h"

@interface NHActivityCell ()

@property (nonatomic, copy) NHActivityEvent event;

@end

@implementation NHActivityCell

+ (CGFloat)heightForInfo:(NSDictionary *)aDic {
    if (aDic == nil) {
        return 0;
    }
    CGFloat mHeight = 0;
    CGFloat mTitleHeight = 50;
    CGFloat mActivityHeight = 110;
    NSArray *activities = [aDic objectForKey:@"activity"];
    mHeight = mTitleHeight + mActivityHeight * [activities count];
    
    return mHeight;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setupForInfo:(NSDictionary *)aDic {
    CGFloat mTopCap = 9;
    CGFloat mTitleHeight = 50;
    CGFloat mActivityHeight = 110;
    
    UIColor *capColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *cap = [[UILabel alloc] init];
    cap.backgroundColor = capColor;
    [self.contentView addSubview:cap];
    weakify(self)
    [cap mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(mTopCap));
    }];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_SEPERATE_LINE_HEX)];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(@(mTitleHeight));
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    //icon image
    CGFloat m_icon_h = (mTitleHeight-mTopCap)/3;
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.cornerRadius = NH_CORNER_RADIUS;
    icon.layer.masksToBounds = true;
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.contentView).offset(mTopCap+m_icon_h);
        make.left.equalTo(self.contentView).offset(m_icon_h);
        make.width.height.equalTo(@(m_icon_h));
    }];
    NSString *url = [aDic objectForKey:@"icon"];
    [icon sd_setImageWithURL:[NSURL URLWithString:url]];
    //icon name
    NSString *name = [aDic objectForKey:@"name"];
    UIColor *nameColor = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontSubSize);
    label.textColor = nameColor;
    label.text = name;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon.mas_centerY);
        make.left.equalTo(icon.mas_right).offset(m_icon_h*0.5);
        make.height.equalTo(@(m_icon_h));
        make.width.equalTo(@(PBSCREEN_WIDTH-m_icon_h*3));
    }];
    //arrow
    nameColor = [UIColor colorWithRed:70/255.f green:72/255.f blue:78/255.f alpha:1];
    label = [[UILabel alloc] init];
    label.font = PBFont(@"iconfont", NHFontSubSize);
    label.textColor = nameColor;
    label.text = @"\U0000e605";
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(icon.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-m_icon_h*0.5);
        make.width.height.equalTo(@(m_icon_h));
    }];
    //activity
    __block UIControl *last_tmp = nil;
    NSArray *activities = [aDic objectForKey:@"activity"];
    [activities enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strongify(self)
        UIControl *tmp = [self assembleActivityInfo:obj];
        tmp.tag = idx;
        [tmp addTarget:self action:@selector(activityTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tmp];
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((last_tmp == nil)?line.mas_bottom:last_tmp.mas_bottom);
            make.left.equalTo(@(NH_BOUNDARY_OFFSET));
            make.right.equalTo(@(NH_BOUNDARY_OFFSET));
            make.height.equalTo(@(mActivityHeight));
        }];
        
        last_tmp = tmp;
    }];
    
    //line
    UIColor *color_y = [UIColor colorWithRed:234/255.f green:234/255.f blue:241/255.f alpha:1];
    UIColor *color_x = [UIColor pb_colorWithHexString:PBFormat(@"%s",NH_SEPERATE_LINE_HEX)];
    NSUInteger count = [activities count];
    for (int i = 0; i < count; i++) {
        line = [[UILabel alloc] init];
        line.backgroundColor = (i == count-1)?color_x:color_y;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(@(mTitleHeight+mActivityHeight*(i+1)));
            make.left.equalTo(self.contentView).offset((i == count-1)?@0:@(m_icon_h));
            make.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
}

- (UIControl *)assembleActivityInfo:(NSDictionary *)aDic {
    UIControl *tmp = nil;
    if (aDic != nil) {
        //setting
        CGFloat m_top_offset = 25;
        CGFloat m_left_offset = NH_BOUNDARY_OFFSET;
        CGFloat m_width = PBSCREEN_WIDTH - m_left_offset*2;
        CGFloat m_height = 110;
        CGFloat m_scale = 0.618;
        CGRect bounds = (CGRect){
            .origin = CGPointZero,
            .size = CGSizeMake(m_width, m_height)
        };
        UIColor *color = [UIColor colorWithRed:250/255.f green:251/255.f blue:252/255.f alpha:1];
        tmp = [[UIControl alloc] initWithFrame:bounds];
        tmp.backgroundColor = color;
        
        //title
        color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
        NSString *title = [aDic objectForKey:@"title"];
        UILabel *label = [[UILabel alloc] init];
        label.font = PBSysBoldFont(NHFontTitleSize);
        label.textColor = color;
        label.text = title;
        [tmp addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(m_top_offset));
            make.left.equalTo(@0);
            make.width.equalTo(@(m_width*m_scale));
            make.height.equalTo(@(m_top_offset));
        }];
        
        //line
        color = [UIColor colorWithRed:234/255.f green:234/255.f blue:241/255.f alpha:1];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = color;
        [tmp addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(m_width*m_scale));
            make.top.equalTo(@(m_top_offset));
            make.bottom.equalTo(tmp.mas_bottom).offset(-m_top_offset);
            make.width.equalTo(@1);
        }];
        //活动奖励
        color = [UIColor colorWithRed:169/255.f green:170/255.f blue:198/255.f alpha:1];
        UILabel *activity = [[UILabel alloc] init];
//        activity.backgroundColor = [UIColor redColor];
        activity.textAlignment = NSTextAlignmentRight;
        activity.font = PBSysFont(NHFontSubSize);
        activity.textColor = color;
        activity.text = @"活动奖励";
        [tmp addSubview:activity];
        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.left.equalTo(@(m_width*m_scale));
            make.width.equalTo(@(m_width*(1-m_scale)));
            make.height.equalTo(@(m_top_offset));
        }];
        //内容
        color = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
        NSString *amount = PBFormat(@"%@",[aDic objectForKey:@"amout"]);
        NSString *unit = [aDic objectForKey:@"unit"];
        NSString *text = PBFormat(@"%@ %@",amount,unit);
        bounds = CGRectMake(m_width*m_scale, m_top_offset*2.5, m_width*(1-m_scale), m_top_offset);
        TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
        attributeLabel.userInteractionEnabled = false;
        attributeLabel.font = PBSysFont(NHFontSubSize);
        attributeLabel.textColor = color;
        attributeLabel.textAlignment = NSTextAlignmentRight;
        [attributeLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:amount options:NSNumericSearch];
            
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            UIFont *boldSystemFont = [UIFont systemFontOfSize:NHFontTitleSize+8];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
        }];
        [tmp addSubview:attributeLabel];
        
        //tags
        NSArray *tags = [aDic objectForKey:@"tags"];
        bounds = CGRectMake(0, m_top_offset*2, m_width*m_scale, m_top_offset);
        NHTagsLabel *tagsLabel = [[NHTagsLabel alloc] initWithFrame:bounds withTags:tags];
        [tmp addSubview:tagsLabel];
        bounds = tagsLabel.frame;
        if (bounds.size.height <= m_top_offset) {
            bounds.origin.y += m_top_offset * 0.5;
            tagsLabel.frame = bounds;
        }
    }
    return tmp;
}

- (void)activityTouchAction:(UIControl *)ctr {
    //NSLog(@"activity tag__:%zd",ctr.tag);
    if (_event) {
        _event(self, ctr.tag);
    }
}

- (void)handleActivityTouchEvent:(NHActivityEvent)event {
    self.event = [event copy];
}

#pragma mark -- public method

- (UIControl *)assembleAccessableActivityInfo:(NSDictionary *)aDic  lineHead:(BOOL)head{
    UIControl *tmp = nil;
    if (aDic != nil) {
        //setting
        CGFloat m_top_offset = 25;
        CGFloat m_left_offset = NH_BOUNDARY_OFFSET;
        CGFloat m_width = PBSCREEN_WIDTH - m_left_offset*3;
        CGFloat m_height = 110;
        CGFloat m_scale = 0.618;
        CGRect bounds = (CGRect){
            .origin = CGPointZero,
            .size = CGSizeMake(m_width, m_height)
        };
        UIColor *color = [UIColor colorWithRed:250/255.f green:251/255.f blue:252/255.f alpha:1];
        //color = [UIColor redColor];
        tmp = [[UIControl alloc] initWithFrame:bounds];
        tmp.backgroundColor = color;
        
        //title
        color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
        NSString *title = [aDic objectForKey:@"title"];
        UILabel *label = [[UILabel alloc] init];
        label.font = PBSysBoldFont(NHFontTitleSize);
        label.textColor = color;
        label.text = title;
        [tmp addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(m_top_offset));
            make.left.equalTo(@(m_left_offset));
            make.width.equalTo(@(m_width*m_scale));
            make.height.equalTo(@(m_top_offset));
        }];
        
        //活动奖励
        color = [UIColor colorWithRed:169/255.f green:170/255.f blue:198/255.f alpha:1];
        UILabel *activity = [[UILabel alloc] init];
        //        activity.backgroundColor = [UIColor redColor];
        activity.textAlignment = NSTextAlignmentRight;
        activity.font = PBSysFont(NHFontSubSize);
        activity.textColor = color;
        activity.text = @"活动奖励";
        [tmp addSubview:activity];
        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.left.equalTo(@(m_width*m_scale));
            make.width.equalTo(@(m_width*(1-m_scale)));
            make.height.equalTo(@(m_top_offset));
        }];
        //内容
        color = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
        NSString *amount = PBFormat(@"%@",[aDic objectForKey:@"amout"]);
        NSString *unit = [aDic objectForKey:@"unit"];
        NSString *text = PBFormat(@"%@ %@",amount,unit);
        bounds = CGRectMake(m_width*m_scale, m_top_offset*2.5, m_width*(1-m_scale), m_top_offset);
        TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:bounds];
        attributeLabel.userInteractionEnabled = false;
        attributeLabel.font = PBSysFont(NHFontSubSize);
        attributeLabel.textColor = color;
        attributeLabel.textAlignment = NSTextAlignmentRight;
        [attributeLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:amount options:NSNumericSearch];
            
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            UIFont *boldSystemFont = [UIFont systemFontOfSize:NHFontTitleSize+8];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
        }];
        [tmp addSubview:attributeLabel];
        
        color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
        label = [[UILabel alloc] init];
        label.font = PBFont(@"iconfont", NHFontSubSize);
        label.textColor = color;
        label.text = @"\U0000e605";
        [tmp addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tmp.mas_centerY);
            make.left.equalTo(attributeLabel.mas_right).offset(NH_BOUNDARY_OFFSET*0.5);
            make.width.height.equalTo(@(NH_BOUNDARY_OFFSET));
        }];
        
        //tags
        NSArray *tags = [aDic objectForKey:@"tags"];
        bounds = CGRectMake(m_left_offset, m_top_offset*2, m_width*m_scale, m_top_offset);
        NHTagsLabel *tagsLabel = [[NHTagsLabel alloc] initWithFrame:bounds withTags:tags];
        [tmp addSubview:tagsLabel];
        bounds = tagsLabel.frame;
        if (bounds.size.height <= m_top_offset) {
            bounds.origin.y += m_top_offset * 0.5;
            tagsLabel.frame = bounds;
        }
        
        color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
        label = [[UILabel alloc] init];
        label.backgroundColor = color;
        [tmp addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tmp.mas_bottom);
            make.left.equalTo(tmp.mas_left).offset(head?0:NH_BOUNDARY_OFFSET);
            make.right.equalTo(tmp);
            make.height.equalTo(@1);
        }];
    }
    return tmp;
}

@end
