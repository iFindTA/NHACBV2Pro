//
//  NHTagsLabel.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHTagsLabel.h"

@interface NHTagsLabel ()

@end

@implementation NHTagsLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (NHTagsLabel *)initWithFrame:(CGRect)frame withTags:(NSArray *)tags {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initSetup];
        self.tags = [tags copy];
    }
    return self;
}

- (void)__initSetup {
    self.font = [UIFont systemFontOfSize:NHFontSubSize];
    self.cap = 5;self.cornerRadius = 4;
    self.lineCap = 4;
    self.tagColor = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
}

- (void)setTags:(NSArray *)tags {
    if (tags == nil || tags.count == 0) {
        return;
    }
    _tags = tags;
    [self reloadSubviews];
}

- (UIImage *)getBgImage {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat w = 20;
//        CGFloat r = self.cornerRadius;
//        CGPoint p1 = CGPointMake(0, r);
//        CGPoint p2 = CGPointMake(0, w-r);
//        //CGPoint p3 = CGPointMake(r, w);
//        CGPoint p4 = CGPointMake(w-r, w);
//        //CGPoint p5 = CGPointMake(w, w-r);
//        CGPoint p6 = CGPointMake(w, r);
//        //CGPoint p7 = CGPointMake(w-r, 0);
//        CGPoint p8 = CGPointMake(r, 0);
//        CGPoint o1 = CGPointMake(r, r);
//        CGPoint o2 = CGPointMake(r, w-r);
//        CGPoint o3 = CGPointMake(w-r, w-r);
//        CGPoint o4 = CGPointMake(w-r, r);
//        CGSize size = CGSizeMake(w, w);
//        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
//        
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        path.lineWidth = 1;
//        path.lineCapStyle = kCGLineCapButt;
//        path.lineJoinStyle = kCGLineJoinMiter;
//        [path moveToPoint:p1];
//        [path addLineToPoint:p2];
//        [path addArcWithCenter:o2 radius:r startAngle:M_PI endAngle:M_2_PI clockwise:false];
//        [path addLineToPoint:p4];
//        [path addArcWithCenter:o3 radius:r startAngle:M_2_PI endAngle:0 clockwise:false];
//        [path addLineToPoint:p6];
//        [path addArcWithCenter:o4 radius:r startAngle:0 endAngle:M_PI*1.5 clockwise:false];
//        [path addLineToPoint:p8];
//        [path addArcWithCenter:o1 radius:r startAngle:M_PI*1.5 endAngle:M_PI clockwise:false];
//        [self.tagColor setStroke];
//        [path stroke];
//        
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        UIImage *img = [UIImage pb_imageWithColor:[UIColor whiteColor]];
        img = [img pb_scaleToSize:CGSizeMake(w, w) keepAspect:false];
        image = [img pb_roundCornerWithRadius:NH_CORNER_RADIUS withBorderWidth:1 withBorderColor:self.tagColor];
    });
    return image;
}

- (void)reloadSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImage *bgImg = [self getBgImage];
    bgImg = [bgImg stretchableImageWithLeftCapWidth:8 topCapHeight:18];
    CGFloat m_cap = MAX(self.cap, 5);
    UIFont *m_font = (self.font == nil)?[UIFont systemFontOfSize:10]:self.font;
    NSDictionary *attributes = @{NSFontAttributeName:m_font};
    CGFloat m_width = CGRectGetWidth(self.bounds);
    __block CGFloat line_width = 0;__block int row_idx = 0;__block CGFloat m_height = 0;
    [self.tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeWithAttributes:attributes];
        size = CGSizeMake(size.width+m_cap, size.height);
        if (idx == 0) {
            m_height = size.height;
        }
        if (line_width + m_cap + size.width > m_width) {
            //换行
            line_width = 0;
            row_idx++;
        }
        CGRect bounds = (CGRect){
            .origin = CGPointMake(line_width + ((line_width == 0)?0:m_cap), self.lineCap + (size.height+self.lineCap)*row_idx),
            .size = size};
        UIButton *tag__ = [UIButton buttonWithType:UIButtonTypeCustom];
        tag__.frame = bounds;
        tag__.titleLabel.font = m_font;
        [tag__ setBackgroundImage:bgImg forState:UIControlStateNormal];
        [tag__ setTitle:obj forState:UIControlStateNormal];
        [tag__ setTitleColor:self.tagColor forState:UIControlStateNormal];
        tag__.enabled = false;
        [self addSubview:tag__];
        
        line_width += self.lineCap+size.width;
    }];
    
    CGFloat mHeight = self.lineCap*2+(m_height+self.lineCap)*row_idx;
    CGRect bounds = self.frame;
    bounds.size.height = mHeight;
    self.frame = bounds;
}

@end
