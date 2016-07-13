//
//  NHInvestorRingCell.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/9.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NHInvestorRingCell;
typedef void(^NHPraiseEvent)(NHInvestorRingCell *cl, BOOL praised);
typedef void(^NHCommentEvent)(NHInvestorRingCell *cl);
typedef void(^NHReportEvent)(NHInvestorRingCell *cl);
typedef void(^NHImageBrowseEvent)(NHInvestorRingCell *cl, NSUInteger idx);

@interface NHInvestorRingModel : NSObject

@end

@interface NHInvestorRingCell : UITableViewCell

- (void)setupForDataSource:(NSDictionary *)aDic;

- (void)handlePraiseEvent:(NHPraiseEvent)event;
- (void)handleCommentEvent:(NHCommentEvent)event;
- (void)handleReportEvent:(NHReportEvent)event;
- (void)handleImageBrowseEvent:(NHImageBrowseEvent)event;

NS_ASSUME_NONNULL_END

@end
