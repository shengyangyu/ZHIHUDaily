//
//  DetailViewModel.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/28.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"

@interface DetailViewModel : NSObject

@property (nonatomic, strong) DetailModel *mDetailModel;
@property (nonatomic, assign) u_int64_t mModelID;
@property (nonatomic, copy, readonly) NSString *mHTMLString;
@property (nonatomic, copy, readonly) NSString *mShareURL;
@property (nonatomic, copy, readonly) NSString *mImageURL;
@property (nonatomic, copy, readonly) NSString *mImageName;
@property (nonatomic, assign, readonly) u_int64_t mType;
@property (nonatomic, strong, readonly) NSArray *mRecommenders;

- (void)getDetailWithID:(u_int64_t)mID;

@end
