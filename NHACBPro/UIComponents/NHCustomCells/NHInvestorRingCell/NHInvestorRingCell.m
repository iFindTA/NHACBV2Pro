//
//  NHInvestorRingCell.m
//  NHACBPro
//
//  Created by hu jiaju on 16/6/9.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHInvestorRingCell.h"
#import "NHDBEngine.h"
#import "NHEmitterButton.h"
#import <SDWebImage/UIButton+WebCache.h>

#pragma mark -- Model section --

@implementation NHInvestorRingModel

@end

#pragma mark -- Cell section --

@interface NHInvestorRingCell ()

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) UIImageView *icon_img;
@property (nonatomic, strong) UILabel *nick_lab,*time_lab,*content_lab,*line_lab;

@property (nonatomic, strong) NHEmitterButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, copy) NHPraiseEvent praiseEvent;
@property (nonatomic, copy) NHReportEvent reportEvent;
@property (nonatomic, copy) NHCommentEvent commentEvent;
@property (nonatomic, copy) NHImageBrowseEvent imageBrowseEvent;

@end

@implementation NHInvestorRingCell

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
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([obj isKindOfClass:[UIButton class]]
             ||[obj isKindOfClass:[UILabel class]])
            && obj.tag>=1000) {
            [obj removeFromSuperview];
        }
    }];
    [self layoutIfNeeded];
}

- (void)__initSetup {
    
    int m_left_offset = NH_BOUNDARY_MARGIN;
    int m_icon_size = 25;
    UIImageView *img_v = [[UIImageView alloc] initWithFrame:CGRectZero];
    //TODO:优化点，裁剪图片遮罩不使用圆角
    img_v.layer.cornerRadius = m_icon_size*0.5;
    img_v.layer.masksToBounds = true;
    [self.contentView addSubview:img_v];
    self.icon_img = img_v;
    weakify(self)
    [img_v mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self);
        make.top.left.equalTo(self.contentView).offset(m_left_offset);
        make.width.height.equalTo(@(m_icon_size));
    }];
    UIFont *font = PBSysFont(NHFontTitleSize);
    UIColor *color = [UIColor colorWithRed:133/255.f green:134/255.f blue:139/255.f alpha:1];
    UILabel *nick = [[UILabel alloc] init];
    nick.font = font;
    nick.textColor = color;
    [self.contentView addSubview:nick];
    self.nick_lab = nick;
    [nick mas_makeConstraints:^(MASConstraintMaker *make) {
       strongify(self)
        make.top.equalTo(img_v.mas_top);
        make.bottom.equalTo(img_v.mas_bottom);
        make.left.equalTo(img_v.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView).offset(-m_left_offset);
    }];
    //time
    font = PBSysFont(NHFontSubSize);
    UILabel *time = [[UILabel alloc] init];
    time.font = font;
    time.textColor = color;
    time.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:time];
    self.time_lab = time;
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(img_v.mas_top);
        make.bottom.equalTo(img_v.mas_bottom);
        make.left.equalTo(img_v.mas_right).offset(NH_CONTENT_MARGIN);
        make.right.equalTo(self.contentView).offset(-m_left_offset);
    }];
    //content
    color = [UIColor colorWithRed:74/255.f green:75/255.f blue:85/255.f alpha:1];
    font = PBSysFont(NHFontTitleSize);
    UILabel *content = [[UILabel alloc] init];
    content.font = font;
    content.textColor = color;
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.preferredMaxLayoutWidth = PBSCREEN_WIDTH-m_left_offset*2-NH_CONTENT_MARGIN;
    [self.contentView addSubview:content];
    self.content_lab = content;
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        //strongify(self)
        make.top.equalTo(img_v.mas_bottom).offset(m_left_offset);
        make.left.equalTo(img_v.mas_left).offset(m_left_offset);
        make.right.equalTo(time).offset(-NH_CONTENT_MARGIN);
        //make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    //line
    color = [UIColor colorWithRed:218/255.f green:220/255.f blue:229/255.f alpha:1];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    self.line_lab = line;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(content.mas_bottom).offset(m_left_offset);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    //竖线
    CGFloat mSeperate3_w = PBSCREEN_WIDTH/3.f;
    UILabel *vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [self.contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.left.equalTo(self.contentView).offset(mSeperate3_w);
        make.width.equalTo(@1);
        make.height.equalTo(@(m_icon_size));
    }];
    vLine = [[UILabel alloc] init];
    vLine.backgroundColor = color;
    [self.contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.right.equalTo(self.contentView).offset(-mSeperate3_w);
        make.width.equalTo(@1);
        make.height.equalTo(@(m_icon_size));
    }];
    line = [[UILabel alloc] init];
    line.backgroundColor = color;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(vLine.mas_bottom).offset(NH_CONTENT_MARGIN+2);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    //btn
    color = [UIColor colorWithRed:169/255.f green:170/255.f blue:198/255.f alpha:1];
