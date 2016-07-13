//
//  NHBaseViewController.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/27.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBaseViewController.h"
#import "SWRevealViewController.h"

@interface NHBaseViewController ()

@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, assign) NHViewErrorType errorType;

@end

@implementation NHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:true];
}

#pragma mark -- UIBarButtonItem --

- (UIBarButtonItem *)barSpacer {
    UIBarButtonItem *barSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpacer.width = -NH_BOUNDARY_OFFSET;
    return barSpacer;
}

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    UIColor *color = [UIColor pb_colorWithHexString:@"#FFFFFF"];
    return [self barWithIcon:icon withColor:color withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withColor:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    return [self barWithIcon:icon withSize:31 withColor:color withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithIcon:(NSString *)icon withSize:(NSInteger)size withColor:(UIColor *)color withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    UIImage *bar_img = [UIImage pb_iconFont:nil withName:icon withSize:size withColor:color];
    return [self assembleBar:bar_img withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithImage:(UIImage *)icon withTarget:(id)target withSelector:(SEL)selector {
    return [self barWithImage:icon withColor:nil withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)barWithImage:(UIImage *)icon withColor:(UIColor *)color withTarget:(id)target withSelector:(SEL)selector {
    if (color != nil) {
        icon = [icon pb_darkColor:color lightLevel:1];
    }
    return [self assembleBar:icon withTarget:target withSelector:selector];
}

- (UIBarButtonItem *)assembleBar:(UIImage *)icon withTarget:(id)target withSelector:(SEL)selector {
    
    CGSize m_bar_size = {31, 31};
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
//    menu.backgroundColor = [UIColor blueColor];
    menu.frame = (CGRect){.origin = CGPointZero,.size = m_bar_size};
    [menu setImage:icon forState:UIControlStateNormal];
//    [menu setBackgroundImage:icon forState:UIControlStateNormal];
    [menu addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:menu];
    return bar;
}

- (void)popUpLayer {
    [self.navigationController popViewControllerAnimated:true];
    //TODO:auto check self is pushed or presented!
}

- (void)alertORActionSheet {
    
    DQAlertView *alert = [[DQAlertView alloc] initWithTitle:PBLocalized(@"kalert") message:@"此操作需要授权登录." cancelButtonTitle:PBLocalized(@"kcancel") otherButtonTitle:@"授权"];
    //    alert.cancelButtonAction = ^ {
    //
    //    };
    //    alert.otherButtonAction = ^ {
    //
    //    };
    [alert actionWithBlocksCancelButtonHandler:^{
        
    } otherButtonHandler:^{
        
    }];
    [alert show];
    
    JGActionSheetSection *s_u = [JGActionSheetSection sectionWithTitle:PBLocalized(@"kalert") message:@"此操作需要您的授权登录." buttonTitles:@[@"授权"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *s_d = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[PBLocalized(@"kcancel")] buttonStyle:JGActionSheetButtonStyleCancel];
    __block JGActionSheet *actionSheet = [JGActionSheet actionSheetWithSections:@[s_u,s_d]];
    [actionSheet setButtonPressedBlock:^(JGActionSheet *s, NSIndexPath *d) {
        [s dismissAnimated:true];
    }];
    [actionSheet showInView:self.view animated:true];
}

#pragma mark -- error handler -- 

- (UIView *)generateErrorViewByType:(NHViewErrorType)type {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    bounds = CGRectZero;
    UIView *tmp = [[UIView alloc] initWithFrame:bounds];
    tmp.backgroundColor = [UIColor whiteColor];
    NSString *alertInfo;
    if (type == NHViewErrorType404) {
        alertInfo = @"未找到相关资源";
    }else if (type == NHViewErrorTypeNetwork){
        alertInfo = @"网络不佳，点击重试！";
    }else if (type == NHViewErrorTypeEmpty){
        alertInfo = @"暂无任何数据！";
    }
    UIFont *font = PBSysBoldFont(NHFontTitleSize*1.5);
    UILabel *label = [[UILabel alloc] init];
    //label.backgroundColor = [UIColor lightGrayColor];
    label.font = font;
    label.userInteractionEnabled = true;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = alertInfo;
    [tmp addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tmp);
    }];
    
    //[tmp layoutIfNeeded];
    return tmp;
}

- (void)showErrorType:(NHViewErrorType)type inView:(UIView *)superview layoutMargin:(UIView *)layout withTarget:(nullable id)target withSelector:(SEL)selector {
    [self removeErrorAlertView];
    if (superview && layout && NHViewErrorTypeNone != type) {
        self.errorType = type;
        UIView *tmp = [self generateErrorViewByType:type];
        [superview addSubview:tmp];
        self.errorView = tmp;
        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(layout);
        }];
        if (target && selector) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [tmp addGestureRecognizer:tap];
        }
    }
}

