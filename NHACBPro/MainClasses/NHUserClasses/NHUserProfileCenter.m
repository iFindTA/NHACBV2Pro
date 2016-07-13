//
//  NHUserProfileCenter.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHUserProfileCenter.h"
#import "NHResetPasswder.h"
#import "NHNicker.h"
#import "NHRealAuthor.h"
#import "DoImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "TOCropViewController.h"

#pragma mark -- Custom Cell --

@interface NHUsrCell : UITableViewCell

@property (nonatomic, strong) IBInspectable UIImageView *m_icon;

@property (nonatomic, strong) IBInspectable UILabel *m_type;
@property (nonatomic, strong) IBInspectable UILabel *m_sub_type;

@end

@implementation NHUsrCell

- (void)awakeFromNib {
    [self __initSetup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UIFont *subfont = PBSysFont(NHFontSubSize);
    UIColor *subcolor = [UIColor colorWithRed:170/255.f green:172/255.f blue:177/255.f alpha:1];
    [self.contentView addSubview:self.m_icon];
    [self.contentView addSubview:self.m_type];
    [self.contentView addSubview:self.m_sub_type];
    self.m_type.font = font;
    self.m_type.textColor = color;
    self.m_sub_type.font = subfont;
    self.m_sub_type.textColor = subcolor;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -- lazy methods
- (UIImageView *)m_icon {
    if (!_m_icon) {
        UIImageView *imgv = [[UIImageView alloc] init];
        _m_icon = imgv;
    }
    return _m_icon;
}

- (UILabel *)m_type {
    if (!_m_type) {
        UILabel *label = [[UILabel alloc] init];
        _m_type = label;
    }
    return _m_type;
}

- (UILabel *)m_sub_type {
    if (!_m_sub_type) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        _m_sub_type = label;
    }
    return _m_sub_type;
}

#pragma mark -- autolayout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat m_icon_size = NH_CUSTOM_LAB_HEIGHT;
    weakify(self)
    [self.m_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView);
        make.width.and.height.equalTo(NH_CUSTOM_CELL_HEIGHT);
    }];
    self.m_icon.layer.cornerRadius = NH_CUSTOM_CELL_HEIGHT*0.5;
    self.m_icon.layer.masksToBounds = true;
    [self.m_type mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_icon_size);
    }];
    [self.m_sub_type mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.contentView);
        make.height.equalTo(m_icon_size);
    }];
}

@end

#pragma mark -- Real Class Info --

@interface NHUserProfileCenter ()<UITableViewDelegate, UITableViewDataSource, DoImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, strong) UITableView *table;

@end

