//
//  NHUserProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"
#import "NHUserProfilerDelegate.h"

@interface NHUserProfiler : NHBaseViewController

@property (nonatomic, weak) id<NHUserProfilerDelegate> delegate;

@end

