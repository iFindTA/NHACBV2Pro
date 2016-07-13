//
//  NHDatePicker.h
//  LFStreetLifeProject
//
//  Created by hu jiaju on 14-7-4.
//  Copyright (c) 2014年 Linfang. All rights reserved.
//
typedef void(^NHDatePickerBlock)(BOOL cancel,NSString *dateString);

#import <UIKit/UIKit.h>

@interface NHDatePicker : UIView

-(void)handlePickerSelectBlock:(NHDatePickerBlock)aBlock;
-(void)showInView:(UIView *)view;

@end
