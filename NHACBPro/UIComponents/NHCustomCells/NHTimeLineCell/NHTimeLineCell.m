//
//  NHTimeLineCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/12.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHTimeLineCell.h"
#import "NHDBEngine.h"
#import "UIButton+ActivityIndicator.h"

@implementation NHTimelineModel

@end

@interface NHTimeLineCell ()

@property (nonatomic, strong) NHTimelineModel *dataSource;
@property (nonatomic, strong) UIImageView *icon_img;
@property (nonatomic, strong) UILabel *nick_lab,*time_lab,*content_lab,*line_lab,*m_comm_bg;
@property (nonatomic, strong) UIButton *m_more_btn;

//@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NHShowMoreEvent moreEvent;
@property (nonatomic, copy) NHTimeLineCommentEvent commentEvent;

@end

@implementation NHTimeLineCell

- (void)awakeFromNib {
    // Initialization code
    [self __initSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.icon_img.image = nil;
    self.nick_lab.text = nil;
    self.time_lab.text = nil;
    self.content_lab.text = nil;
    self.m_more_btn.working = false;
    [self clearComments];
}

- (void)clearComments {
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag>=1000) {
            [obj removeFromSuperview];
        }
    }];
    //[self reAutolayoutLineForView:self.content_lab];
}

- (void)__initSetup {
    
    UIImageView *img_v = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:img_v];
    self.icon_img = img_v;
    
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    UILabel *nick = [[UILabel alloc] init];
    nick.font = font;
    nick.textColor = color;
    [self.contentView addSubview:nick];
    self.nick_lab = nick;
    
    //time
    font = PBSysFont(NHFontSubSize);
    UILabel *time = [[UILabel alloc] init];
    time.font = font;
    time.textColor = color;
    time.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:time];
    self.time_lab = time;
    
    //content
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *content = [[UILabel alloc] init];
    content.font = font;
    content.textColor = color;
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.preferredMaxLayoutWidth = PBSCREEN_WIDTH-NH_BOUNDARY_MARGIN*2-NH_CONTENT_MARGIN;
    content.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentDidTouchAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [content addGestureRecognizer:tap];
    [self.contentView addSubview:content];
    self.content_lab = content;
    
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.line_lab = line;
    
    //comments bg
    color = [UIColor colorWithRed:247/255.f green:248/255.f blue:250/255.f alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = color;
    [self.contentView insertSubview:label atIndex:0];
    self.m_comm_bg = label;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int m_left_offset = NH_BOUNDARY_MARGIN;
    int m_icon_size = 25;
    //TODO:优化点，裁剪图片遮罩不使用圆角
    self.icon_img.layer.cornerRadius = m_icon_size*0.5;
    self.icon_img.layer.masksToBounds = true;
    weakify(self)
    [self.icon_img mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.top.left.equalTo(self.contentView).offset(m_left_offset);
        make.width.height.equalTo(@(m_icon_size));
    }];
    [self.nick_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.icon_img.mas_top);
        make.bottom.equalTo(self.icon_img.mas_bottom);
        make.left.equalTo(self.icon_img.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView).offset(-m_left_offset);
    }];
    [self.time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.icon_img.mas_top);
        make.bottom.equalTo(self.icon_img.mas_bottom);
        make.left.equalTo(self.icon_img.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView).offset(-m_left_offset);
    }];
    [self.content_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(self.icon_img.mas_bottom).offset(m_left_offset);
        make.left.equalTo(self.icon_img.mas_left).offset(m_left_offset);
        make.right.equalTo(self.time_lab).offset(-NH_CONTENT_MARGIN);
        //make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    //comments bg
    [self.m_comm_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content_lab.mas_bottom);
        make.left.equalTo(self.content_lab.mas_left);
        make.right.equalTo(self.time_lab.mas_right);
        //make.height.equalTo(0);
    }];
    [self.line_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(self.m_comm_bg.mas_bottom).offset(m_left_offset);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    //约束 content view 自己结束
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(PBSCREEN_WIDTH));
        make.bottom.equalTo(self.line_lab.mas_bottom);
    }];
}

