//
//  ThemeMainModel.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "ThemeMainModel.h"

@implementation ThemeMainModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"c_date":@"date"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"stories":ThemeStories.class ,
              @"top_stories":ThemeStories.class };
}

+ (NSURLSessionDataTask *)themesLateWithBlock:(void(^)(ThemeMainModel *themes, NSError *error))block {
    
    return [[YSY_RequestClient sharedClient] GET:h_latest_Api parameters:@{@"client":@"0"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ThemeMainModel *themes = [ThemeMainModel yy_modelWithJSON:responseObject];
        // 请求成功
        if (block) {
            block(themes, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (block) {
            block(nil, error);
        }
    }];
}


@end


@implementation ThemeMainBeforeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"c_date":@"date"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"stories":ThemeStories.class };
}

+ (NSURLSessionDataTask *)themesBeforeWithDate:(NSString *)mDate withBlock:(void(^)(ThemeMainBeforeModel *themes, NSError *error))block {
    return [[YSY_RequestClient sharedClient] GET:[NSString stringWithFormat:@"%@%@",h_before_Api,mDate] parameters:@{@"client":@"0"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ThemeMainBeforeModel *themes = [ThemeMainBeforeModel yy_modelWithJSON:responseObject];
        // 请求成功
        if (block) {
            block(themes, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (block) {
            block(nil, error);
        }
    }];
}

@end