@implementation NHUserProfileCenter

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"kpersoninfo");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderUsrProfilerBody];
    }
    if (self.shouldRefreshWhenWillShow) {
        self.shouldRefreshWhenWillShow = false;
        //TODO:刷新
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderUsrProfilerBody {
    weakify(self)
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    UIColor *bgColor = [UIColor colorWithRed:210/255.f green:41/255.f blue:7/255.f alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = NH_CORNER_RADIUS;
    btn.layer.masksToBounds = true;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(preQueryLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.right.bottom.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_BTN_HEIGHT);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, NH_BOUNDARY_MARGIN*2+NH_CUSTOM_BTN_HEIGHT, 0));
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_USR_CELL_HEIGHT           =       50;
static const int NH_USR_SECT_HEIGHT           =       10;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = 2;
    }else if (section == 1){
        __rows = 3;
    }else if (section == 2){
        __rows = 1;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = NH_USR_SECT_HEIGHT;
    if (section == 0) {
        height = 0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == 1) {
        UIColor *bgColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, NH_USR_SECT_HEIGHT)];
        view.backgroundColor = bgColor;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = bgColor;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger __section = indexPath.section;
    NSUInteger __row = indexPath.row;
    CGFloat __row_height = NH_USR_CELL_HEIGHT;
    if (__section == 0 && __row == 0) {
        __row_height = 85;
    }
    return __row_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger __section__ = indexPath.section;
    NSInteger __row__ = indexPath.row;
    static NSString *identifier = @"usrCell";
    NHUsrCell *cell = (NHUsrCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHUsrCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.m_icon.hidden = true;
    NSString *title,*subtitle;
    if (__section__ == 0) {
        if (__row__ == 0) {
            title = @"头像";subtitle = @"http://www.dianmeng.com/moban/tupian/200909/20090927120255741.jpg";
            cell.m_icon.hidden = false;
        }else if (__row__ == 1){
            title = @"昵称";subtitle = @"乐纯";
            pb_makeCellSeperatorLineTopGrid(cell);
        }
    }else if (__section__ == 1){
        if (__row__ == 0) {
            title = @"帐号";subtitle = @"130****2337";
        }else if (__row__ == 1){
            title = @"帐号类型";subtitle = @"普通会员";
        }else if (__row__ == 2){
            title = @"登录密码";subtitle = @"修改";
            pb_makeCellSeperatorLineTopGrid(cell);
        }
    }else if (__section__ == 2){
        if (__row__ == 0) {
            title = @"实名认证";subtitle = @"未认证";
        }
    }
    [cell layoutIfNeeded];
    
    cell.m_type.text = title;
    if (__section__ == 0&&__row__ == 0) {
        [cell.m_icon sd_setImageWithURL:[NSURL URLWithString:subtitle]];
    }else{
        cell.m_sub_type.text = subtitle;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __section__ = indexPath.section;
    NSInteger __row__ = indexPath.row;
    
    if (__section__ == 0) {
        if (__row__ == 0) {
            //修改头像
            [self updateUsrAvatar];
        }else if (__row__ == 1){
            //修改昵称
            NHNicker *nicker = [[NHNicker alloc] init];
            weakify(self)
            [nicker handleNickerEvent:^(NSString *nick, BOOL success) {
                if (success) {
                    strongify(self)
                    self.shouldRefreshWhenWillShow = true;
                    [self popUpLayer];
                }
            }];
            [self.navigationController pushViewController:nicker animated:true];
        }
    }else if (__section__ == 1){
        UIViewController *destCtr;
        if (__row__ == 2) {
            NHResetPasswder *resetPwder = [[NHResetPasswder alloc] initWithPwdType:NHResetPWDTypeModify];
            resetPwder.aBackClass = self.class;
            destCtr = resetPwder;
        }
        if (destCtr != nil) {
            [self.navigationController pushViewController:destCtr animated:true];
        }
    }else if (__section__ == 2){
        //TODO:条件判断是否认证过
        NHRealAuthor *nameAuthor = [[NHRealAuthor alloc] init];
        weakify(self)
        [nameAuthor handleUsrRealAuthorEvent:^(NSString *name, BOOL success) {
            if (success) {
                strongify(self)
                self.shouldRefreshWhenWillShow = true;
                [self popUpLayer];
            }
        }];
        [self.navigationController pushViewController:nameAuthor animated:true];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark -- image picker 

- (void)updateUsrAvatar {
    JGActionSheetSection *s_u = [JGActionSheetSection sectionWithTitle:@"选取照片" message:nil buttonTitles:@[@"拍照",@"从相册选取"] buttonStyle:JGActionSheetButtonStyleDefault];
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
    cont.nMaxCount = 1;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];
}

#pragma mark -- Image Album Delegate

- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [aSelected firstObject];
    [self editAvatar:image];
}

#pragma mark -- Image Camera Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker     didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self editAvatar:image];
}

#pragma mark -- 编辑照片

- (void)editAvatar:(UIImage *)image {
    image = [image pb_scaleToSize:CGSizeFromString(NH_USR_AVATAR_SIZE) keepAspect:true];
    TOCropViewController *cropCtr = [[TOCropViewController alloc] initWithImage:image];
    [self presentViewController:cropCtr animated:true completion:^{
        
    }];
}

#pragma mark -- 编辑委托

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
}

#pragma mark -- logout

- (void)preQueryLogout {
    JGActionSheetSection *s_u = [JGActionSheetSection sectionWithTitle:@"退出登录？" message:nil buttonTitles:@[@"确定"] buttonStyle:JGActionSheetButtonStyleRed];
    JGActionSheetSection *s_d = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[PBLocalized(@"kcancel")] buttonStyle:JGActionSheetButtonStyleCancel];
    __block JGActionSheet *actionSheet = [JGActionSheet actionSheetWithSections:@[s_u,s_d]];
    weakify(self)
    [actionSheet setButtonPressedBlock:^(JGActionSheet *s, NSIndexPath *d) {
        if (d.section == 0) {
            strongify(self)
            if (d.row == 0) {
                [self logoutAction];
            }
        }
        [s dismissAnimated:true];
    }];
    [actionSheet showInView:self.view animated:true];
}

- (void)logoutAction {
    [[[NHAFEngine share] requestSerializer] clearAuthorizationHeader];
    [[NHDBEngine share] logout];
    //TODO:退出登录
}

@end
