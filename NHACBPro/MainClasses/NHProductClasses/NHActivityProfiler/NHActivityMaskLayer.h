//
//  NHActivityMaskLayer.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/8.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHBaseViewController.h"

typedef void(^NHRecordEvent)(CGFloat amount, NSString *date, NSString *way);

typedef enum {
    NHMaskTypeInitAlert             =       1 << 0,
    NHMaskTypeInputMode             =       1 << 1
}NHMaskType;

@interface NHActivityMaskLayer : NHBaseViewController

- (id)initWithType:(NHMaskType)type;

- (void)handleRecordEvent:(NHRecordEvent)event;

- (void)show;

@end
