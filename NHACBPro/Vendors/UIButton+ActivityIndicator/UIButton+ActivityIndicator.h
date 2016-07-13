//
//  UIButton+ActivityIndicator.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/20.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ActivityIndicator)

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign, getter=isWorking) BOOL working;

@end
