//
//  NHFinanceHistory.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/17.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHFinanceHistory.h"
#import "NHFinanceBooker.h"
#import "NHActivityProfiler.h"

@interface NHFinanceHistory ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHFinanceHistory

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"历史明细";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i < 10; i++) {
        NSDictionary *tmp = @{
                              @"activity":@"新手投资活动",
                              @"platform":@"钱内助",
                              @"amount":PBFormat(@"%zd",arc4random()%1000),
                              @"payway":@"一次性还款",
                              @"start":@"2015-12-3",
                              @"end":@"2016-3-29"
                              };
        [arrs addObject:tmp];
    }
    self.dataSource = [NSMutableArray arrayWithArray:[arrs copy]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderFinanceHistoryBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderFinanceHistoryBody {
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

static const int NH_BOOK_CELL_HEIGHT           =       136;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger __rows = 0;
    if (section == 0) {
        __rows = self.dataSource.count;
    }
    return __rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NH_BOOK_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"financeAmountCell";
    NHFinanceAmountCell *cell = (NHFinanceAmountCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NHFinanceAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell layoutIfNeeded];
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDict = [self.dataSource objectAtIndex:__row__];
    [cell updateContent:aDict];
    //手动添加的可以修改
    [cell handleManualRecordEditEvent:^(id info) {
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NHActivityProfiler *activitier = [[NHActivityProfiler alloc] init];
    activitier.activityName = @"活动详情";
    [self.navigationController pushViewController:activitier animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
