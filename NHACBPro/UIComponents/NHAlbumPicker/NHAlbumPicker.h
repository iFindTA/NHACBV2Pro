//
//  NHAlbumPicker.h
//  LFStreetLifeProject
//
//  Created by Nanhu on 13-4-10.
//  Copyright (c) 2013年 Nanhu. All rights reserved.
//

#import "NHBaseViewController.h"
#import "NHAlbumPickerDefines.h"

@class NHAlbumGridItem;
@protocol NHAlbumPickerControllerDelegate;
@interface NHAlbumPicker : NHBaseViewController

@property (nonatomic, assign)id<NHAlbumPickerControllerDelegate> delegate;

/**
 * 是否将保存的图片显示在上边
 */
@property (nonatomic, assign)BOOL shouldShowSavedPhotosOnTop;

/**
 * 最大可选取个数
 */
@property (nonatomic, assign)NSInteger maximumNumberOfPhotosToBeSelected;

/**
 * 当前选中的NHAlbumGridItem集合
 */
@property (nonatomic, strong)NSArray *selection;

/**
 * 选中、非选中 某张图片
 */
-(void)selectOrDeSelectAsset:(NHAlbumGridItem *)gridItem forState:(BOOL)select;

/**
 * 详细列表选择完成
 */
-(void)albumReviewViewTouchDoneBtn;

/**
 * block方式回调 执行选取结果
 */
-(void)handleAlbumPickingMediaResultFinishBlock:(NHAlbumDidFinish)finishBlock withErrorBlock:(NHAlbumDidFail)failedBlock;

@end

@protocol NHAlbumPickerControllerDelegate <NSObject>
@optional
-(void)NHAlbumPickerController:(NHAlbumPicker *)picker didFinishedPickingMediaWithInfo:(NSArray *)info;
-(void)NHAlbumPickerController:(NHAlbumPicker *)picker didFailPickingMediaWithError:(NSError *)error;

@end
