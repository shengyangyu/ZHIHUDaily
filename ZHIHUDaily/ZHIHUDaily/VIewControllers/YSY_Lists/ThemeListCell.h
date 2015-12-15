//
//  ThemeListCell.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 主题详情
 */
@interface ThemeStories : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, assign) uint64_t type;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSValue *tFrame;
@property (nonatomic, strong) NSValue *cFrame;

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


+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withBlock:(void(^)(ThemeLists *themes, NSError *error))block;

@end

/**
 主题信息cell
 */
@interface ThemeListCell : UITableViewCell

// 插图
@property (nonatomic, strong) UIImageView *mIcon;
// 标题
@property (nonatomic, strong) UILabel *mTitle;
// 已经绘制
@property (nonatomic, assign) BOOL mDrawed;
// 值
@property (nonatomic, strong) ThemeStories *mData;

- (void)setCellModel:(ThemeStories *)base;

- (void)clearCell;

- (void)drawCell;

@end