//    UIColor *sColor = [UIColor colorWithRed:215/255.f green:94/255.f blue:83/255.f alpha:1];
    UIImage *img_s = [UIImage imageNamed:@"praise_select"];
    UIImage *img_n = [UIImage imageNamed:@"praise_unselect"];
//    UIImage *praise_img_n = [UIImage pb_iconFont:nil withName:@"\U0000e612" withSize:m_icon_size withColor:color];
//    UIImage *praise_img_s = [UIImage pb_iconFont:nil withName:@"\U0000e612" withSize:m_icon_size withColor:sColor];
    NHEmitterButton *praise = [NHEmitterButton buttonWithType:UIButtonTypeCustom];
    [praise setImage:img_s forState:UIControlStateSelected];
    [praise setImage:img_n forState:UIControlStateNormal];
    [praise addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    praise.exclusiveTouch = true;
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, NH_CONTENT_MARGIN, 0, 0);
    praise.titleLabel.font = PBSysFont(NHFontSubSize);
    [praise setTitleColor:color forState:UIControlStateNormal];
    [self.contentView addSubview:praise];
    self.praiseBtn = praise;
    [praise mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(vLine.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    //comment
//    UIImage *com_img = [UIImage pb_iconFont:nil withName:@"\U0000e613" withSize:m_icon_size*PBSCREEN_SCALE withColor:color];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setImage:com_img forState:UIControlStateNormal];
    //btn.titleEdgeInsets = UIEdgeInsetsMake(0, NH_CONTENT_MARGIN, 0, 0);
    btn.exclusiveTouch = true;
    btn.titleLabel.font = PBFont(@"iconfont", NHFontSubSize);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.commentBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(praise.mas_right);
        make.centerY.equalTo(praise.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    //举报
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    btn.titleLabel.font = PBFont(@"iconfont", NHFontTitleSize);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:@"\U0000e606" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(praise.mas_centerY);
        make.height.equalTo(@(m_icon_size));
        make.width.equalTo(@(mSeperate3_w));
    }];
    
    //分割区
    color = [UIColor colorWithRed:237/255.f green:237/255.f blue:242/255.f alpha:1];
    UILabel *sect = [[UILabel alloc] init];
    sect.backgroundColor = color;
    [self.contentView addSubview:sect];
    [sect mas_makeConstraints:^(MASConstraintMaker *make) {
        strongify(self)
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(NH_CONTENT_MARGIN));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(PBSCREEN_WIDTH));
        make.bottom.equalTo(sect.mas_bottom);
    }];
    
    [self layoutIfNeeded];
}

