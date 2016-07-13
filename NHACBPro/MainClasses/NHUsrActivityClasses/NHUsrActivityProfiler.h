//
//  NHUsrActivityProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/14.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NHUsrActivityTypeMine                       =       1 << 0,
    NHUsrActivityTypeFriend                     =       1 << 1
}NHUsrActivityType;

@interface NHUsrActivityProfiler : NHBaseViewController

/**
 *  @brief init method for create instance
 *
 *  @param type page type
 *
 *  @return the instance
 */
- (id)initWithUsrActivityType:(NHUsrActivityType)type;

/**
 *  @brief the activities's owner
 */
@property (nonatomic, strong) NSDictionary *usrInfo;

NS_ASSUME_NONNULL_END

@end
