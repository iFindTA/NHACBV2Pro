//
//  NHLoginProfiler.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"

@interface NHLoginProfiler : NHBaseViewController

/**
 *  @brief the class that should pop to when user logined!
 */
@property (nonatomic, strong, nullable) Class aBackClass;

/**
 *  @brief the class that should replace login vcr when user logined!
 */
@property (nonatomic, strong, nullable) Class aReplaceClass;

@end
