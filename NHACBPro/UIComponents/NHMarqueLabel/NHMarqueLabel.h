//
//  NHMarqueLabel.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/2.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NHMarqueDirectionHorizon            =       1 << 0,
    NHMarqueDirectionVertical           =       1 << 1
}NHMarqueDirection;

@protocol NHMarqueLabelDelegate;
@protocol NHMarqueLabelDataSource;
@interface NHMarqueLabel : UIView

- (id)initWithFrame:(CGRect)frame withDirection:(NHMarqueDirection)direction;

@property (nonatomic, assign) id <NHMarqueLabelDelegate> delegate;
@property (nonatomic, assign) id <NHMarqueLabelDataSource> dataSource;

- (void)reloadData;

@end

@protocol NHMarqueLabelDelegate <NSObject>

- (void)marque:(NHMarqueLabel *)marque didSelectRow:(NSInteger)row;

@end

@protocol NHMarqueLabelDataSource <NSObject>

- (int)numberLinesInMarque:(NHMarqueLabel *)marque;

- (NSString *)marque:(NHMarqueLabel *)marque infoForIndex:(NSInteger)index;

@end