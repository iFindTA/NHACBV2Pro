//
//  NHHelpProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHHelpProfiler.h"
#import "NHWebBrowser.h"
#import "NHFeedbackProfiler.h"
#import "NHReportProfiler.h"

@interface NHHelpProfiler ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@end

@implementation NHHelpProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"khelp");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    weakify(self)
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableView --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    
    if (section == 0) {
        __rows = 3;
    }else if (section == 1){
        __rows = 3;
    }
    
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat __height = 0;
    if (section == 1) {
        __height = NH_BOUNDARY_OFFSET*2;
    }
    return __height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NH_CUSTOM_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSInteger __section = [indexPath section];
    NSInteger __row__ = [indexPath row];
    if (__section == 0) {
        NSString *title;
        if (__row__ == 0) {
            title = PBLocalized(@"kfeedback");
        }else if (__row__ == 1){
            title = PBLocalized(@"kcomproblems");
        }else if (__row__ == 2){
            title = PBLocalized(@"kplatform");
            pb_makeCellSeperatorLineTopGrid(cell);
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = PBSysFont(NHFontTitleSize);
        titleLabel.text = title;
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_OFFSET);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.equalTo(@(20));
        }];
        
    }else if (__section == 1){
        NSString *title,*sub;
        if (__row__ == 0) {
            title = PBLocalized(@"khotline");
            sub = @"0571-67825639";
        }else if (__row__ == 1){
            title = PBLocalized(@"kweixinpublic");
            sub = @"youtuker";
        }else if (__row__ == 2){
            title = PBLocalized(@"kqqgroup");
            sub = @"909203907";
            pb_makeCellSeperatorLineTopGrid(cell);
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = PBSysFont(NHFontTitleSize);
        titleLabel.text = title;
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_OFFSET);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.equalTo(@(20));
        }];
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.font = PBSysFont(NHFontSubSize);
        subLabel.textAlignment = NSTextAlignmentRight;
        subLabel.textColor = [UIColor lightGrayColor];
        subLabel.text = sub;
        [cell.contentView addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_OFFSET);
            make.right.equalTo(cell.contentView.mas_right).offset(0);
            make.height.equalTo(@(20));
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __section = [indexPath section];
    NSInteger __row__ = [indexPath row];
    UIViewController *m_tmpController = nil;
    if (__section == 0) {
        if (__row__ == 0) {
            NHFeedbackProfiler *feedback = [[NHFeedbackProfiler alloc] init];
            m_tmpController = feedback;
        }else if (__row__ == 1){
            NHWebBrowser *webBrowser = [NHWebBrowser browser];
            [webBrowser loadURL:[NSURL URLWithString:@"https://youtuker.com"]];
            m_tmpController = webBrowser;
        }else if (__row__ == 2){
            NHReportProfiler *reportCenter = [[NHReportProfiler alloc] init];
            m_tmpController = reportCenter;
        }
    }else if (__section == 1){
        if (__row__ == 0) {
            NSString *tmp_url = PBFormat(@"tel://%@",@"0571-67289762");
            NSURL *local = [NSURL URLWithString:tmp_url];
            UIWebView *web = [[UIWebView alloc] init];
            [self.view addSubview:web];
            [web loadRequest:[NSURLRequest requestWithURL:local]];
        }else if (__row__ == 1 || __row__ == 2){
            NSString *tmp = PBFormat(@"%@",@"youtuker");
            if (__row__ == 2) {
                tmp = PBFormat(@"%@",@"909203907");
            }
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [tmp copy];
            [SVProgressHUD showSuccessWithStatus:@"成功复制到粘贴板!"];
        }
    }
    if (m_tmpController != nil) {
        [self.navigationController pushViewController:m_tmpController animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
