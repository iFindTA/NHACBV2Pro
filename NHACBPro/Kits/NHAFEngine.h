//
//  NHAFEngine.h
//  NHCerSecurityPro
//
//  Created by hu jiaju on 15/7/30.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//  nanhujiaju@gmail.com---https://github.com/iFindTA

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface NHAFEngine : AFHTTPSessionManager

/**
 *	@brief	network engine singleton
 *
 *	@return	instance
 */
+ (NHAFEngine *)share;

/**
 *  @brief init and setup for something
 */
- (void)setup;

/**
 *  @brief wether wifi en
 *
 *  @return true if throw wifi
 */
- (BOOL)wifiEnable;

/**
 *	@brief	cancel a request
 *
 *	@param 	path 	the request's path
 */
- (void)cancelRequestForpath:(NSString *)path;

#pragma mark -- POST --

- (void)GET:(NSString *)path parameters:(nullable id)params vcr:(nullable UIViewController *)vcr view:(nullable UIView *)view success:(void(^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObj))success failure:(void(^)(NSURLSessionDataTask *_Nullable task, NSError *error))failure;

- (void)GET:(NSString *)path parameters:(nullable id)params vcr:(nullable UIViewController *)vcr view:(nullable UIView *)view hudEnable:(BOOL)hud success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)POST:(NSString *)path parameters:(nullable id)parameters vcr:(UIViewController * _Nullable)vcr view:(UIView * _Nullable)view success:(void (^)(NSURLSessionDataTask *task, id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (void)PUT:(NSString *)path parameters:(nullable id)params vcr:(UIViewController * _Nullable)vcr view:(UIView * _Nullable)view success:(void (^)(NSURLSessionDataTask * task,id _Nullable responseObj))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * error))failure;

NS_ASSUME_NONNULL_END

@end
