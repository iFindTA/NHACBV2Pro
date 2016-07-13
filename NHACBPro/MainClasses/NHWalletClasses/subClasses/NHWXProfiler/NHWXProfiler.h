//
//  NHWXProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHBindWXEvent)(BOOL success, NSString *wx);

@interface NHWXProfiler : NHBaseViewController

- (void)handleBindpublicWXEvent:(NHBindWXEvent)event;

@end
