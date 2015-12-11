//
//  YSY_NetWorkManage.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSY_NetWorkManage.h"
#import <objc/runtime.h>

@implementation YSY_NetWorkManage

- (instancetype)initWithApi:(NSString *)apiName
                targetClass:(NSString *)targetClass
                     params:(NSMutableDictionary *)params
                   delegate:(id)delegate {
    self = [super init];
    if (self) {
        _mApiName = apiName;
        _mTargetString = targetClass;
        _mParams = params;
        _delegate = delegate;
        _mTargetClass = object_getClass(delegate);
    }
    return self;
}

- (void)beginServiceRequestWithSSL:(BOOL)isSSL {
    // 有网络
    if (1/*[[AFNetworkReachabilityManager manager] isReachable]*/) {
        self.mSession = [YSY_HttpRequest httpRequest:self.mApiName extraParams:self.mParams className:self.mTargetString object:self.mTargetClass action:@selector(backCall:) operation:self.mSession isSSL:isSSL];
    }
    // 无网络
    else {
    
    }
}

/**
 * 响应回调
 * jsonObject :返回的对象
 * jsonObject可为NSDictionary
 */
- (void)backCall:(id)jsonObject {
    // 返回值是 NSDictionary
    /*if (jsonObject &&
        [jsonObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *retObj = (NSDictionary*)jsonObject;
        if (![retObj[@"returnCode"] isEqualToString:SUCCESS_CODE]) {
            
            [self failWithErrorText:retObj[@"returnMessage"]  errorCode:[retObj[@"returnCode"] integerValue]];
        }
        else {
            [self excuteSuccess:jsonObject];
        }
    }
    else {
        US_ResponseBase *retObj = (US_ResponseBase*)jsonObject;
        if (!retObj) {
            [self failWithErrorText:@""];
            
        }else if (![retObj.returnCode isEqualToString:SUCCESS_CODE]) {
            NSString *errorString = @"";
            if (retObj.returnMessage && retObj.returnMessage.length != 0) {
                errorString = retObj.returnMessage;
            }
            [self failWithErrorText:errorString errorCode:retObj.returnCode.integerValue];
        }
        else
        {
            [self excuteSuccess:jsonObject];
        }
    }*/
}


- (void)dealloc {
    // 清除参数
    if (_mParams) {
        [_mParams removeAllObjects];
        _mParams = nil;
    }
    // 断开代理
    if (_delegate) {
        _delegate = nil;
    }
    // 取消请求
    if (_mSession) {
        [_mSession cancel];
    }
}

@end
