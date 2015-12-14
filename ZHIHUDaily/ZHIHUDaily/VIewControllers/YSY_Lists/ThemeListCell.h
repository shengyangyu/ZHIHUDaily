//
//  ThemeListCell.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeStories : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, assign) uint64_t type;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *title;

@end

@interface ThemeEditors : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end

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

@interface ThemeListCell : UITableViewCell

@end
