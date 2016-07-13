//
//  NHDatePicker.m
//  LFStreetLifeProject
//
//  Created by hu jiaju on 14-7-4.
//  Copyright (c) 2014年 Linfang. All rights reserved.
//
#define NHDatePickerHeight                    216
#define NHDatePickerToolBarHeight             44
#define NHDatePickerPrePlaceHolder            @"当前日期:"

#import "NHDatePicker.h"
#import "NHConstants.h"

@interface NHDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy)NHDatePickerBlock resultBlock;
@property (nonatomic, strong)UIView *viewToShowIn;
@property (nonatomic, strong)UIPickerView *datePicker;
@property (nonatomic, strong)UILabel *dateTimePreLabel;
@property (nonatomic, strong)UIControl *backgroundControl;
@property (nonatomic, strong)NSMutableArray *yearArray,*DaysArray,*hoursArray,*minutesArray;
@property (nonatomic, strong)NSArray *monthArray;
@property (nonatomic, copy)NSString *currentMonthString;
@property (nonatomic, assign)NSInteger selectedYearRow,selectedMonthRow,selectedDayRow;

@end

@implementation NHDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect selfFrame = CGRectMake(0, PBSCREEN_HEIGHT, PBSCREEN_WIDTH, NHDatePickerToolBarHeight+NHDatePickerHeight);
        [self setFrame:selfFrame];
        self.backgroundColor = [UIColor colorWithRed:245/255.f green:249/255.f blue:242/255.f alpha:1.f];
        
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, NHDatePickerToolBarHeight, PBSCREEN_WIDTH, NHDatePickerHeight)];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        [self addSubview:_datePicker];
        
        CGFloat boundsMargin = 10;
        CGFloat btn_width = 50;
        CGFloat btn_height = 30;
        //取消
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(boundsMargin, (NHDatePickerToolBarHeight-btn_height)*0.5, btn_width, btn_height);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelSelectDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        //完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(PBSCREEN_WIDTH-boundsMargin-btn_width, (NHDatePickerToolBarHeight-btn_height)*0.5, btn_width, btn_height);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneSelectedDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        //时间预查
        CGRect preDateTimeRect = CGRectMake(boundsMargin+btn_width, 0, (PBSCREEN_WIDTH-boundsMargin*2-btn_width*2), NHDatePickerToolBarHeight);
        _dateTimePreLabel = [[UILabel alloc] initWithFrame:preDateTimeRect];
        _dateTimePreLabel.backgroundColor = [UIColor clearColor];
        _dateTimePreLabel.font = [UIFont systemFontOfSize:13];
        _dateTimePreLabel.textAlignment = NSTextAlignmentCenter;
        _dateTimePreLabel.textColor = [UIColor colorWithRed:115/255.f green:157/255.f blue:96/255.f alpha:1.f];
        [self addSubview:_dateTimePreLabel];
        
        [self loadCustomDatePickerDataSource];
    }
    return self;
}

