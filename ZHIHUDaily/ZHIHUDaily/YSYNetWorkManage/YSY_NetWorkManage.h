//
//  YSY_NetWorkManage.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSY_HttpRequest.h"
/**
 * 代理
 */
@protocol YSY_NetWorkDelegate <NSObject>
@optional
- (void)interfaceExcuteError:(NSError *)error
                     apiName:(NSString *)apiName
                     apiFlag:(NSString *)apiFlag;
- (void)interfaceExcuteSuccess:(id)retObj
                       apiName:(NSString *)apiName
                      apiFlag:(NSString *)apiFlag;
@end

@interface YSY_NetWorkManage : NSObject
// 请求的是url
@property(nonatomic, strong) NSString *mApiName;
// 用于一个页面请求相同api时标记
@property(nonatomic, strong) NSString *mFlagCommonApi;
// 目标类名
@property(nonatomic, strong) NSString *mTargetString;
// 当前持有代理 类
@property(nonatomic, strong) Class mTargetClass;
// body参数
@property(nonatomic, strong) NSMutableDictionary *mParams;
// 代理
@property(nonatomic, assign) id<YSY_NetWorkDelegate> delegate;
// 当前的请求
@property(nonatomic,strong) NSURLSessionDataTask* mSession;
/**
 * 初始化
 * apiName :请求的url段
 * targetClass :目标转换成的类
 * params :body参数
 * delegate :回调
 */
- (instancetype)initWithApi:(NSString *)apiName
                targetClass:(NSString *)targetClass
                     params:(NSMutableDictionary *)params
                   delegate:(id)delegate;
/**
 * 发送请求
 * isSSL :是否https
 */
- (void)beginServiceRequestWithSSL:(BOOL)isSSL;
@end
