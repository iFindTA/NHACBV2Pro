//
//  NHCountingHUD.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 16/5/26.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHCountingHUD.h"

@interface NHCountingHUD ()

@property (nonatomic, assign) NHColorBox colorBox;
@property (nonatomic, copy) NHCountingEvent event;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, copy) NSString *info;

@end

@implementation NHCountingHUD

- (id)initWithFrame:(CGRect)frame withColorBox:(NHColorBox)box {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *info = [NSString stringWithUTF8String:box.info];
        self.info = [info copy];
        self.colorBox = box;
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    
    if (_info == nil) {
        NSString *info = [NSString stringWithUTF8String:self.colorBox.info];
        self.info = [info copy];
    }
    
    self.isEnd = false;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    if ([self.path containsPoint:point]) {
        [self endDescCounting];
    }
}

- (void)handleCountingEvent:(NHCountingEvent)event {
    self.event = [event copy];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect bounds = self.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    NSAssert(width == height, @"width must equal to height!");
    
    CGFloat duration = self.colorBox.duration;
    CGPoint center = {width*0.5,width*0.5};
    CGFloat bdWidth = 3.f;CGFloat radius = width*0.5;
    UIColor *bgColor = [UIColor colorWithRed:((float)((self.colorBox.bgColor & 0xFF0000) >> 16))/255.0
                                       green:((float)((self.colorBox.bgColor & 0x00FF00) >> 8))/255.0
                                        blue:((float)((self.colorBox.bgColor & 0x0000FF) >> 0))/255.0
                                       alpha:1];
    UIColor *bdColor = [UIColor colorWithRed:((float)((self.colorBox.bdColor & 0xFF0000) >> 16))/255.0
                                       green:((float)((self.colorBox.bdColor & 0x00FF00) >> 8))/255.0
                                        blue:((float)((self.colorBox.bdColor & 0x0000FF) >> 0))/255.0
                                       alpha:1];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:true];
    [path closePath];
//    CGContextSetFillColorWithColor(ctx, [bdColor CGColor]);
//    CGContextAddPath(ctx, path.CGPath);
//    CGContextDrawPath(ctx, kCGPathFill);
    //圆环
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.frame = bounds;
    circle.lineWidth = bdWidth;
    circle.strokeColor = bdColor.CGColor;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.path = path.CGPath;
    circle.strokeStart = 0;
    circle.strokeEnd = 1;
    [self.layer addSublayer:circle];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = bounds;
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = bdWidth;
    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 0, 1);
    shapeLayer.transform = transform;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = false;
    animation.delegate = self;
    [shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    circle.mask = shapeLayer;
    
    //radius -= bdWidth ;
    path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:true];
    CGContextSetFillColorWithColor(ctx, [bgColor CGColor]);
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
    self.path = path;
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    NSString *info = self.info;
//    NSString *__info = [NSString stringWithUTF8String:self.colorBox.info];
//    NSLog(@"draw info :%@",__info);
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    UIColor *color = [UIColor whiteColor];
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,color,NSForegroundColorAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    CGSize fontSize = [info sizeWithAttributes:attributes];
    fontSize = (CGSize){floorf(fontSize.width),floorf(fontSize.height)};
    bounds = (CGRect){.origin = {(width-fontSize.width)*0.5, (height-fontSize.height)*0.5}, .size = fontSize};
    [info drawInRect:bounds withAttributes:attributes];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self endDescCounting];
}

- (void)endDescCounting {
    if (!self.isEnd) {
        self.isEnd = true;
        if (_event) {
            _event();
        }
    }
}

@end