- (UIView *)errorViewWithType:(NHViewErrorType)type withTarget:(nullable id)target withSelector:(nullable SEL)selector{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIView *tmp = [[UIView alloc] initWithFrame:bounds];
    tmp.backgroundColor = [UIColor lightGrayColor];
    NSString *alertInfo;
    if (type == NHViewErrorType404) {
        alertInfo = @"未找到相关资源";
    }else if (type == NHViewErrorTypeNetwork){
        alertInfo = @"网络不佳，点击屏幕重试！";
    }else if (type == NHViewErrorTypeEmpty){
        alertInfo = @"暂无任何数据！";
    }
    self.errorType = type;
    UIFont *font = PBSysBoldFont(NHFontTitleSize*1.5);
    UILabel *label = [[UILabel alloc] init];
    //label.backgroundColor = [UIColor blueColor];
    label.font = font;
    label.userInteractionEnabled = true;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = alertInfo;
    [tmp addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tmp);
    }];
    if (target && selector) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tmp addGestureRecognizer:tap];
    }
    //[tmp layoutIfNeeded];
    return tmp;
}

- (void)copyPointerErrorView:(UIView *)v {
    if (_errorView) {
        _errorView = nil;
    }
    self.errorView = v;
}

- (void)removeErrorAlertView {
    if (self.errorView) {
        [self.errorView removeFromSuperview];
        _errorView = nil;
    }
    self.errorType = NHViewErrorTypeNone;
}

- (void)showErrorType:(NHViewErrorType)type inContent:(UIView *)view {
    if (![self respondsToSelector:@selector(handleErrorType:)]) {
        NSLog(@"#warning:::must implement %@ method!!!",NSStringFromSelector(@selector(handleErrorType:)));
    }
    [self removeErrorAlertView];
    if (view && NHViewErrorTypeNone != type) {
        self.errorType = type;
        UIView *tmp = [self generateErrorViewByType:type];
        if ([view isKindOfClass:[UITableView class]] ||
            [view isMemberOfClass:[UITableView class]]) {
            //tableView can not auto resized subviews!
        }else{
            [view addSubview:tmp];
            [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view.mas_baseline);
            }];
        }
    }
}

- (void)errorViewAction {
    BOOL shouldRemove = false;
    if (self.errorType == NHViewErrorTypeNetwork) {
        if ([self respondsToSelector:@selector(handleErrorType:)]) {
            shouldRemove = true;
            [self handleErrorType:self.errorType];
        }else{
            NSLog(@"#warning:::must implement %@ method!!!",NSStringFromSelector(@selector(handleErrorType:)));
        }
    }
    
    if (shouldRemove) {
        [self removeErrorAlertView];
    }
}

#pragma mark -- usr authority alert 

- (BOOL)alertOnUsrAuthorizationStateWithEvent:(NHUsrAuthorityEvent)event {
    
    BOOL authoritied = true;
    if (![[NHDBEngine share] logined]) {
        authoritied = false;
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"当前登录状态已失效，请重新登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        weakify(self)
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"马上登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            strongify(self)
            self.view.userInteractionEnabled = false;
            UIAlertController *loginAlerter = [UIAlertController alertControllerWithTitle:@"快捷登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *realAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [loginAlerter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"输入手机号码";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            [loginAlerter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               textField.placeholder = @"输入6-16位密码";
                textField.secureTextEntry = true;
                textField.keyboardType = UIKeyboardTypeNamePhonePad;
            }];
            [loginAlerter addAction:cancelAction];
            [loginAlerter addAction:realAction];
            [self presentViewController:loginAlerter animated:true completion:nil];
            self.view.userInteractionEnabled = true;
        }];
        [alertCtr addAction:cancelAction];
        [alertCtr addAction:loginAction];
        [self presentViewController:alertCtr animated:true completion:nil];
        
        return authoritied;
    }
    
    return authoritied;
}

@end