-(void)loadCustomDatePickerDataSource
{
    NSDate *date = [NSDate date];
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    _currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // Get Current  Hour
//    [formatter setDateFormat:@"HH"];
//    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
//    // Get Current  Minutes
//    [formatter setDateFormat:@"mm"];
//    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // Get Current  AM PM
    //[formatter setDateFormat:@"a"];
    //NSString *currentTimeAMPMString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    // PickerView -  Years data 从今年开始 总共五年
    _yearArray = [[NSMutableArray alloc]init];
    NSInteger startYearIntValue = currentyearString.integerValue;
    NSInteger offsetYear = 7;
    for (int i = (int)(startYearIntValue-2); i <= startYearIntValue+offsetYear ; i++) {
        [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    // PickerView -  Months data
    _monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    // PickerView -  Hours data
    _hoursArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<24; i++) {
        NSString *hour = [NSString stringWithFormat:@"%.2d",i];
        [_hoursArray addObject:hour];
    }
    // PickerView -  Hours data
    _minutesArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i++) {
        [_minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    // PickerView -  AM PM data
    //_amPmArray = @[@"AM",@"PM"];
    _DaysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 31; i++) {
        [_DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    // PickerView - Default Selection as per current Date
    
    [self.datePicker selectRow:[_yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    [self.datePicker selectRow:[_monthArray indexOfObject:_currentMonthString] inComponent:1 animated:YES];
    [self.datePicker selectRow:[_DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
//    [self.datePicker selectRow:[_hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
//    [self.datePicker selectRow:[_minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
    //[self.datePicker selectRow:[_amPmArray indexOfObject:currentTimeAMPMString] inComponent:5 animated:YES];
    _selectedYearRow = [_yearArray indexOfObject:currentyearString];
    _selectedMonthRow = [_monthArray indexOfObject:_currentMonthString];
    _selectedDayRow = [_DaysArray indexOfObject:currentDateString];
    
    [self.datePicker reloadAllComponents];
//    NSString *dbTimeString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",currentyearString,_currentMonthString,currentDateString,currentHourString,currentMinutesString];
    NSString *dbTimeString = [NSString stringWithFormat:@"%@-%@-%@",currentyearString,_currentMonthString,currentDateString];
    _dateTimePreLabel.text = [NSString stringWithFormat:@"%@%@",NHDatePickerPrePlaceHolder,dbTimeString];
}

-(void)handlePickerSelectBlock:(NHDatePickerBlock)aBlock
{
    _resultBlock = [aBlock copy];
}

-(void)showInView:(UIView *)view
{
    _viewToShowIn = view;
    
    CGRect viewRect = self.frame;
    CGRect mainScreenRect_ = [[UIScreen mainScreen] bounds];
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -viewRect.size.height);
    _backgroundControl = [[UIControl alloc] initWithFrame:mainScreenRect_];
    [_backgroundControl setBackgroundColor:[UIColor clearColor]];
    [self.viewToShowIn addSubview:_backgroundControl];
    
    [self.viewToShowIn addSubview:self];
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)cancelSelectDatePicker
{
    CGRect viewRect = self.frame;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, viewRect.size.height);
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
            [_backgroundControl removeFromSuperview];
            if (_resultBlock){
                _resultBlock(YES,nil);
            }
        }
    }];
}

-(void)doneSelectedDatePicker {
    NSString *year = [_yearArray objectAtIndex:[self.datePicker selectedRowInComponent:0]];
    NSString *month = [_monthArray objectAtIndex:[self.datePicker selectedRowInComponent:1]];
    NSString *day = [_DaysArray objectAtIndex:[self.datePicker selectedRowInComponent:2]];
//    NSString *hour = [_hoursArray objectAtIndex:[self.datePicker selectedRowInComponent:3]];
//    NSString *minitute = [_minutesArray objectAtIndex:[self.datePicker selectedRowInComponent:4]];
    NSString *dbTimeString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    CGRect viewRect = self.frame;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, viewRect.size.height);
    [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
        self.transform = translate;
    } completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
            [_backgroundControl removeFromSuperview];
            if (_resultBlock){
                _resultBlock(NO,dbTimeString);
            }
        }
    }];
}

#pragma mark - UIPikerView Delegate && DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0){
        return [_yearArray count];
    }else if (component == 1){
        return [_monthArray count];
    }else if (component == 2){ // day
        if (_selectedMonthRow == 0 || _selectedMonthRow == 2 || _selectedMonthRow == 4 || _selectedMonthRow == 6 || _selectedMonthRow == 7 || _selectedMonthRow == 9 || _selectedMonthRow == 11){
            return 31;
        }else if (_selectedMonthRow == 1){
            int yearint = [[_yearArray objectAtIndex:_selectedYearRow]intValue ];
            
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                return 29;
            }else{
                return 28; // or return 29
            }
        }else{
            return 30;
        }
    }else if (component == 3){ // hour
        return 24;
    }else if (component == 4){ // min
        return 60;
    }else{ // am/pm
        return 2;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil){
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:NHFontTitleSize]];
    }
    if (component == 0){
        pickerLabel.text =  [_yearArray objectAtIndex:row]; // Year
    }else if (component == 1){
        pickerLabel.text =  [_monthArray objectAtIndex:row];  // Month
    }else if (component == 2){
        pickerLabel.text =  [_DaysArray objectAtIndex:row]; // Date
    }else if (component == 3){
        pickerLabel.text =  [_hoursArray objectAtIndex:row]; // Hours
    }else if (component == 4){
        pickerLabel.text =  [_minutesArray objectAtIndex:row]; // Mins
    }else{
        //pickerLabel.text =  [_amPmArray objectAtIndex:row]; // AM/PM
    }
    
    return pickerLabel;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0){
        _selectedYearRow = row;
        [self.datePicker reloadAllComponents];
    }else if (component == 1){
        _selectedMonthRow = row;
        [self.datePicker reloadAllComponents];
    }else if (component == 2){
        _selectedDayRow = row;
        [self.datePicker reloadAllComponents];
    }
    
    NSString *year = [_yearArray objectAtIndex:[self.datePicker selectedRowInComponent:0]];
    NSString *month = [_monthArray objectAtIndex:[self.datePicker selectedRowInComponent:1]];
    NSString *day = [_DaysArray objectAtIndex:[self.datePicker selectedRowInComponent:2]];
//    NSString *hour = [_hoursArray objectAtIndex:[self.datePicker selectedRowInComponent:3]];
//    NSString *minitute = [_minutesArray objectAtIndex:[self.datePicker selectedRowInComponent:4]];
    NSString *dbTimeString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    _dateTimePreLabel.text = [NSString stringWithFormat:@"%@%@",NHDatePickerPrePlaceHolder,dbTimeString];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
