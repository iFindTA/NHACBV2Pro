//
//  NHUserProfilerDelegate.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#ifndef NHUserProfilerDelegate_h
#define NHUserProfilerDelegate_h

@class NHUserProfiler;
@protocol NHUserProfilerDelegate <NSObject>

- (void)userProfiler:(NHUserProfiler *)profiler didToggleClass:(NSString *)aClass;

@end

#endif /* NHUserProfilerDelegate_h */