- (void)setupForDataSource:(NSDictionary *)aDic {
    self.dataSource = aDic;
    
    NSString *url = [aDic objectForKey:@"icon"];
    [self.icon_img sd_setImageWithURL:[NSURL URLWithString:url]];
    NSString *nick = [aDic objectForKey:@"nick"];
    self.nick_lab.text = nick;
    NSString *time = [aDic objectForKey:@"time"];
//    NSDateFormatter *formatter = [NHDBEngine share].dateFormatter;
//    NSDate *dateTime = [formatter dateFromString:time];
//    time = [dateTime pb_timeAgo];
    self.time_lab.text = time;
    NSString *content = [aDic objectForKey:@"content"];
    self.content_lab.text = content;
    NSString *praise = [aDic objectForKey:@"praise"];
    [self.praiseBtn setTitle:praise forState:UIControlStateNormal];
    NSString *comcount = [aDic objectForKey:@"comcount"];
    NSMutableString *tmpComms = [NSMutableString stringWithString:comcount];
    [tmpComms insertString:@"\U0000e613 " atIndex:0];
    [self.commentBtn setTitle:[tmpComms copy] forState:UIControlStateNormal];
    NSArray *tasks__ = [aDic objectForKey:@"task"];
    UIView *tmp_algin_view = self.content_lab;
    //images: broke old layout and build new layout
    NSArray *images = [aDic objectForKey:@"image"];
    if (images.count) {
        CGFloat m_img_h = 85;
        CGFloat m_img_cap = NH_BOUNDARY_MARGIN;
        int m_img_num_per_line = 3;
        CGFloat m_img_w = (PBSCREEN_WIDTH-m_img_cap*(m_img_num_per_line+1))/m_img_num_per_line;
        __block UIButton *last_btn = nil;
        __block NSUInteger line_row_idx = 0;
        __block NSUInteger last_line_row_idx = 0;
        weakify(self)
        [images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            strongify(self)
            //行数 索引
            line_row_idx = idx / m_img_num_per_line;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000+idx;
            [btn addTarget:self action:@selector(imageBrwoserAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [btn sd_setImageWithURL:[NSURL URLWithString:obj] forState:UIControlStateNormal];
            weakify(self)
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                strongify(self)
                make.top.equalTo((last_btn==nil)?tmp_algin_view.mas_bottom:((line_row_idx==last_line_row_idx)?last_btn.mas_top:last_btn.mas_bottom)).offset((last_btn==nil)?NH_BOUNDARY_MARGIN:((line_row_idx==last_line_row_idx)?0:NH_BOUNDARY_MARGIN));
                make.left.equalTo((last_btn==nil)?self.contentView:(line_row_idx==last_line_row_idx)?(last_btn.mas_right):(self.contentView)).offset(NH_BOUNDARY_MARGIN);
                make.width.equalTo(@(m_img_w));
                make.height.equalTo(@(m_img_h));
            }];
            
            last_btn = btn;
            last_line_row_idx = line_row_idx;
        }];
        if (last_btn && tasks__.count == 0) {
            [self.line_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
                strongify(self)
                make.top.equalTo(last_btn.mas_bottom).offset(NH_BOUNDARY_MARGIN);
                make.left.right.equalTo(self.contentView);
                make.height.equalTo(@1);
            }];
        }
        
        tmp_algin_view = last_btn;
    }
    
    //tasks:broke the layout and build new layout
    NSArray *tasks = [aDic objectForKey:@"task"];
    if (tasks.count) {
        CGFloat m_task_h = 35;
        UIColor *color = [UIColor colorWithRed:161/255.f green:163/255.f blue:178/255.f alpha:1];
        UIColor *bgColor = [UIColor colorWithRed:243/255.f green:244/255.f blue:250/255.f alpha:1];
        UIFont *font = PBFont(@"iconfont", NHFontSubSize);
        __block UILabel *last_view = nil;
        weakify(self)
        [tasks enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            strongify(self)
            NSMutableString *tmp = [NSMutableString stringWithString:obj];
            [tmp insertString:@"  \U0000e611 " atIndex:0];
            UILabel *label = [[UILabel alloc] init];
            label.tag = 1000+idx;
            label.font = font;
            label.textColor = color;
            label.backgroundColor = bgColor;
            label.text = [tmp copy];
            [self.contentView addSubview:label];
            weakify(self)
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                strongify(self)
                make.top.equalTo((last_view == nil)?tmp_algin_view.mas_bottom:last_view.mas_bottom).offset((last_view == nil)?NH_BOUNDARY_MARGIN:NH_CONTENT_MARGIN);
                make.left.equalTo(self.contentView).offset(NH_BOUNDARY_MARGIN);
                make.right.equalTo(self.contentView).offset(-NH_BOUNDARY_MARGIN);
                make.height.equalTo(@(m_task_h));
            }];
            
            last_view = label;
        }];
        if (last_view != nil) {
            [self.line_lab mas_remakeConstraints:^(MASConstraintMaker *make) {
                strongify(self)
                make.top.equalTo(last_view.mas_bottom).offset(NH_BOUNDARY_MARGIN);
                make.left.right.equalTo(self.contentView);
                make.height.equalTo(@1);
            }];
        }
    }
    
    //[self layoutSubviews];
    [self layoutIfNeeded];
}

- (void)praiseAction:(NHEmitterButton *)btn {
    btn.selected = !btn.selected;
    NSString *tmp = btn.titleLabel.text;
    int tmp_count = [tmp intValue];
    if (btn.selected) {
        tmp_count++;
    }else{
        tmp_count--;
    }
    tmp_count = MAX(tmp_count, 0);
    [btn setTitle:PBFormat(@"%d",tmp_count) forState:UIControlStateNormal];
    if (_praiseEvent) {
        _praiseEvent(self, btn.selected);
    }
}

- (void)commentAction {
    //NSLog(@"%s",__func__);
    if (_commentEvent) {
        _commentEvent(self);
    }
}

- (void)reportAction {
    //NSLog(@"%s",__func__);
    if (_reportEvent) {
        _reportEvent(self);
    }
}

- (void)imageBrwoserAction:(UIButton *)btn {
    //NSLog(@"%s:\n__tag:%zd",__func__,btn.tag);
    if (_imageBrowseEvent) {
        _imageBrowseEvent(self, btn.tag-1000);
    }
}

- (void)didMoveToSuperview {
    if (self.praiseBtn) {
        [self.praiseBtn setup];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)handlePraiseEvent:(NHPraiseEvent)event {
    self.praiseEvent = [event copy];
}

- (void)handleReportEvent:(NHReportEvent)event {
    self.reportEvent = [event copy];
}

- (void)handleCommentEvent:(NHCommentEvent)event {
    self.commentEvent = [event copy];
}

- (void)handleImageBrowseEvent:(NHImageBrowseEvent)event {
    self.imageBrowseEvent = [event copy];
}

@end
