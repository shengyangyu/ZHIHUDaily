//
//  YSY_HttpRequest.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "YSY_Api.h"

#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \

@interface YSY_RequestClient : AFHTTPSessionManager
/**
 *生成一个请求实例
 */
+ (instancetype)sharedClient;
@end

@interface YSY_HttpRequest : NSObject

/**
 *Http请求函数
 *param: url         --API名
 *param: extraParams --API请求参数
 *param: className   --JSON解析后，所要得到的class类型名
 *param: object      --调用的界面句柄
 *param: action      --回调函数方法
 *param: op          --请求操作
 */
+ (NSURLSessionDataTask *)httpRequest:(NSString *)url
                            extraParams:(NSMutableDictionary *)extraParams
                              className:(NSString *)className
                                 object:(id)object
                                 action:(SEL)action
                              operation:(NSURLSessionTask *)op isSSL:(BOOL)isSSL;

@end
