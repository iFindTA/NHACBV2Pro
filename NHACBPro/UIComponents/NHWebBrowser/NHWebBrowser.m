//
//  NHWebBrowser.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/6.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHWebBrowser.h"
#import "TUSafariActivity.h"
#import "NHAFEngine.h"

static void *NHWebBrowserContext = &NHWebBrowserContext;

@interface NHWebBrowser ()<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

@property (nonatomic, strong) WKWebView *kitWebber;
@property (nonatomic, strong) UIWebView *kitWapper;
@property (nonatomic, assign) BOOL wapperISLoading;
@property (nonatomic, strong) NSURL *sourceURL;

@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;
@property (nonatomic, assign) BOOL previousNavigationControllerNavigationBarHidden;
// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *closeBarItem;

@end

static BOOL isWKEnabled(){
    return [WKWebView class] != nil;
}

@implementation NHWebBrowser

+ (NHWebBrowser *)browser {
    return [NHWebBrowser browserWithConfiguration:nil];
}

+ (NHWebBrowser *)browserWithConfiguration:(WKWebViewConfiguration *)conf {
    NHWebBrowser *browser = [[NHWebBrowser alloc] initWithConfiguration:conf];
    return browser;
}

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self) {
        if(isWKEnabled()) {
            if(configuration) {
                self.kitWebber = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
            }
            else {
                self.kitWebber = [[WKWebView alloc] init];
            }
        }
        else {
            self.kitWapper = [[UIWebView alloc] init];
        }
//        
//        self.actionButtonHidden = NO;
//        self.showsURLInNavigationBar = NO;
//        self.showsPageTitleInNavigationBar = YES;
        
        //self.externalAppPermissionAlertView = [[UIAlertView alloc] initWithTitle:@"Leave this app?" message:@"This web page is trying to open an outside app. Are you sure you want to open it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open App", nil];
        
    }
    return self;
}

