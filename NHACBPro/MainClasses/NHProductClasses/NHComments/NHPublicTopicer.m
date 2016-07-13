//
//  NHPublicTopicer.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHPublicTopicer.h"
#import "UITextView+Placeholder.h"
#import "DoImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface NHPublicTopicer ()<UITextViewDelegate, DoImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *content_tvw;
@property (nonatomic, strong) UIButton *addImgBtn;
@property (nonatomic, strong) UIView *imgBg;
@property (nonatomic, strong) NSMutableArray *imageAssets;

@end

@implementation NHPublicTopicer

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"创建内容";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
    public.frame = CGRectMake(0, 0, 50, 31);
    public.titleLabel.font = PBSysFont(NHFontSubSize);
    [public setTitle:@"发布" forState:UIControlStateNormal];
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [public addTarget:self action:@selector(publishTopicEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pubBar = [[UIBarButtonItem alloc] initWithCustomView:public];
    self.navigationItem.rightBarButtonItems = @[spacer,pubBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.content_tvw) {
        [self buildSubviews];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)imageAssets {
    if (!_imageAssets) {
        _imageAssets = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageAssets;
}

static const int tvw_height     =       110;
static const int max_img_count  =       9;
static const int max_len = 300;

- (void)buildSubviews {
    
    weakify(self)
    UIColor *color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIColor *placeColor = [UIColor colorWithRed:209/255.f green:210/255.f blue:213/255.f alpha:1];
    UITextView *tvw = [[UITextView alloc] init];
    tvw.delegate = self;
    tvw.keyboardType = UIKeyboardTypeNamePhonePad;
    tvw.font = PBSysFont(NHFontSubSize);
    tvw.textColor = color;
    tvw.placeholderColor = placeColor;
    tvw.placeholder = @"说点什么...";
    [self.view addSubview:tvw];
    self.content_tvw = tvw;
    [tvw mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.left.equalTo(self.view).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.view).offset(-NH_CONTENT_MARGIN);
        make.height.equalTo(@(tvw_height));
    }];
    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bgView];
    self.imgBg = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(tvw.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.right.equalTo(self.view);
    }];
    //btn
    CGFloat add_btn_size = ((PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*4)/3);
    UIImage *img = [UIImage pb_iconFont:nil withName:@"\U0000e614" withSize:add_btn_size*PBSCREEN_SCALE withColor:placeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(addImageEvent) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:img forState:UIControlStateNormal];
    [bgView addSubview:btn];
    self.addImgBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(self.view).offset(NH_CONTENT_MARGIN);
        make.width.height.equalTo(@(add_btn_size));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn.mas_bottom).offset(NH_CONTENT_MARGIN);
    }];
}

#pragma mark -- Images Render

- (void)updateImageAssetsDisplay {
    
    [self.imgBg.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]] && obj.tag >= 1000) {
            [obj removeFromSuperview];
        }
    }];
    
    CGFloat add_btn_size = ((PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*4)/3);
    int m_img_num_per_line = 3;
    CGFloat m_img_size = add_btn_size;
    __block UIButton *last_btn = nil;
    __block NSUInteger line_row_idx = 0;
    __block NSUInteger last_line_row_idx = 0;
    weakify(self)
    [self.imageAssets enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        strongify(self)
        //行数 索引
        line_row_idx = idx / m_img_num_per_line;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+idx;
        [btn addTarget:self action:@selector(imageBrwoserAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imgBg addSubview:btn];
        [btn setImage:obj forState:UIControlStateNormal];
        weakify(self)
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo((last_btn==nil)?self.imgBg.mas_top:((line_row_idx==last_line_row_idx)?last_btn.mas_top:last_btn.mas_bottom)).offset((last_btn==nil)?0:((line_row_idx==last_line_row_idx)?0:NH_BOUNDARY_MARGIN));
            make.left.equalTo((last_btn==nil)?self.imgBg:(line_row_idx==last_line_row_idx)?(last_btn.mas_right):(self.imgBg)).offset(NH_BOUNDARY_MARGIN);
            make.width.height.equalTo(@(m_img_size));
        }];
        
        last_btn = btn;
        last_line_row_idx = line_row_idx;
    }];
    
    if (last_btn == nil) {
        self.addImgBtn.hidden = false;
        weakify(self)
        [self.addImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo(self.imgBg.mas_top);
            make.left.equalTo(self.view).offset(NH_CONTENT_MARGIN);
            make.width.height.equalTo(@(add_btn_size));
        }];
        
        last_btn = self.addImgBtn;
    }else if (self.imageAssets.count == max_img_count){
        self.addImgBtn.hidden = true;
        
        
    }else{
        BOOL is3Multiple = (self.imageAssets.count%3==0);
        self.addImgBtn.hidden = false;
        weakify(self)
        [self.addImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo((is3Multiple)?last_btn.mas_bottom:last_btn.mas_top).offset((is3Multiple)?NH_CONTENT_MARGIN:0);
            make.left.equalTo((is3Multiple)?self.view:last_btn.mas_right).offset(NH_CONTENT_MARGIN);
            make.width.height.equalTo(@(add_btn_size));
        }];
        
        
        last_btn = self.addImgBtn;
    }
    
    [self.imgBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content_tvw.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(last_btn.mas_bottom).offset(NH_CONTENT_MARGIN);
    }];
}

