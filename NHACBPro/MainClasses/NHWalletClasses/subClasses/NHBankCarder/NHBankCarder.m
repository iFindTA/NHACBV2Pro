//
//  NHBankCarder.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHBankCarder.h"
#import "SWTableViewCell.h"
#import "NHBankCardAdder.h"
#import "NHRealAuthor.h"

@interface NHBankCarder ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, copy) NHBankCardEvent event;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *table;

@end

@implementation NHBankCarder

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"银行卡";
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    self.view.backgroundColor = color;
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    
    UIBarButtonItem *addBar = [self barWithIcon:@"\U0000e617" withTarget:self withSelector:@selector(preQueryUsrAuthorationState)];
    UIBarButtonItem *helpBar = [self barWithIcon:@"\U0000e607" withTarget:self withSelector:@selector(problemForHelpAction)];
    self.navigationItem.rightBarButtonItems = @[spacer, addBar, spacer, helpBar];
    
    //TODO:test
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        NSDictionary *dic = @{
                              @"icon":@"http://cdn.marketplaceimages.windowsphone.com/v8/images/e3464e57-1478-49c5-b218-913c8e7cd6c7?imageType=ws_icon_large",
                              @"name":@"中国招商银行",
                              @"type":@"借记卡",
                              @"cardnum":@"xxxx xxxx xxxx 6182"
                              };
        [arrs addObject:dic];
    }
    self.dataSource = [NSMutableArray arrayWithArray:arrs.copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.table) {
        [self renderBodyForCards:nil];
    }
    if (self.shouldRefreshWhenWillShow) {
        self.shouldRefreshWhenWillShow = false;
        //TODO:refresh data
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderBodyForCards:(NSArray *)arrs {
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.backgroundView = nil;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [table reloadData];
}

#pragma mark == UITableView Delegate && DataSource ==

static const int NH_CARD_CELL_HEIGHT           =       130;

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
    return NH_CARD_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cardCell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.rightUtilityButtons = [self cellRightOperations];
//        cell.delegate = self;
    }
    
    UIColor *color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    cell.contentView.backgroundColor = color;
    CALayer *layer = [CALayer layer];
    CGRect bounds = CGRectMake(NH_BOUNDARY_MARGIN, NH_BOUNDARY_OFFSET*2, PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2, NH_CARD_CELL_HEIGHT-NH_BOUNDARY_OFFSET*2);
    layer.frame = bounds;
    layer.cornerRadius = NH_CORNER_RADIUS;
    layer.masksToBounds = true;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [cell.contentView.layer addSublayer:layer];
    //infos
    NSInteger __row__ = indexPath.row;
    NSDictionary *aDic = [self.dataSource objectAtIndex:__row__];
    NSString* title = [aDic objectForKey:@"name"];
    NSString* type = [aDic objectForKey:@"type"];
    NSString* icon = [aDic objectForKey:@"icon"];
    NSString* card = [aDic objectForKey:@"cardnum"];
    CGFloat icon_size = 40;
    UIImageView *iconV = [[UIImageView alloc] init];
    [cell.contentView addSubview:iconV];
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(NH_BOUNDARY_OFFSET*2+NH_BOUNDARY_MARGIN);
        make.left.equalTo(cell.contentView).offset(NH_BOUNDARY_MARGIN*2);
        make.size.equalTo(CGSizeMake(icon_size, icon_size));
    }];
    [iconV sd_setImageWithURL:[NSURL URLWithString:icon]];
    //name
    color = [UIColor colorWithRed:83/255.f green:86/255.f blue:98/255.f alpha:1];
    UIFont *font = PBSysBoldFont(NHFontTitleSize);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = font;
    titleLabel.textColor = color;
    titleLabel.text = title;
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconV.mas_top);
        make.left.equalTo(iconV.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.right.equalTo(cell.contentView);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    //type
    font = PBSysBoldFont(NHFontSubSize);
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = font;
    typeLabel.textColor = color;
    typeLabel.text = type;
    [cell.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconV.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.bottom.equalTo(iconV.mas_bottom);
        make.right.equalTo(cell.contentView);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    //card
    font = PBSysFont(NHFontTitleSize);
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.font = font;
    cardLabel.textColor = color;
    cardLabel.text = card;
    [cell.contentView addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconV.mas_right).offset(NH_BOUNDARY_MARGIN);
        make.bottom.equalTo(cell.contentView).offset(-NH_BOUNDARY_MARGIN);
        make.right.equalTo(cell.contentView);
        make.height.equalTo(NH_CUSTOM_LAB_HEIGHT);
    }];
    
    return cell;
}

- (NSArray *)cellRightOperations {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return [rightUtilityButtons copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger __row__ = indexPath.row;
    
    if (_event) {
        NSDictionary *aCard = [self.dataSource objectAtIndex:__row__];
        _event(aCard);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark -- UITableViewCell right actions 

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)handleBankCardEvent:(NHBankCardEvent)event {
    self.event = [event copy];
}

- (void)problemForHelpAction {
    //TODO:帮助 常见问题 网页
}

- (void)preQueryUsrAuthorationState {
    NHUsr *mUsr = [[NHDBEngine share] authorizedUsr];
    BOOL authored = mUsr.authorName.length > 0 && mUsr.authorName.length > 0;
    if (!authored) {
        //TODO:是否实名认证过
        weakify(self)
        DQAlertView *alert = [[DQAlertView alloc] initWithTitle:nil message:@"你还没有实名认证过，请先实名认证" cancelButtonTitle:PBLocalized(@"kcancel") otherButtonTitle:@"确定"];
        [alert actionWithBlocksCancelButtonHandler:^{
            
        } otherButtonHandler:^{
            strongify(self)
            NHRealAuthor *realAuthor = [[NHRealAuthor alloc] init];
            [realAuthor handleUsrRealAuthorEvent:^(NSString *name, BOOL success) {
                if (success) {
                    
                }
            }];
            [self.navigationController pushViewController:realAuthor animated:true];
        }];
        [alert show];
    }else{
        [self addCardEvent];
    }
}

- (void)addCardEvent {
    NHBankCardAdder *adder = [[NHBankCardAdder alloc] init];
    weakify(self)
    [adder handleBankCardAddEvent:^(NSDictionary *card, BOOL success) {
        if (success) {
            strongify(self);
            self.shouldRefreshWhenWillShow = true;
            PBMAINDelay(PBANIMATE_DURATION, ^{
                [self popUpLayer];
            });
        }
    }];
    [self.navigationController pushViewController:adder animated:true];
}

@end
