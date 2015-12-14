//
//  YSY_HttpRequest.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSY_HttpRequest.h"

static NSString * const YSYBaseURLString = @"http://news-at.zhihu.com/";

@implementation YSY_RequestClient

+ (instancetype)sharedClient {
    static YSY_RequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[YSY_RequestClient alloc] initWithBaseURL:[NSURL URLWithString:YSYBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"无网络");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    NSLog(@"WiFi网络");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    NSLog(@"无线网络");
                    break;
                }
                default:
                    break;
            }
        }];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

@end

@implementation YSY_HttpRequest

+ (NSURLSessionDataTask *)httpRequest:(NSString *)url
                            extraParams:(NSMutableDictionary *)extraParams
                              className:(NSString *)className
                                 object:(id)object
                                 action:(SEL)action
                              operation:(NSURLSessionDataTask *)op
                                isSSL:(BOOL)isSSL {

    // client.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block typeof(self) _object = object;// 防止循环引用
    op = [[YSY_RequestClient sharedClient] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject &&
            [_object respondsToSelector:action]) {
            // 转换
            Class mClass = NSClassFromString(className);
            BOOL isSuccess = [mClass yy_modelSetWithJSON:responseObject];
            if (isSuccess) {
                SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( if ([_object respondsToSelector:action]) { [_object performSelector:action withObject:[mClass yy_modelWithJSON:responseObject]];} );
            }
            else {
                SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( if ([_object respondsToSelector:action]) { [_object performSelector:action withObject:responseObject];} );
            }
        }
        else {
            SEL failMethod = NSSelectorFromString(@"failWithErrorText:");
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(if ([_object respondsToSelector:failMethod]) { [_object performSelector:failMethod withObject:@"返回数据为空"]; } );
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SEL failMethod = NSSelectorFromString(@"failWithErrorText:");
        SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(if ([_object respondsToSelector:failMethod]) { [_object performSelector:failMethod withObject:@"请求异常"]; } );
    }];
    return op;
}

@end
