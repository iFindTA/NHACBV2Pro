//
//  NHSettingProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHSettingProfiler.h"
#import "NHHelpProfiler.h"
#import "NHWebBrowser.h"

@interface NHSettingProfiler ()<UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) UITableView *table;

@end

@implementation NHSettingProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"设置";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBody {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    weakify(self)
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.edges.equalTo(self.view);
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_SETTING_CELL_HEIGHT           =       50;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = 3;
    }else if (section == 1){
        __rows = 2;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NH_SETTING_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *title = nil;NSString *arrow = nil;
    NSInteger __row__ = indexPath.row;
    if (__row__ == 0) {
        title = @"关于我们";
    }else if (__row__ == 1){
        title = @"帮助中心";
    }else if (__row__ == 2){
        title = @"清理缓存";
        CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.f;
        arrow = PBFormat(@"%.2fKB",size);
        if (size > 1024) {
            arrow = PBFormat(@"%.2fMB",size/1024.f);
        }
    }
    UIColor *color = [UIColor colorWithRed:82/255.f green:85/255.f blue:97/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontTitleSize);
    label.textColor = color;
    label.text = title;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_MARGIN);
    }];
    if (arrow != nil) {
        color = [UIColor colorWithRed:170/255.f green:172/255.f blue:178/255.f alpha:1];
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.font = PBSysFont(NHFontSubSize);
        label.textColor = color;
        label.text = arrow;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_MARGIN);
        }];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __row__ = indexPath.row;
    UIViewController *destCtr = nil;
    if (__row__ == 0) {
        NHWebBrowser *webBrowser = [NHWebBrowser browser];
        destCtr = webBrowser;
        [webBrowser loadURL:[NSURL URLWithString:@"https://www.youtuker.com/m/app/help.html"]];
    }else if (__row__ == 1){
        NHHelpProfiler *helper = [[NHHelpProfiler alloc] init];
        destCtr = helper;
    }else if (__row__ == 2){
        [SVProgressHUD showWithStatus:@"清理中..."];
        weakify(self)
        SDImageCache *imgCache = [SDImageCache sharedImageCache];
        [imgCache clearDiskOnCompletion:^{
            NSLog(@"清理完了");
            
        }];
        strongify(self)
        PBMAINDelay(PBANIMATE_DURATION*6, ^{
            [self.table reloadData];
            [SVProgressHUD dismissWithDelay:1];
        });
    }
    
    if (destCtr != nil) {
        [self.navigationController pushViewController:destCtr animated:true];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)testForUploadImage {
    UIImage *image = [UIImage imageNamed:@"acb_lanunch_320480"];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    NSUInteger len = data.length/1024;
    NSLog(@"图片大小:%zdKB",len);
    NSString *url = @"http://192.168.2.251:3003/";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    /*
    AFHTTPRequestSerializer *requestSerial = [AFHTTPRequestSerializer serializer];
    [requestSerial setValue:@"application/x-www-data-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableURLRequest *urlRequest = [requestSerial requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    AFURLSessionManager *urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSURLSessionUploadTask *uploadTask = [urlManager uploadTaskWithRequest:urlRequest fromData:imageData.copy progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"res:%@",responseObject);
    }];
    [uploadTask resume];
    //*/
    
    /*
     NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue new]];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
     request.HTTPMethod = @"POST";
     [request setValue:@"application/x-www-data-urlencoded" forHTTPHeaderField:@"content-Type"];
     NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable resObj, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSString *string = [[NSString alloc] initWithData:resObj encoding:NSUTF8StringEncoding];
         NSLog(@"response:%@:error:%@",string,error.localizedDescription);
     }];
     [task resume];
     //*/
    
    /*
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url] sessionConfiguration:config];
    [httpManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/ipeg"];
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/ipeg"];
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/ipeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"res:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed at :%@",error.localizedDescription);
    }];
    //*/
}

@end
