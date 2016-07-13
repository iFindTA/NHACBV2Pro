//
//  NHPlatformPicker.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/21.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHPlatformEvent)(BOOL success, NSString *plat);

@interface NHPlatformPicker : NHBaseViewController

- (id)initWithDefaultPlatform:(nullable NSString *)plat;

- (void)handlePlatformSelectedEvent:(NHPlatformEvent)event;

@end
