//
//  NHFinanceManualRecorder.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/21.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NHManualTypeInit                    =       1 << 0,
    NHManualTypeModify                  =       1 << 1
} NHManualType;

typedef void(^NHManualRecordEvent)(BOOL success, id recorder);

@interface NHFinanceManualRecorder : NHBaseViewController

- (id)initWithType:(NHManualType)type withInfo:(nullable NSDictionary *)aDict;

- (void)handleManualRecordEditOrAddEvent:(NHManualRecordEvent)event;

NS_ASSUME_NONNULL_END

@end
