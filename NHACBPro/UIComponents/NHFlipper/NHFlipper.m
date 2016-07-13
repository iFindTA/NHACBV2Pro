//
//  NHFlipper.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFlipper.h"

#pragma mark -- NHFlipperCell

@interface NHFlipperCell ()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation NHFlipperCell

- (NHFlipperCell *)initWithIdentifier:(NSString *)identifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.identifier = [identifier copy];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

#pragma mark -- NHFlipper

@interface NHFlipper ()

@property (nonatomic, strong) NSTimer *flipTimer;
@property (nonatomic, assign) NSInteger curIdx, nums;
@property (nonatomic, strong) NSMutableDictionary *identifierDict;
@property (nonatomic, strong) NHFlipperCell *currCell,*nextCell;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation NHFlipper

- (void)dealloc {
    _identifierDict = nil;
    if (_flipTimer != nil) {
        if ([_flipTimer isValid]) {
            [_flipTimer invalidate];
        }
        _flipTimer = nil;
    }
}

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
    self.clipsToBounds = true;
    self.direction = NHFlipperDirectionDefault;
    self.identifierDict = [NSMutableDictionary dictionary];
    [self addSubview:self.contentView];
    weakify(self)
     [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
         strongify(self)
        make.edges.equalTo(self);
    }];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        //_contentView.clipsToBounds = true;
//        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    weakify(self)
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self);
    }];
}

/**
 *  @brief called when reloadData method is called
 */
- (void)showDefaultCell {
    NHFlipperCell *cell = [self.dataSource flipper:self cellForRowIndex:self.curIdx];
    cell.clipsToBounds = true;
    [self.contentView addSubview:cell];
    self.currCell = cell;
    weakify(self)
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.contentView);
    }];
    
    [self prepareNextCell];
}

/**
 *  @brief called when display current cell
 */
- (void)prepareNextCell {
    NSUInteger tmp_idx = self.curIdx + 1;
    if (tmp_idx >= self.nums) {
        tmp_idx = 0;
    }
    
    NHFlipperCell *tmp_next = [self.dataSource flipper:self cellForRowIndex:tmp_idx];
    tmp_next.clipsToBounds = true;
    self.nextCell = tmp_next;
    [self.contentView insertSubview:self.nextCell aboveSubview:self.currCell];
    weakify(self)
    if (self.direction == NHFlipperDirectionDefault) {
        [tmp_next mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(@0);
            //make.left.equalTo(@(CGRectGetWidth(self.bounds)));
            make.left.mas_equalTo(self.currCell.mas_right);
            make.width.mas_equalTo(self.currCell.mas_width);
            make.height.mas_equalTo(self.currCell.mas_height);
        }];
    }else{
        [tmp_next mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.mas_equalTo(self.currCell.mas_bottom);
            //make.left.equalTo(@(CGRectGetWidth(self.bounds)));
            make.left.equalTo(@0);
            make.width.mas_equalTo(self.currCell.mas_width);
            make.height.mas_equalTo(self.currCell.mas_height);
        }];
    }
}

- (void)launchTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeFired) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.flipTimer = timer;
}

- (void)invalidateTimer {
    if (_flipTimer != nil) {
        if ([_flipTimer isValid]) {
            [_flipTimer invalidate];
        }
        _flipTimer = nil;
    }
}

- (void)timeFired {
    weakify(self)
    if (self.direction == NHFlipperDirectionDefault) {
        [self.currCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.and.bottom.equalTo(self.contentView);
            make.right.equalTo(@0);
            make.left.equalTo(@(-CGRectGetWidth(self.bounds)));
        }];
    }else{
        [self.currCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(@(-CGRectGetHeight(self.bounds)));
            make.left.right.equalTo(@0);
            make.width.equalTo(self.contentView);
        }];
    }
    self.curIdx ++;
    if (self.curIdx >= self.nums) {
        self.curIdx = 0;
    }
    [self.nextCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.contentView);
    }];
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        [self.contentView layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (finished) {
            strongify(self)
            [self queueReusablePageWithIdentifier:self.currCell];
            [self.currCell removeFromSuperview];self.currCell = nil;
            self.currCell = self.nextCell;
            self.nextCell = nil;
            [self prepareNextCell];
        }
    }];
}

- (void)reloadData {
    if (self.dataSource == nil) {
        return;
    }
    [self invalidateTimer];
    self.curIdx = 0;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currCell = nil;self.nextCell = nil;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsForFlipper:)]) {
        self.nums = [self.dataSource numberOfRowsForFlipper:self];
        if (self.nums) {
            [self showDefaultCell];
            [self launchTimer];
        }
    }
    //NSAssert(self.nums > 0, @"nums cell of flipper must be positived!");
}

#pragma mark -- circle reuse logic --

- (NSMutableArray *)obtainCacheWithIdentifier:(NSString *)identifier{
    NSMutableArray *pageCacheArr = [_identifierDict objectForKey:identifier];
    if (pageCacheArr == nil || [pageCacheArr count] <= 0) {
        pageCacheArr = [NSMutableArray array];
        [_identifierDict setObject:pageCacheArr forKey:identifier];
    }
    //NSInteger count = [pageCacheArr count];
    //NSLog(@"reuse queue counts:%zd",count);
    return pageCacheArr;
}

- (NHFlipperCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    NSMutableArray *pageCacheArr = [self obtainCacheWithIdentifier:identifier];
    NHFlipperCell *page = [pageCacheArr lastObject];
    NHFlipperCell *dstCell = page;
    if (page) {
        //NSLog(@"reuse old page");
        [pageCacheArr removeLastObject];
    }
    return dstCell;
}

- (void)queueReusablePageWithIdentifier:(NHFlipperCell *)page {
    if (page == nil) {
        return;
    }
    NSMutableArray *pageCacheArr = [self obtainCacheWithIdentifier:page.identifier];
    [pageCacheArr addObject:page];
    [page removeFromSuperview];
}

#pragma mark -- setter --

- (void)setDirection:(NHFlipperDirection)direction {
    if (direction != self.direction) {
        _direction = direction;
        [self reloadData];
    }
}

- (void)setDataSource:(id<NHFlipperDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark -- Touch Event --

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(flipper:didSelectRowIndex:)] && self.nums > 0) {
        [_delegate flipper:self didSelectRowIndex:self.curIdx];
    }
}

@end
