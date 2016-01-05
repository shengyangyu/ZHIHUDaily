//
//  ThemeListModel.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/4.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "ThemeListModel.h"

@implementation ThemeStories

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"mID":@"id"};
}

@end

@implementation ThemeEditors

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"mID":@"id"};
}

@end


@implementation ThemeLists

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"des":@"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"stories":ThemeStories.class ,@"editors":ThemeEditors.class };
}

+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withIndex:(u_int64_t)mIndex withBlock:(void(^)(ThemeLists *themes, NSError *error))block {
    
    NSString *mBeforeString = @"";
    if (mIndex != -1) {
        mBeforeString = [NSString stringWithFormat:@"/before/%@",@(mIndex)];
    }
    return [[YSY_RequestClient sharedClient] GET:[NSString stringWithFormat:@"%@%@%@",themesextra_Api,@(mID),mBeforeString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ThemeLists *themes = [ThemeLists yy_modelWithJSON:responseObject];
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
