//
//  NHWalletProfiler.m
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHWalletProfiler.h"
#import "NHMoneyProfiler.h"
#import "NHBankCarder.h"
#import "NHWXProfiler.h"

@interface NHWalletProfiler ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) BOOL isInreviewing;

@end

@implementation NHWalletProfiler

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = PBLocalized(@"kwallet");
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    self.isInreviewing = false;
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

static const int NH_WALLET_CELL_HEIGHT           =       50;
static const int NH_WALLET_SECT_HEIGHT           =       40;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = 3;
    }else if (section == 1){
        __rows = self.isInreviewing?1:2;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 1) {
        height = NH_WALLET_SECT_HEIGHT;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == 1) {
        UIColor *color = [UIColor colorWithRed:169/255.f green:170/255.f blue:178/255.f alpha:1];
        UIColor *bgColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PBSCREEN_WIDTH, NH_WALLET_SECT_HEIGHT)];
        view.backgroundColor = bgColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = PBSysFont(NHFontSubSize);
        label.textColor = color;
        label.text = @"支付信息";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, NH_BOUNDARY_MARGIN, 0, 0));
        }];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NH_WALLET_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger __section__ = indexPath.section;
    NSInteger __row__ = indexPath.row;
    static NSString *identifier = @"ringCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title,*amount,*unit,*access;
    if (__section__ == 0) {
        if (__row__ == 0) {
            title = @"余额";amount = @"215";unit = @"元";
        }else if (__row__ == 1){
            title = @"金币";amount = @"1129";unit = @"枚";
        }else if (__row__ == 2){
            title = @"风险保证金";amount = @"0.00";unit = @"元";
            
            pb_makeCellSeperatorLineTopGrid(cell);
        }
    }else if (__section__ == 1){
        if (__row__ == 0) {
            title = @"银行卡";access = @"0张";
            if (self.isInreviewing) {
                pb_makeCellSeperatorLineTopGrid(cell);
            }
        }else if (__row__ == 1){
            title = @"微信支付";access = @"乐纯";
            if (0/*绑定过 就不显示accessory*/) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            pb_makeCellSeperatorLineTopGrid(cell);
        }
    }
    UIColor *color = [UIColor colorWithRed:80/255.f green:82/255.f blue:94/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.font = PBSysFont(NHFontTitleSize);
    label.textColor = color;
    label.text = title;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_MARGIN);
    }];
    color = [UIColor colorWithRed:170/255.f green:172/255.f blue:177/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontSubSize);
    if (__section__ == 0) {
        
        NSString *info = PBFormat(@"%@ %@",amount, unit);
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName:color,
                                     NSFontAttributeName:font
                                     };
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:info attributes:attributes];
        NSRange colorRange = NSMakeRange(0, amount.length);
        UIColor *rangeColor = [UIColor colorWithRed:217/255.f green:117/255.f blue:108/255.f alpha:1];
        [attributeString addAttribute:NSForegroundColorAttributeName value:rangeColor range:colorRange];
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.font = font;
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.attributedText = attributeString;
        [cell.contentView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }else if (__section__ == 1){
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.font = font;
        infoLabel.textColor = color;
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.text = access;
        [cell.contentView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __section__ = indexPath.section;
    NSInteger __row__ = indexPath.row;
    
    if (__section__ == 0) {
        NHMoneyProfiler *profiler = [[NHMoneyProfiler alloc] initWithProfileType:1 << __row__];
        [self.navigationController pushViewController:profiler animated:true];
    }else if (__section__ == 1){
        UIViewController *destCtr;
        if (__row__ == 0) {
            NHBankCarder *bankCarder = [[NHBankCarder alloc] init];
            destCtr = bankCarder;
        }else if (__row__ == 1){
            //TODO:绑定过就不显示
            
            NHWXProfiler *wxProfiler = [[NHWXProfiler alloc] init];
            destCtr = wxProfiler;
        }
        if (destCtr != nil) {
            [self.navigationController pushViewController:destCtr animated:true];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
