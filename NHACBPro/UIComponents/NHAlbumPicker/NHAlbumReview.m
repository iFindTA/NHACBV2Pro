//
//  NHAlbumReview.m
//  LFStreetLifeProject
//
//  Created by Nanhu on 13-4-10.
//  Copyright (c) 2013年 Nanhu. All rights reserved.
//

#import "NHAlbumReview.h"
#import "NHAlbumPicker.h"

#pragma mark - ALAsset Catogery
@implementation ALAsset (AGIPC)

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    ALAsset *otherAsset = (ALAsset *)other;
    NSDictionary *selfUrls = [self valueForProperty:ALAssetPropertyURLs];
    NSDictionary *otherUrls = [otherAsset valueForProperty:ALAssetPropertyURLs];
    
    return [selfUrls isEqualToDictionary:otherUrls];
}
@end

#pragma mark - NHAlbumGridItem

@interface NHAlbumGridItem ()

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, strong)UIImageView *thumbnailImageView,*checkmarkImageView;
@property (nonatomic, strong)UIView *selectionView;

@property (nonatomic, assign)id<NHAlbumGridItemDelegate> delegate;

@property (nonatomic, strong)NHAlbumPicker *imagePickerController;

@end

@implementation NHAlbumGridItem

#pragma mark - Object Lifecycle

- (id)initWithImagePickerController:(NHAlbumPicker *)imagePickerController andAsset:(ALAsset *)asset {
    self = [super init];
    if (self) {
        self.imagePickerController = imagePickerController;
        
        self.selected = NO;
        
        CGRect frame = CGRectMake(0, 0, NHAlbum_ITEM_WIDTH, NHAlbum_ITEM_HEIGHT);
        CGRect checkmarkFrame = CGRectMake(NHAlbum_ITEM_WIDTH-NHAlbum_CHECKMARK_WIDTH, NHAlbum_ITEM_HEIGHT-NHAlbum_CHECKMARK_HEIGHT, NHAlbum_CHECKMARK_WIDTH, NHAlbum_CHECKMARK_HEIGHT);
        
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // Drawing must be exectued in main thread. springox(20131220)
		//self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:self.thumbnailImageView];
        
        self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // Drawing must be exectued in main thread. springox(20131220)
        //self.selectionView.backgroundColor = [UIColor whiteColor];
        //self.selectionView.alpha = .5f;
        //self.selectionView.hidden = !self.selected;
        [self addSubview:self.selectionView];
        
        // Position the checkmark image in the bottom right corner
        self.checkmarkImageView = [[UIImageView alloc] initWithFrame:checkmarkFrame];
        // Drawing must be exectued in main thread. springox(20131220)
        //if (IS_IPAD())
        //    self.checkmarkImageView.image = [UIImage imageNamed:@"AGImagePickerController.bundle/AGIPC-Checkmark-iPad"];
        //else
        //    self.checkmarkImageView.image = [UIImage imageNamed:@"AGImagePickerController.bundle/AGIPC-Checkmark-iPhone"];
        //self.checkmarkImageView.hidden = !self.selected;
		[self addSubview:self.checkmarkImageView];
        
        self.asset = asset;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.selectionView.backgroundColor = [UIColor whiteColor];
    self.selectionView.alpha = .5f;
    self.selectionView.hidden = !self.selected;
    
    if (IS_IPAD())
        self.checkmarkImageView.image = [UIImage imageNamed:@"NHAlbumPicker.bundle/AGIPC-Checkmark-iPad"];
    else
        self.checkmarkImageView.image = [UIImage imageNamed:@"NHAlbumPicker.bundle/AGIPC-Checkmark-iPhone"];
    self.checkmarkImageView.hidden = !self.selected;
}

// Drawing must be exectued in main thread. springox(20131218)
- (void)loadImageFromAsset {
    self.thumbnailImageView.image = [UIImage imageWithCGImage:self.asset.thumbnail];
    if ([self.imagePickerController.selection containsObject:self]){
        self.selected = YES;
    }
}

#pragma mark - 点击事件 触发

-(void)tap {
    if (!self.selected){
        // Check if we can select
        if (_delegate && [_delegate respondsToSelector:@selector(NHAlbumGridItemCanSelected:)]){
            if (![self.delegate NHAlbumGridItemCanSelected:self])
                return;
        }
        
        self.selected = YES;
        self.selectionView.hidden = NO;
        self.checkmarkImageView.hidden = NO;
    }else{
        self.selected = NO;
        self.selectionView.hidden = YES;
        self.checkmarkImageView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(NHAlbumGridItem:didChangeSelectionState:)]){
            [self.delegate performSelector:@selector(NHAlbumGridItem:didChangeSelectionState:) withObject:self withObject:@(self.selected)];
        }
    });
}

