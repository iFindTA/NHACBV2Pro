//
//  NHConstants.h
//  NHACBPro
//
//  Created by hu jiaju on 16/5/28.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#ifndef NHConstants_h
#define NHConstants_h

#define NH_USE_SWREVAL_FRAMEWORK                    1
static const int NH_SIDE_OFF_WIDTH          =       60;
static const int NH_BOUNDARY_OFFSET         =       10;
static const int NH_BOUNDARY_MARGIN         =       16;
static const int NH_CONTENT_MARGIN          =       9;
static const int NH_NAVIBAR_HEIGHT          =       64;
static const int NH_DESC_COUNTS             =       60;
static const int NH_CUSTOM_BTN_HEIGHT       =       40;
static const int NH_CUSTOM_TFD_HEIGHT       =       40;
static const int NH_CUSTOM_LAB_HEIGHT       =       21;
static const int NH_CUSTOM_CELL_HEIGHT      =       50;
static const int NH_CUSTOM_LINE_HEIGHT      =       1;
static const int NH_FEEDBACK_CRS_MAX        =       300;
static const int NH_CORNER_RADIUS           =       4;
static const int NH_REFRESH_INTERVAL        =       600;
static const int NH_REFRESH_PAGESIZE        =       20;
static const int NH_TEXT_PADDING            =       8;

static const int NH_NICK_MIN_LEN            =       2;
static const int NH_NICK_MAX_LEN            =       10;
static const int NH_PASSWD_MIN_LEN          =       6;
static const int NH_PASSWD_MAX_LEN          =       16;
static NSString * NH_PASSWD_REGEXP          =       @"^[A-Za-z0-9!^@#$`~%&*/_-{}()<>\":;,.']+$";
static NSString * NH_PHONE_REGEXP           =       @"^(1[3-9][0-9](?: ))(\\d{4}(?: )){2}$";

static NSString * NH_USR_AVATAR_SIZE        =       @"{640, 960}";

//font
static const CGFloat NHFontTitleSize        =       15.f;
static const CGFloat NHFontSubSize          =       13.f;

//navi
static const char * NH_NAVIBAR_TINTCOLOR    =       "#607EE0";
static NSString *NH_NAVIBAR_ICON_BACK       =       @"\U0000e60a";

static const char * NH_SEPERATE_LINE_HEX    =       "#DCDEE6";

//usr
static NSString * NH_USR_AUTO_LOGOUT_KEY         =       @"NHUSRAUTOLOGOUTKEY";
static NSString * NH_DESIGN_REFRENCE        =       @"6";

//error code
static const int NH_USR_STATE_INVALID       =       401;

#endif /* NHConstants_h */
