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

    //client.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@",kServiceUrl,url];
    __block typeof(self) _object = object;// 防止循环引用
    op = [[YSY_RequestClient sharedClient] GET:@"api/4/themes" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    
//    op = [client POST:urlString parameters:extraParams success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSString *tmpJason = [NSString jsonStringWithObject:responseObject];
//        if (tmpJason == nil) {
//            [_object performSelector:@selector(failWithErrorText:) withObject:@"返回数据为空"];
//            return ;
//        }
//        SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( if ([_object respondsToSelector:action]) { [_object performSelector:action withObject:[AFHttpRequest decodeJsonStr:tmpJason withClsName:className]];} );
        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        if ([_object respondsToSelector:@selector(failWithErrorText:)]){
//            [_object performSelector:@selector(failWithErrorText:) withObject:@"请求异常"];}
//    }];
    return op;
}

@end