@end

@interface NHAlbumReview ()<UITableViewDelegate,UITableViewDataSource,NHAlbumGridItemDelegate>

//@property (nonatomic, strong)NHNavigationBar *navigationBar;
@property (nonatomic, strong)NSMutableArray *assets;
@property (nonatomic, strong)UITableView *reviewTable;

@end

@implementation NHAlbumReview

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initilaizedCustomNavigationBar];
    NSString *title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.title = title;
    //left
    UIBarButtonItem *spacer = [self barSpacer];
    UIBarButtonItem *menuBar = [self barWithIcon:NH_NAVIBAR_ICON_BACK withTarget:self withSelector:@selector(popUpLayer)];
    self.navigationItem.leftBarButtonItems = @[spacer, menuBar];
    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
    public.frame = CGRectMake(0, 0, 50, 31);
    public.titleLabel.font = PBSysFont(NHFontSubSize);
    [public setTitle:@"完成" forState:UIControlStateNormal];
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [public addTarget:self.albumPicker action:@selector(albumReviewViewTouchDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pubBar = [[UIBarButtonItem alloc] initWithCustomView:public];
    self.navigationItem.rightBarButtonItems = @[spacer,pubBar];
    
    [self initializedCustomAlbumInfoTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NHAlbumPickerDidFinishedPickImage:) name:NHAlbumPickerFinishedPickImageNotification object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)initializedCustomAlbumInfoTable {
//    CGRect tableRect = CGRectMake(0, 0, PBSCREEN_WIDTH, PBSCREEN_HEIGHT);
    _reviewTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    if ([_reviewTable respondsToSelector:@selector(setSeparatorInset:)]){
        [_reviewTable setSeparatorInset:UIEdgeInsetsZero];
    }
    _reviewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _reviewTable.delegate = self;
    _reviewTable.dataSource = self;
    [self.view addSubview:_reviewTable];
    
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadAssets];
    });
}

- (void)setAssetsGroup:(ALAssetsGroup *)theAssetsGroup {
    if (self.assetsGroup != theAssetsGroup){
        self.assetsGroup = theAssetsGroup;
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    }
}

- (ALAssetsGroup *)assetsGroup {
    return self.assetsGroups;
}

- (NSArray *)selectedAssets {
    NSMutableArray *selectedAssets = [NSMutableArray array];
	for (NHAlbumGridItem *gridItem in self.assets){
		if (gridItem.selected){
			[selectedAssets addObject:gridItem.asset];
		}
	}
    
    return selectedAssets;
}

- (void)loadAssets {
    if (self.assets && [self.assets count]){
        [_assets removeAllObjects];
        _assets = nil;
    }
    _assets = [[NSMutableArray alloc] initWithCapacity:0];
    
    __weak typeof(&*self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong typeof(&*self) strongSelf = weakSelf;
        @autoreleasepool {
            [strongSelf.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil){
                    return;
                }
                
                NHAlbumGridItem *gridItem = [[NHAlbumGridItem alloc] initWithImagePickerController:strongSelf.albumPicker andAsset:result];
                gridItem.delegate = self;
                gridItem.selected = [self isAlreadyContainGridItem:gridItem];
                [strongSelf.assets insertObject:gridItem atIndex:0];
                
            }];
            
            [strongSelf.assets sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
                NHAlbumGridItem *gridItem1 = (NHAlbumGridItem *)obj1;
                NHAlbumGridItem *gridItem2 = (NHAlbumGridItem *)obj2;
                ALAsset *asset1 = gridItem1.asset;
                ALAsset *asset2 = gridItem2.asset;
                NSDate *date1 = [asset1 valueForProperty:ALAssetPropertyDate];
                NSDate *date2 = [asset2 valueForProperty:ALAssetPropertyDate];
                return [date1 timeIntervalSinceDate:date2]>0;
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf reloadAlbumReviewData];
            if ([_assets count]) {
                double numberOfAssets = (double)self.assetsGroup.numberOfAssets;
                NSInteger nr = ceil(numberOfAssets / [self defaultNumberOfItemsPerRow]);
                [_reviewTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nr-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
        
    });
}