- (void)imageBrwoserAction:(UIButton *)btn {
    [self.view endEditing:true];
    
    NSUInteger __tag__ = btn.tag - 1000;
    JGActionSheetSection *s_u = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"删除"] buttonStyle:JGActionSheetButtonStyleRed];
    JGActionSheetSection *s_d = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[PBLocalized(@"kcancel")] buttonStyle:JGActionSheetButtonStyleCancel];
    __block JGActionSheet *actionSheet = [JGActionSheet actionSheetWithSections:@[s_u,s_d]];
    weakify(self)
    [actionSheet setButtonPressedBlock:^(JGActionSheet *s, NSIndexPath *d) {
        [s dismissAnimated:true];
        if (d.section == 0 && d.row == 0) {
            strongify(self)
            [self.imageAssets removeObjectAtIndex:__tag__];
            [self updateImageAssetsDisplay];
        }
    }];
    [actionSheet showInView:self.view animated:true];
}

- (void)addImageEvent {
    /*严格来说需要先判断设备是否支持 此处从简
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"支持相机");
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"支持图库");
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        NSLog(@"支持相片库");
    }
    //*/
    
    JGActionSheetSection *s_u = [JGActionSheetSection sectionWithTitle:PBLocalized(@"kalert") message:@"选取照片" buttonTitles:@[@"拍照",@"从相册选取"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *s_d = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[PBLocalized(@"kcancel")] buttonStyle:JGActionSheetButtonStyleCancel];
    __block JGActionSheet *actionSheet = [JGActionSheet actionSheetWithSections:@[s_u,s_d]];
    weakify(self)
    [actionSheet setButtonPressedBlock:^(JGActionSheet *s, NSIndexPath *d) {
        if (d.section == 0) {
            strongify(self)
            if (d.row == 0) {
                [self preQueryCameraAuthority];
            }else if (d.row == 1){
                [self preQueryAlbumAuthority];
            }
        }
        [s dismissAnimated:true];
    }];
    [actionSheet showInView:self.view animated:true];
}

#pragma mark -- 权限控制访问

- (void)preQueryAlbumAuthority {
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined){
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                //点击“好”回调方法:
                [self pickerImageFromAlbum];
                return;
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            //点击“不允许”回调方法:
            NSLog(@"用户拒绝访问相册");
            return ;
        }];
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
        [SVProgressHUD showErrorWithStatus:@"请在[设置]-[隐私]-[相机]中允许爱财帮访问"];
        return;
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized){
        [self pickerImageFromAlbum];
    }
}

- (void)preQueryCameraAuthority {
    AVAuthorizationStatus authStatu = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatu == AVAuthorizationStatusRestricted
        ||authStatu == AVAuthorizationStatusDenied) {
        //无权限
        [SVProgressHUD showErrorWithStatus:@"请在[设置]-[隐私]-[相机]中允许爱财帮访问"];
    }else if(authStatu == AVAuthorizationStatusNotDetermined){
        weakify(self)
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                strongify(self)
                [self pickerImageFromCamera];
            }
        }];
    }else if (authStatu == AVAuthorizationStatusAuthorized){
        [self pickerImageFromCamera];
    }
}

- (void)pickerImageFromCamera {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    // 设置数据源类型
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -- 真正从相册选取
- (void)pickerImageFromAlbum {
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = max_img_count-self.imageAssets.count;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];
}

#pragma mark -- Image Album Delegate

- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.imageAssets addObjectsFromArray:aSelected];
    [self updateImageAssetsDisplay];
}

#pragma mark -- Image Camera Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker     didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageAssets addObject:image];
    [self updateImageAssetsDisplay];
}

#pragma mark -- UITextView Delegate 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *tmpString = [NSMutableString stringWithString:textView.text];
    if ([tmpString stringByReplacingCharactersInRange:range withString:text].length > max_len) {
        return false;
    }
    return true;
}

- (void)publishTopicEvent {
    //TODO:处理图片大小为640x960 再上传
    
}

@end
