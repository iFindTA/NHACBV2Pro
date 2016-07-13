//
//  NHWebBrowser.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/6.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHWebBrowser : UIViewController

/**
 *  @brief class method to create instance
 *
 *  @return the instance of web
 */
+ (NHWebBrowser *)browser;

/**
 *  @brief class method to create instance
 *
 *  @param conf the web's configue
 *
 *  @return the instance of web
 */
+ (NHWebBrowser *)browserWithConfiguration:(WKWebViewConfiguration * _Nullable)conf NS_AVAILABLE_IOS(8);

// wether show or hide the right naviBar item
@property (nonatomic, assign) BOOL showMoreAction;

//Allow for custom activities in the browser by populating this optional array
@property (nonatomic, strong) NSArray *customActivityItems;

//Allowed access site's hosts
@property (nonatomic, strong, nullable) NSArray *externHosts;

//allowed run JavaScripts {idfier:'some thing',js:'js code here'}
@property (nonatomic, strong, nullable) NSArray *externJavaScripts;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;
// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;

NS_ASSUME_NONNULL_END

@end
