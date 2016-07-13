//
//  NHPlatformPicker.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/21.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHPlatformPicker.h"

@interface NHPlatformPicker ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, copy) NHPlatformEvent event;
@property (nonatomic, copy) NSString *m_default_plat;

@property (nonatomic, strong) UITextField *platform_tfd;
@property (nonatomic, strong) UIBarButtonItem *done_bar;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHPlatformPicker

- (id)initWithDefaultPlatform:(NSString *)plat {
    self = [super init];
    if (self) {
        if (plat != nil) {
            self.m_default_plat = [plat copy];
        }
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"选择平台";
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
    public.frame = CGRectMake(0, 0, 51, 31);
    public.titleLabel.font = PBSysFont(NHFontSubSize);
    [public setTitle:@"完成" forState:UIControlStateNormal];
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [public setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [public addTarget:self action:@selector(doneFinishedSelectedPlatform) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bookBar = [[UIBarButtonItem alloc] initWithCustomView:public];
    self.done_bar = bookBar;
    bookBar.enabled = self.m_default_plat.length > 0;
    self.navigationItem.rightBarButtonItems = @[spacer,bookBar];
    
    //TODO:test datas
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i < 5; i++) {
        NSString *tmp = PBFormat(@"平台%zd",i);
        [arrs addObject:tmp];
    }
    self.dataSource = [NSMutableArray arrayWithArray:[arrs copy]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.table) {
        [self renderPlatformBody];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderPlatformBody {
    weakify(self)
    CGFloat m_sect_h = NH_CUSTOM_TFD_HEIGHT+NH_BOUNDARY_OFFSET;
    //平台名称
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    CGFloat m_pre_width = 80;
    UILabel *preLabel = [[UILabel alloc] init];
    preLabel.font = font;
    preLabel.textColor = color;
    preLabel.text = @"平台名称";
    [self.view addSubview:preLabel];
    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.size.equalTo(CGSizeMake(m_pre_width, m_sect_h));
    }];
    //竖线
    color = [UIColor colorWithRed:220/255.f green:222/255.f blue:230/255.f alpha:1];
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [self.view addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(preLabel.mas_right);
        make.size.equalTo(CGSizeMake(NH_CUSTOM_LINE_HEIGHT, m_sect_h*0.33));
    }];
    
    //input
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UITextField *tfd = [[UITextField alloc] init];
    tfd.font = font;
    tfd.textColor = color;
    tfd.placeholder = @"输入平台名称";
    tfd.delegate = self;
    tfd.text = self.m_default_plat;
    tfd.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:tfd];
    self.platform_tfd = tfd;
    [tfd mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.centerY.equalTo(preLabel.mas_centerY);
        make.left.equalTo(vLine.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(self.view).offset(-NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_TFD_HEIGHT);
    }];
    //分割线
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(preLabel.mas_bottom);
        make.left.right.equalTo(self.view).offset(NH_BOUNDARY_MARGIN);
        make.height.equalTo(NH_CUSTOM_LINE_HEIGHT);
    }];
    //table1
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    table.backgroundColor = [UIColor cyanColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:table];
    self.table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark == UITableView Delegate && DataSource ==

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
    return NH_CUSTOM_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"platCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell layoutIfNeeded];
    UIColor *color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    NSInteger __row__ = indexPath.row;
    NSString *a_plat = [self.dataSource objectAtIndex:__row__];
    cell.textLabel.text = a_plat;
    cell.textLabel.font = PBSysFont(NHFontTitleSize);
    cell.textLabel.textColor = color;
    if (__row__ == self.dataSource.count - 1) {
        pb_makeCellSeperatorLineTopGrid(cell);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger __row = [indexPath row];
    NSString *plat = [self.dataSource objectAtIndex:__row];
    self.platform_tfd.text = plat;
    self.done_bar.enabled = plat.length >= 2;
    [self.view endEditing:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark -- textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.done_bar.enabled = newString.length >= 2;
    return newString.length <= 20;
}

- (void)doneFinishedSelectedPlatform {
    NSString *plat = self.platform_tfd.text;
    if (plat != nil) {
        if (_event) {
            _event(true, plat);
        }
    }
}

- (void)handlePlatformSelectedEvent:(NHPlatformEvent)event {
    self.event = [event copy];
}

@end
