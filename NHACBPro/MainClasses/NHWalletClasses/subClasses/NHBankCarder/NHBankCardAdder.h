//
//  NHBankCardAdder.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHBankCardAddEvent)(NSDictionary *card, BOOL success);

@interface NHBankCardAdder : NHBaseViewController

- (void)handleBankCardAddEvent:(NHBankCardAddEvent)event;

@end
