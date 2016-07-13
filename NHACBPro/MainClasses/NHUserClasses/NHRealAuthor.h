//
//  NHRealAuthor.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHRealAuthorEvent)(NSString *name, BOOL success);

@interface NHRealAuthor : NHBaseViewController

/**
 *  @brief the real name authority method
 *
 *  @param event the event
 */
- (void)handleUsrRealAuthorEvent:(NHRealAuthorEvent)event;

@end
