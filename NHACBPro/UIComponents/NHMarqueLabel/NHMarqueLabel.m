//
//  NHMarqueLabel.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/2.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHMarqueLabel.h"

@interface NHMarqueLabel ()

@property (nonatomic, assign) NHMarqueDirection direction;
@property (nonatomic, strong) UILabel *mLabel, *mDisLabel;
@property (nonatomic, assign) NSInteger mNums,mNumIdx;
@property (nonatomic, copy) NSString *mCurInfo;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic) CGFloat mFontSize;

@end

@implementation NHMarqueLabel

- (id)initWithFrame:(CGRect)frame withDirection:(NHMarqueDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        self.direction = direction;
        [self __initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.direction = NHMarqueDirectionHorizon;
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    self.clipsToBounds = true;
    [self addSubview:self.mDisLabel];
    [self addSubview:self.mLabel];
}

- (UILabel *)mDisLabel {
    if (_mDisLabel == nil) {
        int font_offset = 4;
        CGFloat m_height = CGRectGetHeight(self.bounds);
        CGFloat fontSize = m_height-font_offset;
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.numberOfLines = 1;
        [self addSubview:label];
        _mDisLabel = label;//label.hidden = true;
    }
    return _mDisLabel;
}

- (UILabel *)mLabel {
    if (_mLabel == nil) {
        int font_offset = 4;int line_num = 2;
        CGFloat m_height = CGRectGetHeight(self.bounds);
        CGFloat m_width = CGRectGetWidth(self.bounds);
        CGFloat fontSize = m_height-font_offset;
        CGRect bounds ;
        if (self.direction == NHMarqueDirectionHorizon) {
            bounds = CGRectMake(m_width, 0, m_width , m_height);
        }else{
            bounds = CGRectMake(0, 0, m_width, m_height * 2);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:bounds];
        label.backgroundColor = [UIColor clearColor];;
        label.font = [UIFont systemFontOfSize:fontSize];
        label.numberOfLines = line_num;
        [self addSubview:label];
        _mLabel = label;label.hidden = true;
        self.mFontSize = fontSize;
    }
    return _mLabel;
}

- (void)setDataSource:(id<NHMarqueLabelDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    NSAssert(self.dataSource != nil, @"dataSource can not be nil!");
    [self invalidateTimer];
    self.mLabel.hidden = true;
    self.mDisLabel.hidden = false;
    self.mDisLabel.text = nil;
    //[self setNeedsDisplay];
    self.mNums = self.mNumIdx = 0;
    self.mNums = [self.dataSource numberLinesInMarque:self];
    if (self.mNums <= 0) {
        return;
    }
    NSAssert(self.mNums > 0, @"numbers of marque must be positived!");
    [self displayCurrentInfo];
    //[self setNeedsDisplay];
    [self launchTimer];
}

- (NSString *)getCurrentInfo {
    NSString *m_tmp = [self.dataSource marque:self infoForIndex:self.mNumIdx];
    
    return [m_tmp copy];
}

- (void)displayCurrentInfo {
    self.mCurInfo = [self getCurrentInfo];
    self.mDisLabel.text = self.mCurInfo;
}

- (void)launchTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeFireMarque) userInfo:nil repeats:true];
    self.mTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //[timer add]
}

- (void)invalidateTimer {
    if (_mTimer != nil) {
        if ([_mTimer isValid]) {
            [_mTimer invalidate];
        }
        _mTimer = nil;
    }
}

- (void)timeFireMarque {
    
    NSString *m_tmp = [self.mCurInfo copy];
    self.mNumIdx ++;
    if (self.mNumIdx >= self.mNums) {
        self.mNumIdx = 0;
    }
    NSString *m_next_tmp = [self getCurrentInfo];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.mFontSize]};
    CGSize size = [m_next_tmp sizeWithAttributes:attributes];
    if (size.width > CGRectGetWidth(self.bounds)) {
        //TODO:处理字符串过长
    }
    
    CGRect frame = self.mLabel.frame;
    if (self.direction == NHMarqueDirectionHorizon) {
        CGRect bounds = self.bounds;
        CGFloat mWidth = CGRectGetWidth(bounds);
        frame.origin.x = mWidth;
        self.mLabel.frame = frame;
        self.mLabel.hidden = false;
        self.mLabel.text = m_next_tmp;
        frame.origin.x = -mWidth;
        [UIView animateWithDuration:0.25 animations:^{
            self.mDisLabel.frame = frame;
            self.mLabel.frame = bounds;
        } completion:^(BOOL finished) {
            if (finished) {
                self.mCurInfo = [m_next_tmp copy];
                //[self setNeedsDisplay];
                self.mDisLabel.frame = bounds;
                self.mDisLabel.text = m_next_tmp;
                self.mLabel.hidden = true;
            }
        }];
        
    }else{
        NSString *m_dis_info = PBFormat(@"%@\n%@",m_tmp,m_next_tmp);
        frame.origin.y = 0;
        self.mLabel.frame = frame;
        self.mLabel.hidden = false;
        self.mLabel.text = m_dis_info;
        
        self.mDisLabel.hidden = true;
        //[self setNeedsDisplay];
        //NSLog(@"scroll dis:%@",m_dis_info);
        frame.origin.y -= CGRectGetHeight(self.bounds);
        [UIView animateWithDuration:0.25 animations:^{
            self.mLabel.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.mCurInfo = [m_next_tmp copy];
                //[self setNeedsDisplay];
                self.mDisLabel.hidden = false;
                self.mDisLabel.text = m_next_tmp;
                self.mLabel.hidden = true;
            }
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_delegate && [_delegate respondsToSelector:@selector(marque:didSelectRow:)]) {
        [_delegate marque:self didSelectRow:self.mNumIdx];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
////    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.mFontSize]};
////    CGSize size = [self.mCurInfo sizeWithAttributes:attributes];
////    CGFloat m_height = CGRectGetHeight(self.bounds);
////    CGRect bounds = (CGRect){.origin = CGPointMake(0, (m_height-size.height)*0.5),.size=size};
////    [self.mCurInfo drawInRect:bounds withAttributes:attributes];
//}

@end
