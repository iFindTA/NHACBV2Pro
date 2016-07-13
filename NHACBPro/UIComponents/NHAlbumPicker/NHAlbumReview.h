//
//  NHAlbumReview.h
//  LFStreetLifeProject
//
//  Created by Nanhu on 13-4-10.
//  Copyright (c) 2013年 Nanhu. All rights reserved.
//

#import "NHBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@class NHAlbumPicker;
@interface NHAlbumReview : NHBaseViewController

@property (weak, readonly)NSArray *selectedAssets;

/**
 * 操作的相册跟视图控制器
 */
@property (nonatomic, strong)NHAlbumPicker *albumPicker;

/**
 * 本相册的所有数据集合
 */
@property (nonatomic, strong)ALAssetsGroup *assetsGroups;

@end

#pragma mark - NHAlbumGridItem
@class NHAlbumGridItem;
@protocol NHAlbumGridItemDelegate <NSObject>
@optional
- (BOOL)NHAlbumGridItemCanSelected:(NHAlbumGridItem *)gridItem;
- (void)NHAlbumGridItem:(NHAlbumGridItem *)gridItem didChangeSelectionState:(NSNumber *)selected;

@end

@interface NHAlbumGridItem : UIView

/**
 * 图像数据
 */
@property (nonatomic, strong)ALAsset *asset;

- (id)initWithImagePickerController:(NHAlbumPicker *)imagePickerController andAsset:(ALAsset *)asset;

- (void)loadImageFromAsset;

- (void)tap;

@end

@interface ALAsset (AGIPC)

-(BOOL)isEqual:(id)object;

@end