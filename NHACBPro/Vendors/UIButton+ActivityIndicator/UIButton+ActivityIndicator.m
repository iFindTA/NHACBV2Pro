//
//  UIButton+ActivityIndicator.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/20.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "UIButton+ActivityIndicator.h"
#import <objc/runtime.h>

static char kActivityIndicatorKey;
static char  kWorkingKey;

@implementation UIButton (ActivityIndicator)
@dynamic activityIndicator;
@dynamic working;

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &kActivityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicator {
    return objc_getAssociatedObject(self, &kActivityIndicatorKey);
}

- (void)setWorking:(BOOL)working {
    objc_setAssociatedObject(self, &kWorkingKey, [NSNumber numberWithBool:working], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (working) {
        if (self.activityIndicator == nil) {
            self.activityIndicator = ({
                UIActivityIndicatorView *activitor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activitor.hidesWhenStopped = true;
                [self addSubview:activitor];
                activitor.translatesAutoresizingMaskIntoConstraints = false;
                // add constraints
                [self addConstraint:[NSLayoutConstraint constraintWithItem:activitor
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:activitor
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1
                                                              constant:0]];
                activitor;
            });
        }
        self.enabled = false;
        self.titleLabel.hidden = true;
        [self.activityIndicator startAnimating];
    }else{
        self.enabled = true;
        self.titleLabel.hidden = false;
        [self.activityIndicator stopAnimating];
    }
}

- (BOOL)isWorking {
    NSNumber *tmp = objc_getAssociatedObject(self, &kWorkingKey);
    return tmp.boolValue;
}

@end
