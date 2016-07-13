//
//  NHNicker.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHNickerEvent)(NSString *nick, BOOL success);

@interface NHNicker : NHBaseViewController

/**
 *  @brief modify usr's nick
 *
 *  @param event the nick event
 */
- (void)handleNickerEvent:(NHNickerEvent)event;

@end
