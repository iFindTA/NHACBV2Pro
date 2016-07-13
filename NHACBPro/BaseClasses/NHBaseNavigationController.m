//
//  NHBaseNavigationController.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/30.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseNavigationController.h"
#import "SWRevealViewController.h"

@interface NHBaseNavigationController() <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation NHBaseNavigationController

- (void)viewDidLoad {
    __weak NHBaseNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    //remove seperate black line
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

// Hijack the push method to disable the gesture

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = true;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //NSLog(@"did show vcr");
        NSArray *tmpStacks = [navigationController viewControllers];
        BOOL should = tmpStacks.count == 1;
        self.revealViewController.panGestureRecognizer.enabled = should;
        self.interactivePopGestureRecognizer.enabled = !should;
    }
}

@end
