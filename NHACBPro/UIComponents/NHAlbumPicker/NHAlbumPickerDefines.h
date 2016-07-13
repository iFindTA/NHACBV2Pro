//
//  NHAlbumPickerDefines.h
//  LFStreetLifeProject
//
//  Created by Nanhu on 13-4-10.
//  Copyright (c) 2013年 Nanhu. All rights reserved.
//

#ifndef LFStreetLifeProject_NHAlbumPickerDefines_h
#define LFStreetLifeProject_NHAlbumPickerDefines_h

#import <AssetsLibrary/AssetsLibrary.h>
#import "NHConstants.h"

#define IS_IPAD()                                                               ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && \
[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define NHAlbum_ITEMS_PER_ROW_IPHONE_PORTRAIT                                     4
#define NHAlbum_ITEMS_PER_ROW_IPHONE_LANDSCAPE                                    6
#define NHAlbum_ITEMS_PER_ROW_IPAD_PORTRAIT                                       8
#define NHAlbum_ITEMS_PER_ROW_IPAD_LANDSCAPE                                      12

#define NHAlbum_CHECKMARK_WIDTH                                                   28.f
#define NHAlbum_CHECKMARK_HEIGHT                                                  28.f

#define NHAlbum_ITEM_WIDTH                                                        75.f
#define NHAlbum_ITEM_HEIGHT                                                       75.f

typedef void (^NHAlbumDidFinish)(NSArray *info);
typedef void (^NHAlbumDidFail)(NSError *error);

#define NHAlbumPickerFinishedPickImageNotification @"NHAlbumPickerFinishedPickImageNotification"

#endif
