//
//  NHConditionPicker.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/9.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NHConditionEvent)(BOOL cancel, NSString *info);

@interface NHConditionPicker : UIView

@property (nonatomic, strong) NSArray *dataSource;

-(void)handlePickerSelectBlock:(NHConditionEvent)aBlock;
-(void)showInView:(UIView *)view;

@end
