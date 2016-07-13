//
//  AppDelegate.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NHUserProfiler.h"
#import "NHDBEngine.h"
#import "NHADFlasher.h"
#import "NHBaseNavigationController.h"
#import "SWRevealViewController.h"
#import "JASidePanelController.h"
#import "WXApi.h"
#import "NHUserGuider.h"

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NHDBEngine share] setup];
    
    [[NHAFEngine share] setup];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //set navigationBar's
    //[[UINavigationBar appearance] setTranslucent:false];
    [[UINavigationBar appearance] setBarTintColor:[UIColor pb_colorWithHexString:PBFormat(@"%s",NH_NAVIBAR_TINTCOLOR)]];
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont pb_navigationTitle]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:mainBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vcr = [[ViewController alloc] init];
    NHBaseNavigationController *navi = [[NHBaseNavigationController alloc] initWithRootViewController:vcr];
    navi.navigationBar.translucent = false;
    NHUserProfiler *userProfiler = [[NHUserProfiler alloc] init];
    userProfiler.delegate = vcr;
    UIViewController *mRootController = nil;
#if NH_USE_SWREVAL_FRAMEWORK
    //SWReval
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:userProfiler frontViewController:navi];
    revealController.delegate = self;
    mRootController = revealController;
#else
    //JASidePanel
    JASidePanelController *sidePanelController = [[JASidePanelController alloc] init];
    sidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    sidePanelController.leftPanel = userProfiler;
    sidePanelController.centerPanel = navi;
    mRootController = sidePanelController;
#endif
    NHConfigure *mConig = [[NHDBEngine share] globalConfig];
    if (!mConig.guideFlashed.boolValue) {
        PBBACK(^{[[NHDBEngine share] syncronizedConfigUsrGuideFlashed:true];});
        //TODO:test for user guide
        NHUserGuider *usrguider = [[NHUserGuider alloc] init];
        weakify(self)
        [usrguider handleUserGuiderEnJoyEvent:^(NHUserGuider *guider, BOOL success) {
            if (success) {
                strongify(self)
                [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
                    guider.view.alpha = 0.01;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:PBANIMATE_DURATION animations:^{
                            self.window.rootViewController = mRootController;
                            [self.window makeKeyAndVisible];
                        }];
                    }
                }];
            }
        }];
        self.window.rootViewController = usrguider;
        [self.window makeKeyAndVisible];
    }else{
        self.window.rootViewController = mRootController;
        NSDictionary *adFlash = [[NHDBEngine share] shouldFlashAD];
        if (adFlash != nil) {
            weakify(self)
            [NHADFlasher makeKeyAndVisible:adFlash withEvent:^(BOOL touched) {
                [self.window makeKeyAndVisible];
                if (touched) {
                    strongify(self)
                    [self handleADTouchEvent:adFlash];
                }
            }];
        }else{
            [self.window makeKeyAndVisible];
        }
    }
    
    [WXApi registerApp:@"wxb843c8a8cb7df630"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //clear the pastebpard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL isSuc = [WXApi handleOpenURL:url delegate:nil];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark -- 检测事件

static void listenMainThreadIdleState() {
    id handler = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                // About to enter the processing loop. Happens
                // once per `CFRunLoopRun` or `CFRunLoopRunInMode` call
                break;
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopBeforeSources:
                // Happens before timers or sources are about to be handled
                break;
            case kCFRunLoopBeforeWaiting:
                // All timers and sources are handled and loop is about to go
                // to sleep. This is most likely what you are looking for :)
                NSLog(@"main runloop about to sleep");
                break;
            case kCFRunLoopAfterWaiting:
                // About to process a timer or source
                NSLog(@"main runloop about to process");
                break;
            case kCFRunLoopExit:
                // The `CFRunLoopRun` or `CFRunLoopRunInMode` call is about to
                // return
                NSLog(@"main runloop about to exit");
                break;
                
            default:
                break;
        }
    };
    CFRunLoopObserverRef obs = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, handler);
    CFRunLoopAddObserver([NSRunLoop mainRunLoop].getCFRunLoop, obs, kCFRunLoopCommonModes);
    CFRelease(obs);
}

#pragma mark -- 广告点击处理事件

- (void)handleADTouchEvent:(NSDictionary *)info {
    NSLog(@"//TODO:处理广告点击事件");
    
}

@end
