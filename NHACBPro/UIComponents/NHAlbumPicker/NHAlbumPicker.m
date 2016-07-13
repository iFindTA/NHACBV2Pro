//
//  NHAlbumPicker.m
//  LFStreetLifeProject
//
//  Created by Nanhu on 13-4-10.
//  Copyright (c) 2013年 Nanhu. All rights reserved.
//

#import "NHAlbumPicker.h"
#import "NHAlbumReview.h"

@interface NHAlbumPicker ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NHNavigationBar *navigationBar;

/** block回执 **/
@property (nonatomic, copy)NHAlbumDidFinish didFinishedBlock;
@property (nonatomic, copy)NHAlbumDidFail didFailedBlock;

/** 相册列表相关 **/
@property (nonatomic, strong)NSMutableArray *assetsGroups;
@property (nonatomic, strong)UITableView *albumListTableView;

@end

@implementation NHAlbumPicker

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
    
    [self initializedCustomAlbumListTable];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)initilaizedCustomNavigationBar {
    _navigationBar = [[NHNavigationBar alloc] initWithFrame:CGRectZero withTitle:@"相册" withleftImage:imageNHNamed(NHNavigationBarBackImage) withleftTitle:nil withRightImage:nil withRightTitle:@"完成"];
    [self updateAlbumPickerViewDoneBadge];
    [self.view addSubview:_navigationBar];
    WEAKSELF_NH
    [_navigationBar handleOperationBlock:^(NHNavigationBar *bar, NSUInteger buttonIndex) {
        if (bar != nil) {
            if (buttonIndex == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf_NH albumPickerViewTouchCancelBtn];
                });
            }else if (buttonIndex == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf_NH albumReviewViewTouchDoneBtn];
                });
            }
        }
    }];
}

//本页面点击取消按钮
-(void)albumPickerViewTouchCancelBtn {
    if (_didFailedBlock){
        _didFailedBlock(nil);
        [self resetSelectItemsAndUpdateBadgeView];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(NHAlbumPickerController:didFailPickingMediaWithError:)]){
        [_delegate NHAlbumPickerController:self didFailPickingMediaWithError:nil];
        [self resetSelectItemsAndUpdateBadgeView];
    }
}
//列表详细页面、或本页面点击完成按钮
-(void)albumReviewViewTouchDoneBtn {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NHAlbumGridItem *item in _selection){
        [tempArray addObject:item.asset];
    }
    if (_didFinishedBlock){
        _didFinishedBlock(tempArray);
        [self resetSelectItemsAndUpdateBadgeView];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(NHAlbumPickerController:didFinishedPickingMediaWithInfo:)]){
        [_delegate NHAlbumPickerController:self didFinishedPickingMediaWithInfo:tempArray];
        [self resetSelectItemsAndUpdateBadgeView];
    }
}

-(void)postAlbumPickerDidFinishedPikingImageNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:NHAlbumPickerFinishedPickImageNotification object:nil];
}

-(void)resetSelectItemsAndUpdateBadgeView {
    if (_selection){
        _selection = nil;
    }
    [self updateAlbumPickerViewDoneBadge];
    [self postAlbumPickerDidFinishedPikingImageNotification];
}

#pragma mark - 选中、非选中 某张图片
-(void)selectOrDeSelectAsset:(NHAlbumGridItem *)gridItem forState:(BOOL)select {
    @synchronized(_selection){
        NSMutableArray *tempItems_ = [[NSMutableArray alloc] initWithArray:_selection];
        if (select){
            [tempItems_ addObject:gridItem];
        }else{
            for (NHAlbumGridItem *tempItem in tempItems_){
                if ([tempItem.asset isEqual:gridItem.asset]){
                    [tempItems_ removeObject:tempItem];
                    break;
                }
            }
        }
        _selection = nil;
        _selection = [[NSArray alloc] initWithArray:tempItems_];
    }
    //NSLog(@"当前选中个数:%d",[_selection count]);
    [self updateAlbumPickerViewDoneBadge];
}

-(void)updateAlbumPickerViewDoneBadge {
    NSInteger selectedCount = [[self selection] count];
    [_navigationBar setItemHidden:selectedCount<=0 WithIndex:1];
    [_navigationBar setItemBadge:selectedCount withIndex:1];
}

-(void)handleAlbumPickingMediaResultFinishBlock:(NHAlbumDidFinish)finishBlock withErrorBlock:(NHAlbumDidFail)failedBlock {
    self.didFailedBlock = [failedBlock copy];
    self.didFinishedBlock = [finishBlock copy];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 相册列表数据源

+(ALAssetsLibrary *)defaultAssetsLibrary {
    static ALAssetsLibrary *assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Workaround for triggering ALAssetsLibraryChangedNotification
        [assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    });
    
    return assetsLibrary;
}

- (NSMutableArray *)assetsGroups {
    if (_assetsGroups == nil){
        _assetsGroups = [[NSMutableArray alloc] init];
        [self loadAssetsGroups];
    }
    
    return _assetsGroups;
}

- (void)loadAssetsGroups {
    __weak typeof(&*self) weakSelf = self;
    
    [self.assetsGroups removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @autoreleasepool {
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
                if (group == nil){
                    return;
                }
                
                if (weakSelf.shouldShowSavedPhotosOnTop){
                    if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos){
                        [self.assetsGroups insertObject:group atIndex:0];
                    }else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] > ALAssetsGroupSavedPhotos){
                        [self.assetsGroups insertObject:group atIndex:1];
                    }else{
                        [self.assetsGroups addObject:group];
                    }
                }else{
                    [self.assetsGroups addObject:group];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadAlbumGroupsListTable];
                });
            };
            
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
                if (_didFailedBlock){
                    _didFailedBlock(error);
                }
            };
            
            [[[self class] defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                               usingBlock:assetGroupEnumerator
                                                             failureBlock:assetGroupEnumberatorFailure];
            
        }
        
    });
}

#pragma mark - 初始化相册列表
-(void)initializedCustomAlbumListTable {
    CGRect naviRect = _navigationBar.frame;
    CGFloat navi_above = naviRect.origin.y+naviRect.size.height;
    
    CGRect tableRect = CGRectMake(0, navi_above, ScreenWidth, ScreenHeight-navi_above-StatuBar_Height);
    _albumListTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    if ([_albumListTableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_albumListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _albumListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _albumListTableView.delegate = self;
    _albumListTableView.dataSource = self;
    [self.view addSubview:_albumListTableView];
    
    [self assetsGroups];
}

-(void)reloadAlbumGroupsListTable {
    if (_albumListTableView != nil){
        [self.albumListTableView reloadData];
    }else{
        [self initializedCustomAlbumListTable];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetsGroups.count;
    self.title = NSLocalizedStringWithDefaultValue(@"AGIPC.Loading", nil, [NSBundle mainBundle], @"Loading...", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //ALAssetsGroup *group = (self.assetsGroups)[indexPath.row];
    id anyobject = [self.assetsGroups objectAtIndex:[indexPath row]];
    NSLog(@"class:----%@",NSStringFromClass([anyobject class]));
    ALAssetsGroup *group = [self.assetsGroups objectAtIndex:[indexPath row]];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSUInteger numberOfAssets = group.numberOfAssets;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", numberOfAssets];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup *)self.assetsGroups[indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NHAlbumReview *reviewController = [[NHAlbumReview alloc] init];
    reviewController.hidesBottomBarWhenPushed = YES;
    reviewController.albumPicker = self;
    reviewController.assetsGroups = self.assetsGroups[indexPath.row];
	[self.navigationController pushViewController:reviewController animated:YES];
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
