//
//  DetailModel.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/28.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *image_source;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) u_int64_t type;
@property (nonatomic, assign) u_int64_t mID;
@property (nonatomic, strong) NSArray *css;
@property (nonatomic, strong) NSArray *recommenders;
@property (nonatomic, strong) NSArray *theme;

@end
