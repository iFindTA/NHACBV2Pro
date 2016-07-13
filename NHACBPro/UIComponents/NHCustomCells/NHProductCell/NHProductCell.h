//
//  NHProductCell.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NHProductModel;
@interface NHProductCell : UITableViewCell

@end


#pragma mark -- cell model --

typedef enum {
    NHCellExpandStateClose      =       1 << 0,
    NHCellExpandStateOpen       =       1 << 1
}NHCellExpandState;

#import <MJExtension.h>

@interface NHProductModel :NSObject

//banner or 产品
@property (nonatomic, strong) NSNumber *type;

/**
 *  @brief 缓存行高
 *
 *  @param state 展开、关闭
 *
 *  @return 行高
 */
- (CGFloat)heightForState:(NHCellExpandState)state;

@end