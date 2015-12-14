//
//  ThemeListCell.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ThemeListCell.h"

@implementation ThemeLists

+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withBlock:(void(^)(ThemeLists *themes, NSError *error))block {
    
    return [[YSY_RequestClient sharedClient] GET:[NSString stringWithFormat:@"%@%@",themesextra_Api,@(mID)] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ThemeLists *themes = [ThemeLists yy_modelWithJSON:responseObject];
        // 请求成功
        if (block) {
            block(themes, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (block) {
            block([ThemeLists new], error);
        }
    }];
}

@end


@implementation ThemeListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