- (void)dealloc {
    [self.kitWapper setDelegate:nil];
    
    [self.kitWebber setNavigationDelegate:nil];
    [self.kitWebber setUIDelegate:nil];
    if ([self isViewLoaded]) {
        [self.kitWebber removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.previousNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
    //left
    CGFloat sapce_width = 16;
    CGFloat item_width = 31;
    UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpacer.width = -sapce_width;
    CGRect bounds = (CGRect){.origin = CGPointZero,.size = {item_width, item_width}};
    UIImage *back_img = [self backBarImage];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setBackgroundImage:back_img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backActionEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(closeActionEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[barSpacer, menuBar, barSpacer, closeBar];
    self.closeBarItem = btn;
    //right
//    UIImage *img = [self moreBarImage];
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = bounds;
//    [btn setBackgroundImage:img forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(moreActionEvent) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *moreBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItems = @[barSpacer, moreBar];
    
    //subviews
    if(self.kitWebber) {
        [self.kitWebber setFrame:self.view.bounds];
        [self.kitWebber setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.kitWebber setNavigationDelegate:self];
        [self.kitWebber setUIDelegate:self];
        [self.kitWebber setMultipleTouchEnabled:YES];
        [self.kitWebber setAutoresizesSubviews:YES];
        [self.kitWebber.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.kitWebber];
        
        [self.kitWebber addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:NHWebBrowserContext];
    }
    else if(self.kitWapper) {
        [self.kitWapper setFrame:self.view.bounds];
        [self.kitWapper setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.kitWapper setDataDetectorTypes:UIDataDetectorTypeAll];
        [self.kitWapper setDelegate:self];
        [self.kitWapper setMultipleTouchEnabled:YES];
        [self.kitWapper setAutoresizesSubviews:YES];
        [self.kitWapper setScalesPageToFit:YES];
        [self.kitWapper.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.kitWapper];
    }
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    UIColor *trackColor = [UIColor colorWithRed:112/255.f green:181/255.f blue:92/255.f alpha:1];
    [self.progressView setProgressTintColor:trackColor];
    [self.progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-self.progressView.frame.size.height, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    [self updateNaviBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.previousNavigationControllerNavigationBarHidden animated:animated];
    [self.kitWapper setDelegate:nil];
    [self.progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- setters

- (void)setShowMoreAction:(BOOL)showMoreAction {
    _showMoreAction = showMoreAction;
    if (showMoreAction) {
        CGFloat sapce_width = 16;
        CGFloat item_width = 31;
        UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        barSpacer.width = -sapce_width;
        //right
        CGRect bounds = (CGRect){.origin = CGPointZero,.size = {item_width, item_width}};
        UIImage *img = [self moreBarImage];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreActionEvent) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *moreBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItems = @[barSpacer, moreBar];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
}

#pragma mark - Helpers

- (UIImage *)backBarImage {
    static UIImage *image;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        CGFloat width = 31;
        CGFloat cap = 4;
        CGFloat r = (width-cap *2)/2;
        CGFloat off = (width-r)/2;
        CGPoint p1 = CGPointMake(off+r, cap);
        CGPoint p2 = CGPointMake(off, cap+r);
        CGPoint p3 = CGPointMake(off+r, width-cap);
        CGSize size = CGSizeMake(width, width);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.5;
        path.lineCapStyle = kCGLineCapButt;
        path.lineJoinStyle = kCGLineJoinMiter;
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [[UIColor whiteColor] setStroke];
        [path stroke];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return image;
}

- (UIImage *)moreBarImage {
    static UIImage *image;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        UIImage *backButtonImage = [self backBarImage];
        
        CGSize size = backButtonImage.size;
        CGFloat r = size.width / 12;
        CGFloat center_y = size.height * 0.5;
        CGFloat center_x_1 = r * 2;
        CGFloat center_x_2 = r * 6;
        CGFloat center_x_3 = r * 10;
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(center_x_1, center_y) radius:r startAngle:0 endAngle:M_PI * 2 clockwise:true];
        [path addArcWithCenter:CGPointMake(center_x_2, center_y) radius:r startAngle:0 endAngle:M_PI * 2 clockwise:true];
        [path addArcWithCenter:CGPointMake(center_x_3, center_y) radius:r startAngle:0 endAngle:M_PI * 2 clockwise:true];
        [[UIColor whiteColor] setFill];
        [path fill];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return image;
}

#pragma mark -- Bar Actions --

- (void)popLayer {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)backActionEvent {
    if (isWKEnabled()) {
        BOOL back = self.kitWebber.canGoBack;
        if (back) {
            [self.kitWebber goBack];
        }else{
            [self popLayer];
        }
    }else{
        BOOL back = self.kitWapper.canGoBack;
        if (back) {
            [self.kitWapper goBack];
        }else{
            [self popLayer];
        }
    }
}

- (void)closeActionEvent {
    [self popLayer];
}

- (void)moreActionEvent {
    NSURL *URLForActivityItem;
    NSString *URLTitle;
    if(self.kitWebber) {
        URLForActivityItem = self.kitWebber.URL;
        URLTitle = self.kitWebber.title;
    }else if(self.kitWapper) {
        URLForActivityItem = self.kitWapper.request.URL;
        URLTitle = [self.kitWapper stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if (URLForActivityItem) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
            //ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
            
            NSMutableArray *activities = [[NSMutableArray alloc] init];
            [activities addObject:safariActivity];
            //[activities addObject:chromeActivity];
            if(self.customActivityItems != nil) {
                [activities addObjectsFromArray:self.customActivityItems];
            }
            
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[URLForActivityItem] applicationActivities:activities];
            
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//                if(self.actionPopoverController) {
//                    [self.actionPopoverController dismissPopoverAnimated:YES];
//                }
//                self.actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
//                [self.actionPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
            }
            else {
                [self presentViewController:controller animated:YES completion:NULL];
            }
        });
    }
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.kitWebber) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.kitWebber.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.kitWebber.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.kitWebber.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateNaviBarState {
    if(self.kitWebber) {
        self.navigationItem.title = self.kitWebber.title;
        self.closeBarItem.hidden = !self.kitWebber.canGoBack;
    }else if(self.kitWapper) {
        self.navigationItem.title = [self.kitWapper stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.closeBarItem.hidden = !self.kitWapper.canGoBack;
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.kitWapper isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark -- Load

- (void)loadRequest:(NSURLRequest *)request {
    if(self.kitWebber) {
        [self.kitWebber loadRequest:request];
    }else if(self.kitWapper) {
        [self.kitWapper loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    NSAssert(URL != nil, @"source url can not be nil!");
    self.sourceURL = [URL copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.sourceURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [self loadRequest:request];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    if(self.kitWebber) {
        [self.kitWebber loadHTMLString:HTMLString baseURL:nil];
    }else if(self.kitWapper) {
        [self.kitWapper loadHTMLString:HTMLString baseURL:nil];
    }
}

#pragma mark - External App Support

- (BOOL)allowExternHost:(NSString *)host {
    if (self.externHosts) {
        __block BOOL allowed = false;
        @synchronized (self.externHosts) {
            [self.externHosts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([host isEqualToString:obj]||
                    [host rangeOfString:obj].location != NSNotFound) {
                    allowed = true;
                    *stop = true;
                }
            }];
        }
        return allowed;
    }
    return true;
}

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    [[UIApplication sharedApplication] openURL:URL];
}

#pragma mark Run JavaScripts 

- (void)runExternJavaScripts {
    
    if (self.externJavaScripts != nil) {
        NSString *destURL = (self.kitWebber==nil)?self.kitWapper.request.URL.absoluteString:self.kitWebber.URL.absoluteString;
        [self.externJavaScripts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *idfier = [obj objectForKey:@"idfier"];
            if ([destURL rangeOfString:idfier].location != NSNotFound) {
                NSString *jsCodes = [obj objectForKey:@"js"];
                if (self.kitWebber != nil) {
                    [self.kitWebber evaluateJavaScript:jsCodes completionHandler:^(id _Nullable ct, NSError * _Nullable error) {
                        NSLog(@"error:%@",error.localizedDescription);
                        if (!error) {
                            NSLog(@"evaluate:%@",PBFormat(@"%@",ct));
                        }
                    }];
                }else{
                    [self.kitWapper stringByEvaluatingJavaScriptFromString:jsCodes];
                }
            }
        }];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView == self.kitWapper) {
        
        if(![self externalAppRequiredToOpenURL:request.URL]) {
            self.uiWebViewCurrentURL = request.URL;
            self.wapperISLoading = YES;
            [self updateNaviBarState];
            
            [self fakeProgressViewStartLoading];
            NSString *tmpHost = [NHAFEngine share].baseURL.host;
            if (![request.URL.host containsString:tmpHost] && ![self allowExternHost:request.URL.host]) {
                NSLog(@"app 即将产生跨域访问!");
                [self launchExternalAppWithURL:request.URL];
                return false;
            }
//            if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
//                [self.delegate webBrowser:self didStartLoadingURL:request.URL];
//            }
            return YES;
        }
        else {
            [self launchExternalAppWithURL:request.URL];
            return NO;
        }
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView == self.kitWapper) {
        if(!self.kitWapper.isLoading) {
            self.wapperISLoading = NO;
            [self updateNaviBarState];
            
            [self fakeProgressBarStopLoading];
        }
        
        [self runExternJavaScripts];
//        if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
//            [self.delegate webBrowser:self didFinishLoadingURL:self.uiWebView.request.URL];
//        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView == self.kitWapper) {
        if(!self.kitWapper.isLoading) {
            self.wapperISLoading = NO;
            [self updateNaviBarState];
            
            [self fakeProgressBarStopLoading];
        }
//        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
//            [self.delegate webBrowser:self didFailToLoadURL:self.uiWebView.request.URL error:error];
//        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.kitWebber) {
        [self updateNaviBarState];
//        if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
//            [self.delegate webBrowser:self didStartLoadingURL:self.wkWebView.URL];
//        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.kitWebber) {
        [self updateNaviBarState];
//        if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
//            [self.delegate webBrowser:self didFinishLoadingURL:self.wkWebView.URL];
//        }
    }
    [self runExternJavaScripts];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.kitWebber) {
        [self updateNaviBarState];
//        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
//            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
//        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.kitWebber) {
        [self updateNaviBarState];
//        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
//            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
//        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView == self.kitWebber) {
        
        NSURL *URL = navigationAction.request.URL;
        if(![self externalAppRequiredToOpenURL:URL]) {
            if(!navigationAction.targetFrame) {
                [self loadURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            NSString *tmpHost = [NHAFEngine share].baseURL.host;
            if (![URL.host containsString:tmpHost] && ![self allowExternHost:URL.host]) {
                NSLog(@"app 即将产生跨域访问!");
                [self launchExternalAppWithURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }else if([[UIApplication sharedApplication] canOpenURL:URL]) {
            [self launchExternalAppWithURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark -- WKWebView cookies

- (void)configure {
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: @"document.cookie ='TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2';"injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    [userContentController addUserScript:cookieScript];
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;
}


@end
