//
//  NHGoldenConverter.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

typedef void(^NHConvertGoldenEvent)(NSInteger amount, BOOL success);

@interface NHGoldenConverter : NHBaseViewController

- (void)handleConvertGoldenEvent:(NHConvertGoldenEvent)event;

@end
