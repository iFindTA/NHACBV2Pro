//
//  NHCommenter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHCommenter.h"
#import "UITextView+Placeholder.h"

@interface NHCommenter ()<UITextViewDelegate>

@property (nonatomic, copy) NHCommenterEvent event;
@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UITextView *txw;
@property (nonatomic, strong) UIView *kitView;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong)UIView *viewToShowIn;
@property (nonatomic, strong)UIControl *bgControl;

@end

@implementation NHCommenter

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithPlaceHolder:(NSString *)holder {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.placeHolder = [holder copy];
        [self __initSetup];
        
        [self registerKeyNotifications];
        _bgControl = [[UIControl alloc] initWithFrame:self.bounds];
        [_bgControl setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.35]];
        [_bgControl addTarget:self action:@selector(bgTouchEvent) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_bgControl atIndex:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)registerKeyNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)handleCommenterEvent:(NHCommenterEvent)event {
    self.event = [event copy];
}

- (void)__initSetup {
    CGFloat kit_h = 150;
    UIColor *color = [UIColor colorWithRed:239/255.f green:239/255.f blue:238/255.f alpha:1];
    CGRect bounds = CGRectMake(0, PBSCREEN_HEIGHT, PBSCREEN_WIDTH, kit_h);
    UIView *v = [[UIView alloc] initWithFrame:bounds];
    v.backgroundColor = color;
    [self addSubview:v];
    self.kitView = v;
    
    CGFloat btn_w = 50;
    CGFloat btn_h = 30;
    bounds = CGRectMake(NH_BOUNDARY_MARGIN, NH_BOUNDARY_MARGIN, btn_w, btn_h);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    btn.exclusiveTouch = true;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelInputEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.kitView addSubview:btn];
    
    bounds = CGRectMake(PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN-btn_w, NH_BOUNDARY_MARGIN, btn_w, btn_h);
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    btn.exclusiveTouch = true;
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendInputEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.kitView addSubview:btn];
    self.sendBtn = btn;btn.enabled = false;
    
    CGFloat txw_h = kit_h-NH_BOUNDARY_MARGIN*2-btn_h-NH_CONTENT_MARGIN;
    bounds = CGRectMake(NH_BOUNDARY_MARGIN, NH_BOUNDARY_MARGIN+btn_h+NH_CONTENT_MARGIN, PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2, txw_h);
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIColor *placeColor = [UIColor colorWithRed:209/255.f green:210/255.f blue:213/255.f alpha:1];
    UITextView *tvw = [[UITextView alloc] initWithFrame:bounds];
    tvw.delegate = self;
    tvw.keyboardType = UIKeyboardTypeNamePhonePad;
    tvw.font = PBSysFont(NHFontSubSize);
    tvw.textColor = color;
    tvw.placeholderColor = placeColor;
    tvw.placeholder = self.placeHolder;
    [self.kitView addSubview:tvw];
    self.txw = tvw;
    
}

- (void)showInView:(UIView *)view {
    _viewToShowIn = view;
    
    [self.viewToShowIn addSubview:self];
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        [self.txw becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary*info=[noti userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGRect bounds = self.kitView.frame;
    bounds.origin.y = PBSCREEN_HEIGHT-kbSize.height-bounds.size.height-64;
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        [self.kitView setFrame:bounds];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelInputEvent {
    CGRect bounds = self.kitView.frame;
    bounds.origin.y = PBSCREEN_HEIGHT;
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        [self.kitView setFrame:bounds];
        [self.txw resignFirstResponder];
    } completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
            [_bgControl removeFromSuperview];
        }
    }];
    
    if (_event) {
        _event(nil, true);
    }
}

- (void)sendInputEvent {
    NSString *text = self.txw.text;
    if (text.length) {
        if (_event) {
            _event(text, false);
        }
    }
}

- (void)bgTouchEvent {
    [self cancelInputEvent];
}

#pragma mark -- UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *tmp = textView.text;
    NSMutableString *tmpString = [NSMutableString stringWithString:tmp];
    if ([tmpString stringByReplacingCharactersInRange:range withString:text].length > 200) {
        return false;
    }
    
    self.sendBtn.enabled = tmp.length > 0;
    
    return true;
}

@end
