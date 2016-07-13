//
//  NHTimeLineCell.h
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NHReplyTypeComment             =       1 << 0,
    NHReplyTypeReply               =       1 << 1
}NHReplyType;

@class NHTimeLineCell;
@class NHTimelineModel;
typedef void(^NHShowMoreEvent)(NHTimelineModel *ds);

typedef void(^NHTimeLineCommentEvent)(NSString *to, NHReplyType type);

@interface NHTimelineModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *disCount,*numsCount;
@property (nonatomic, strong) NSArray *comments;

@end

@interface NHTimeLineCell : UITableViewCell

- (void)updateForInfo:(NHTimelineModel *)aModel;

- (void)handleShowMoreEvent:(NHShowMoreEvent)event;

- (void)handleTimeLineCommentTouchEvent:(NHTimeLineCommentEvent)event;

@end
