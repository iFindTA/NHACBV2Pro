//
//  NHDBEngine.h
//  NHFMDBPro
//
//  Created by hu jiaju on 16/2/17.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface NHDBEngine : NSObject

/**
 *  @brief 当前是否正在下载广告图片
 */
@property (nonatomic, assign, readonly) BOOL adLoading;

+ (NHDBEngine *)share;

- (void)setup;

- (NSDateFormatter *)dateFormatter;

#pragma mark -- 增删改查 示例 --

- (BOOL)saveInfo:(id)info;

- (BOOL)deleteInfo:(id)info;

- (BOOL)updateInfo:(id)info;

- (id)getInfo;
- (NSArray *)getInfos;

#pragma mark -- AD abouts --
/**
 *  @brief 获取需要展现的ad
 *
 *  @return nil则不显示
 */
- (NSDictionary *)shouldFlashAD;

/**
 *  @brief 保存下载到的ad
 *
 *  @param ad 详情
 *
 *  @return 是否成功
 */
- (BOOL)saveAD:(NSDictionary *)ad;

/**
 *  @brief 清除过期ads
 *
 *  @return 是否成功
 */
- (BOOL)clearExpiredADs;

/**
 *  @brief 自动下载未下载图片的ads
 */
- (void)autoDownloadADsViaWifi;

#pragma mark -- 用户 abouts --

/**
 *  @brief 用户是否登录
 *
 *  @return 是否
 */
- (BOOL)logined;

/**
 *  @brief 注销当前已登录用户
 *
 *  @return 结果
 */
- (BOOL)logout;

/**
 *  @brief 注册当前登录用户
 *
 *  @param usr          授权用户
 *  @param syncronise   是否同步到数据库
 *
 *  @return 结果
 */
- (BOOL)authorize2Usr:(NHUsr *)usr syncronise:(BOOL)sync;

/**
 *  @brief 获取当前已登录用户
 *
 *  @return 用户信息
 */
- (NHUsr *)authorizedUsr;

/**
 *  @brief 获取全局配置
 *
 *  @return 配置信息
 */
- (NHConfigure *)globalConfig;

/**
 *  @brief 同步当前全局配置字段：审核字段
 *
 *  @param reviewed 是否在审核
 *
 *  @return 同步结果
 */
- (BOOL)syncronizedConfigReviewed:(BOOL)reviewed;

/**
 *  @brief 同步当前全局配置字段：用户引导字段
 *
 *  @param flashed 是否显示过
 *
 *  @return 同步结果
 */
- (BOOL)syncronizedConfigUsrGuideFlashed:(BOOL)flashed;

#pragma mark -- daily signature

/**
 *  @brief 是否需要显示弹框 每天仅显示一次
 *
 *  @return 是否需要
 */
- (BOOL)shouldFlashSignToday;

/**
 *  @brief 今日是否已签到
 *
 *  @return 是否签到
 */
- (BOOL)wetherSigned;

/**
 *  @brief 今日签到
 *
 *  @param sign 签到
 *
 *  @return 签到结果
 */
- (BOOL)signatured:(BOOL)sign;

#pragma mark -- 首页 Banner(note:此数据可以暂时不缓存)

/**
 *  @brief 获取缓存的banner
 *
 *  @return banner
 */
- (NSDictionary *)getBanner;

/**
 *  @brief 缓存banner
 *
 *  @param banner 信息
 *
 *  @return 缓存结果
 */
- (BOOL)saveBanner:(NSDictionary *)banner;

#pragma mark -- 首页 第一页活动数据

/**
 *  @brief 获取缓存活动
 *
 *  @return 活动
 */
- (NSArray *)getActivities;

/**
 *  @brief 清除缓存活动
 *
 *  @return 清除结果
 */
- (BOOL)clearExpiredActivities;

/**
 *  @brief 缓存第一页活动列表
 *
 *  @param list 列表
 *
 *  @return 缓存结果
 */
- (BOOL)saveActivities:(NSDictionary *)activity;

@end

extern NSString * const NH_ADS_CACHE_NAMESPACE;
extern NSString * const NH_ADS_CACHE_DIRECTORY;

NS_ASSUME_NONNULL_END
