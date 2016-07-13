//
//  NHUserGuider.h
//  NHACBPro
//
//  Created by hu jiaju on 16/7/1.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

@class NHUserGuider;
typedef void(^NHUsrGuideEvent)(NHUserGuider *guider, BOOL success);

@interface NHUserGuider : NHBaseViewController

- (void)handleUserGuiderEnJoyEvent:(NHUsrGuideEvent)event;

@end
