//
//  NHActivityManualAlerter.h
//  NHACBPro
//
//  Created by hu jiaju on 16/7/4.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseWinViewController.h"

typedef void(^NHManualAlertEvent)(BOOL success);

@interface NHActivityManualAlerter : NHBaseWinViewController

- (void)handleActivityManualAlertEvent:(NHManualAlertEvent)event;

@end
