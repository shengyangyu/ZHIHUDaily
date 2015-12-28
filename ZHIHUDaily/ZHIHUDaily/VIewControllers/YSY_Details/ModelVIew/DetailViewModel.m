//
//  DetailViewModel.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/28.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "DetailViewModel.h"

@interface DetailViewModel ()

@end

@implementation DetailViewModel

- (void)getDetailWithID:(u_int64_t)mID {
    // 无效id
    if (mID <= 0) {
        return;
    }
    [[YSY_RequestClient sharedClient] GET:[NSString stringWithFormat:@"%@%@",story_Api,@(mID)] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.mDetailModel = [DetailModel yy_modelWithJSON:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSString *)mHTMLString {
    return [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",_mDetailModel.css[0],_mDetailModel.body];
}

- (NSString *)mShareURL {
    return _mDetailModel.share_url;
}

- (NSString *)mImageURL {
    return _mDetailModel.image;
}

- (NSString *)mImageName {
    return [NSString stringWithFormat:@"图片: %@",_mDetailModel.image_source];
}

- (u_int64_t)mType {
    return _mDetailModel.type;
}

- (NSArray *)mRecommenders {
    return _mDetailModel.recommenders;
}

@end
