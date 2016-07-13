//
//  NHCommenter.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NHCommenterEvent)(NSString *info, BOOL cancel);

@interface NHCommenter : UIView

- (id)initWithPlaceHolder:(NSString *)holder;

- (void)handleCommenterEvent:(NHCommenterEvent)event;

- (void)showInView:(UIView *)view;

@end