-(BOOL)isAlreadyContainGridItem:(NHAlbumGridItem *)gridItem {
    BOOL alreadyHave = NO;
    NSArray *selectArray = [_albumPicker selection];
    if (selectArray != nil && [selectArray count]){
        for (NHAlbumGridItem *item in selectArray){
            if ([item.asset isEqual:gridItem.asset]){
                alreadyHave = YES;
                break;
            }
        }
    }
    return alreadyHave;
}

#pragma mark - NHAlbumGridItem Delegate
-(BOOL)NHAlbumGridItemCanSelected:(NHAlbumGridItem *)gridItem {
    NSArray *selectedAlready = [_albumPicker selection];
    NSInteger selectedCount = [selectedAlready count];
    if (selectedCount>0 && selectedCount+1>[_albumPicker maximumNumberOfPhotosToBeSelected]){
        return NO;
    }
    return YES;
}

-(void)NHAlbumGridItem:(NHAlbumGridItem *)gridItem didChangeSelectionState:(NSNumber *)selected {
    if (_albumPicker != nil){
        [_albumPicker selectOrDeSelectAsset:gridItem forState:[selected boolValue]];
    }
    [self updateSelectedAssetsCountBadge];
}

-(void)updateSelectedAssetsCountBadge {
    NSArray *selectedAlready = [_albumPicker selection];
    NSInteger selectedCount = [selectedAlready count];
}

-(void)reloadAlbumReviewData
{
    if (_reviewTable){
        [_reviewTable reloadData];
    }
    [self updateSelectedAssetsCountBadge];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (! self.albumPicker) return 0;
    
    double numberOfAssets = (double)self.assetsGroup.numberOfAssets;
    NSInteger nr = ceil(numberOfAssets / [self defaultNumberOfItemsPerRow]);
    //NSLog(@"总共%d行",nr);
    return nr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat boundsMargin = (ScreenWidth-NHAlbum_ITEM_WIDTH*[self defaultNumberOfItemsPerRow])/([self defaultNumberOfItemsPerRow]+1);
    return NHAlbum_ITEM_HEIGHT+boundsMargin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *destView = IOS7_OR_LATER?cell.contentView:cell;
    [destView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger totalCount_ = [self.assets count];
    NSInteger count_PerRow = [self defaultNumberOfItemsPerRow];
    if (totalCount_/count_PerRow == [indexPath row]){
        count_PerRow = totalCount_%count_PerRow;
    }
    
    CGFloat boundsMargin = (ScreenWidth-NHAlbum_ITEM_WIDTH*[self defaultNumberOfItemsPerRow])/([self defaultNumberOfItemsPerRow]+1);
    
    for (int i= 0; i<count_PerRow; i++){
        CGRect frame = CGRectMake(boundsMargin+(NHAlbum_ITEM_WIDTH+boundsMargin)*i, boundsMargin, NHAlbum_ITEM_WIDTH, NHAlbum_ITEM_HEIGHT);
        
        NHAlbumGridItem *gridItem = [self.assets objectAtIndex:[indexPath row]*[self defaultNumberOfItemsPerRow]+i];
        //*
        [gridItem loadImageFromAsset];
        //NSLog(@"gridCellFrame:%@",NSStringFromCGRect(frame));
        [gridItem setFrame:frame];
        UITapGestureRecognizer *selectionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:gridItem action:@selector(tap)];
        selectionGestureRecognizer.numberOfTapsRequired = 1;
        [gridItem addGestureRecognizer:selectionGestureRecognizer];
        
        [destView addSubview:gridItem];
        //*/
    }
    
    return cell;
}

- (NSUInteger)defaultNumberOfItemsPerRow {
    NSUInteger numberOfItemsPerRow = 0;
    
    if (IS_IPAD()){
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            numberOfItemsPerRow = NHAlbum_ITEMS_PER_ROW_IPAD_PORTRAIT;
        } else {
            numberOfItemsPerRow = NHAlbum_ITEMS_PER_ROW_IPAD_LANDSCAPE;
        }
    } else {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            numberOfItemsPerRow = NHAlbum_ITEMS_PER_ROW_IPHONE_PORTRAIT;
            
        } else {
            numberOfItemsPerRow = NHAlbum_ITEMS_PER_ROW_IPHONE_LANDSCAPE;
        }
    }
    
    return numberOfItemsPerRow;
}

#pragma mark - 不管取消还是完成 都是完成了选取图片
-(void)NHAlbumPickerDidFinishedPickImage:(NSNotification *)noti {
    BLOCKSELF_NH
    dispatch_async(dispatch_get_main_queue(), ^{
        [blockSelf_NH reloadAlbumReviewData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
