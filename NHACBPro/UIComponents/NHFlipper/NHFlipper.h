//
//  NHFlipper.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/7.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NHFlipperDirectionDefault           =       1 << 0,
    NHFlipperDirectionHorizontal        =       NHFlipperDirectionDefault,
    NHFlipperDirectionVertical          =       1 << 2
}NHFlipperDirection;

@class NHFlipperCell;
@protocol NHFlipperDelegate;
@protocol NHFlipperDataSource;
@interface NHFlipper : UIView

@property (nonatomic, assign) NHFlipperDirection direction;

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, weak) id<NHFlipperDelegate> delegate;
@property (nonatomic, weak) id<NHFlipperDataSource> dataSource;

/**
 *  @brief reload cell
 */
- (void)reloadData;

/**
 *  @brief get reuse cell
 *
 *  @param identifier cell's flag
 *
 *  @return the reuse empty cell
 */
- (NHFlipperCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end

@protocol NHFlipperDataSource <NSObject>
@required
- (NSInteger)numberOfRowsForFlipper:(NHFlipper *)flipper;

- (NHFlipperCell *)flipper:(NHFlipper *)flipper cellForRowIndex:(NSInteger)index;

@end

@protocol NHFlipperDelegate <NSObject>

- (void)flipper:(NHFlipper *)flipper didSelectRowIndex:(NSInteger)row;

@end

@interface NHFlipperCell : UIView

@property (nonatomic, copy, readonly) NSString *identifier;

- (NHFlipperCell *)initWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
