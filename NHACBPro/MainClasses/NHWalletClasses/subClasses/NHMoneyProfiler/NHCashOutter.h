//
//  NHCashOutter.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHCashOutterEvent)(CGFloat cash, BOOL success);

@interface NHCashOutter : NHBaseViewController

- (void)handleCashOutterEvent:(NHCashOutterEvent)event;

@end
