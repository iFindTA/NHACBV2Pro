//
//  NHCountingHUD.h
//  NHBeizerViewPro
//
//  Created by hu jiaju on 16/5/26.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NHCountingEvent)();

struct NHColorBox{
    unsigned long               bgColor;//background color
    unsigned long               bdColor;//border color
    float                       duration;//time interval
    const char * _Nonnull       info;
};

typedef struct NHColorBox NHColorBox;

NS_ASSUME_NONNULL_BEGIN

@interface NHCountingHUD : UIControl

- (id)initWithFrame:(CGRect)frame withColorBox:(NHColorBox)box;

- (void)handleCountingEvent:(NHCountingEvent)event;

NS_ASSUME_NONNULL_END

@end