- (void)updateForInfo:(NHTimelineModel *)aModel {
    if (_dataSource) {
        _dataSource = nil;
    }
    self.dataSource = aModel;
//    self.indexPath = indexPath;
    
    NSString *url = self.dataSource.icon;
    [self.icon_img sd_setImageWithURL:[NSURL URLWithString:url]];
    NSString *nick = self.dataSource.nick;
    self.nick_lab.text = nick;
    NSString *time = self.dataSource.time;
    NSDateFormatter *formatter = [NHDBEngine share].dateFormatter;
    NSDate *dateTime = [formatter dateFromString:time];
    time = [dateTime pb_timeAgo];
    self.time_lab.text = time;
    NSString *content = self.dataSource.content;
    self.content_lab.text = content;
    
    //return;
    
    NSUInteger nums = aModel.numsCount.integerValue;
    NSUInteger dis = aModel.disCount.integerValue;
    dis = MIN(dis, nums);
    int m_left_offset = NH_BOUNDARY_MARGIN;
    int contentWidth = PBSCREEN_WIDTH-m_left_offset*2-NH_CONTENT_MARGIN;
    int commentWidth = contentWidth - NH_CONTENT_MARGIN - NH_BOUNDARY_MARGIN;
    
    UIColor *nickColor = [UIColor colorWithRed:161/255.f green:163/255.f blue:177/255.f alpha:1];
    UIColor *unColor = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    UIFont *font = PBSysFont(NHFontSubSize);
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:unColor
                                 };
    UIView *last_view = nil;
    NSArray *tmps = aModel.comments;
    for (int i = 0; i < dis; i++) {
        NSDictionary *aDic = [tmps objectAtIndex:i];
        NSString *from_usr = [aDic objectForKey:@"from"];
        NSString *to_usr = [aDic objectForKey:@"to"];
        NSString *content = [aDic objectForKey:@"content"];
        NSString *info = PBFormat(@"%@ 回复 %@：%@",from_usr,to_usr,content);
        
        NSRange fromRange = NSMakeRange(0, from_usr.length);
        NSRange toRange = NSMakeRange(from_usr.length+4, to_usr.length);
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:info attributes:attributes];
        [attributeString addAttributes:@{NSForegroundColorAttributeName:nickColor} range:fromRange];
        [attributeString addAttributes:@{NSForegroundColorAttributeName:nickColor} range:toRange];
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1000+i;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.preferredMaxLayoutWidth = commentWidth;
        label.attributedText = attributeString;
        label.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidSelect:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [label addGestureRecognizer:tap];
        [label sizeToFit];
        [self.contentView addSubview:label];
        weakify(self)
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            strongify(self)
            make.top.equalTo((last_view == nil)?self.content_lab.mas_bottom:last_view.mas_bottom).offset((last_view == nil)?NH_BOUNDARY_MARGIN:NH_CONTENT_MARGIN);
            make.left.equalTo((last_view == nil)?self.content_lab.mas_left:last_view.mas_left).offset((last_view == nil)?NH_CONTENT_MARGIN:0);
            make.width.equalTo(@(commentWidth));
        }];
        
        last_view = label;
    }
    
    //更多
    if (last_view != nil) {
        int remain_count = (int)(nums - dis);
        if (remain_count > 0) {
            NSString *tmp_info = PBFormat(@"展开剩余%d条评论",remain_count);
            UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
            more.tag = 1000+nums;
            more.titleLabel.font = font;
            [more setTitleColor:nickColor forState:UIControlStateNormal];
            [more setTitle:tmp_info forState:UIControlStateNormal];
            [more setTitle:@"" forState:UIControlStateDisabled];
            [more addTarget:self action:@selector(showMoreCommentEvent) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:more];
            self.m_more_btn = more;
            [more mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(last_view.mas_bottom).offset(NH_CONTENT_MARGIN);
                make.left.equalTo(last_view.mas_left);
                make.width.equalTo(@(commentWidth));
                make.height.equalTo(@(NH_CUSTOM_LAB_HEIGHT));
            }];
            
            last_view = more;
        }
    }
    
    if (dis > 0 && last_view != nil) {
        //背景view
        [self.m_comm_bg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content_lab.mas_bottom);
            make.left.equalTo(self.content_lab.mas_left);
            make.right.equalTo(self.time_lab.mas_right);
            make.bottom.equalTo(last_view.mas_bottom).offset(NH_BOUNDARY_MARGIN);
        }];
    }
}

- (void)handleShowMoreEvent:(NHShowMoreEvent)event {
    self.moreEvent = [event copy];
}

//static int NH_SHOW_COMMENT_STEP = 10;

- (void)showMoreCommentEvent {
//    NSUInteger dis = self.dataSource.disCount.integerValue;
//    NSUInteger nums = self.dataSource.numsCount.integerValue;
//    if (dis >= nums) {
//        return;
//    }
//    [self clearComments];
//    if (dis + NH_SHOW_COMMENT_STEP > nums) {
//        dis = nums;
//    }else{
//        dis += NH_SHOW_COMMENT_STEP;
//    }
//    self.dataSource.disCount = [NSNumber numberWithInteger:dis];
//    [self updateForInfo:self.dataSource forIndexPath:self.indexPath];
    
    [self.m_more_btn setWorking:true];
    if (_moreEvent) {
        _moreEvent(self.dataSource);
    }
}

- (void)handleTimeLineCommentTouchEvent:(NHTimeLineCommentEvent)event {
    self.commentEvent = [event copy];
}

#pragma mark -- Touch Actions

- (void)commentDidSelect:(UITapGestureRecognizer *)gester {
    UIView *tmp_v = [gester view];
    NSInteger __tag = tmp_v.tag - 1000;
    if (__tag < 0) {
        return;
    }
    NSArray *tmps = self.dataSource.comments;
    NSDictionary *aDic = [tmps objectAtIndex:__tag];
    NSString *from_usr = [aDic objectForKey:@"from"];
    if (_commentEvent) {
        _commentEvent(from_usr, NHReplyTypeReply);
    }
}

- (void)contentDidTouchAction {
    if (_commentEvent) {
        _commentEvent(self.dataSource.nick, NHReplyTypeComment);
    }
}

@end
