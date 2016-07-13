//
//  NHConditionPicker.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/9.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHConditionPicker.h"
#import "NHConstants.h"

#define NHPickerHeight                    216
#define NHPickerToolBarHeight             44
#define NHPickerPrePlaceHolder            @"当前选择:"

@interface NHConditionPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy) NHConditionEvent event;
@property (nonatomic, strong)UIView *viewToShowIn;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)UILabel *preInfoLabel;
@property (nonatomic, strong)UIControl *bgControl;
@property (nonatomic, assign)NSInteger selectedRow;

@end

@implementation NHConditionPicker

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    _selectedRow = 0;
    [self.picker reloadAllComponents];
    [self.picker selectRow:0 inComponent:0 animated:true];
    NSString *preInfo = [self.dataSource objectAtIndex:[self.picker selectedRowInComponent:0]];
    NSString *preString = PBFormat(@"%@%@",NHPickerPrePlaceHolder,preInfo);
    self.preInfoLabel.text = preString;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect selfFrame = CGRectMake(0, PBSCREEN_HEIGHT, PBSCREEN_WIDTH, NHPickerToolBarHeight+NHPickerHeight);
        [self setFrame:selfFrame];
        self.backgroundColor = [UIColor colorWithRed:245/255.f green:249/255.f blue:242/255.f alpha:1.f];
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, NHPickerToolBarHeight, PBSCREEN_WIDTH, NHPickerHeight)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self addSubview:_picker];
        
        CGFloat boundsMargin = 10;
        CGFloat btn_width = 50;
        CGFloat btn_height = 30;
        //取消
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(boundsMargin, (NHPickerToolBarHeight-btn_height)*0.5, btn_width, btn_height);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelSelectDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        //完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(PBSCREEN_WIDTH-boundsMargin-btn_width, (NHPickerToolBarHeight-btn_height)*0.5, btn_width, btn_height);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneSelectedDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        //时间预查
        CGRect preDateTimeRect = CGRectMake(boundsMargin+btn_width, 0, (PBSCREEN_WIDTH-boundsMargin*2-btn_width*2), NHPickerToolBarHeight);
        _preInfoLabel = [[UILabel alloc] initWithFrame:preDateTimeRect];
        _preInfoLabel.backgroundColor = [UIColor clearColor];
        _preInfoLabel.font = [UIFont systemFontOfSize:13];
        _preInfoLabel.textAlignment = NSTextAlignmentCenter;
        _preInfoLabel.textColor = [UIColor colorWithRed:115/255.f green:157/255.f blue:96/255.f alpha:1.f];
        [self addSubview:_preInfoLabel];
        
        _selectedRow = -1;
    }
    return self;
}

-(void)handlePickerSelectBlock:(NHConditionEvent)aBlock {
    _event = [aBlock copy];
}

-(void)showInView:(UIView *)view {
    _viewToShowIn = view;
    
    CGRect viewRect = self.frame;
    CGRect mainScreenRect_ = [[UIScreen mainScreen] bounds];
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -viewRect.size.height);
    _bgControl = [[UIControl alloc] initWithFrame:mainScreenRect_];
    [_bgControl setBackgroundColor:[UIColor clearColor]];
    [self.viewToShowIn addSubview:_bgControl];
    
    [self.viewToShowIn addSubview:self];
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)cancelSelectDatePicker {
    CGRect viewRect = self.frame;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, viewRect.size.height);
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
            [_bgControl removeFromSuperview];
            if (_event){
                _event(YES,nil);
            }
        }
    }];
}

-(void)doneSelectedDatePicker {
    if (_selectedRow < 0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择一项内容！"];
        return;
    }
    NSString *preInfo = [self.dataSource objectAtIndex:[self.picker selectedRowInComponent:0]];
    CGRect viewRect = self.frame;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, viewRect.size.height);
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
            [_bgControl removeFromSuperview];
            if (_event){
                _event(NO,preInfo);
            }
        }
    }];
}

#pragma mark - UIPikerView Delegate && DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil){
        CGRect frame = CGRectMake(0.0, 0.0, PBSCREEN_WIDTH, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:NHFontTitleSize]];
    }
    if (component == 0){
        pickerLabel.text =  [self.dataSource objectAtIndex:row]; // Year
    }
    
    return pickerLabel;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0){
        _selectedRow = row;
        [self.picker reloadAllComponents];
    }
    NSString *preInfo = [self.dataSource objectAtIndex:[self.picker selectedRowInComponent:0]];
    NSString *preString = PBFormat(@"%@%@",NHPickerPrePlaceHolder,preInfo);
    self.preInfoLabel.text = preString;
}

@end
