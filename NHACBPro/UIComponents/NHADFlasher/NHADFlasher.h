//
//  NHADFlasher.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NHADEvent)(BOOL touched);

@interface NHADFlasher : UIViewController

/**
 *  @brief show the ad flash view
 *
 *  @param ad       the info
 *  @param event    the event
 *
 */
+ (void)makeKeyAndVisible:(NSDictionary *)ad withEvent:(NHADEvent)event;

@end

NS_ASSUME_NONNULL_END
