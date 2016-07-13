//
//  NHActivityCell.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHTagsLabel.h"

@class NHActivityCell;
typedef void(^NHActivityEvent)(NHActivityCell * cl, NSUInteger idx);

@interface NHActivityCell : UITableViewCell

/**
 *  @brief caculate the height
 *
 *  @param aDic the info
 *
 *  @return the height
 */
+ (CGFloat)heightForInfo:(NSDictionary *)aDic;

/**
 *  @brief custom the cell's subviews
 *
 *  @param aDic the info
 */
- (void)setupForInfo:(NSDictionary *)aDic;

/**
 *  @brief extend method for generate activity
 *
 *  @param aDic the activity info
 *
 *  @return the activity control
 */
- (UIControl *)assembleActivityInfo:(NSDictionary *)aDic;
- (UIControl *)assembleAccessableActivityInfo:(NSDictionary *)aDic lineHead:(BOOL)head;

/**
 *  @brief activity touch event
 *
 *  @param event the event
 */
- (void)handleActivityTouchEvent:(NHActivityEvent)event;

@end
