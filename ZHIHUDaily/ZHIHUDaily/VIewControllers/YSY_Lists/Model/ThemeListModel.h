//
//  ThemeListModel.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/4.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 主题详情
 */
@interface ThemeStories : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, assign) uint64_t type;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *title;

@end
/**
 主题编辑者
 */
@interface ThemeEditors : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end

/**
 主题信息列表
 */
@interface ThemeLists : NSObject

@property (nonatomic, assign) uint64_t color;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *editors;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *image_source;
@property (nonatomic, copy) NSString *name;


+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withIndex:(u_int64_t)mIndex withBlock:(void(^)(ThemeLists *themes, NSError *error))block;

@end
