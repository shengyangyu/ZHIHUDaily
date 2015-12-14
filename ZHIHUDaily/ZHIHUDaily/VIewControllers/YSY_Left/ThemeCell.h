//
//  ThemeCell.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 主题详细
 */
@interface ZHBaseThemes : NSObject

@property (nonatomic, assign) uint64_t mID;
@property (nonatomic, assign) uint64_t color;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *thumbnail;

@end

/**
 主题列表
 */
@interface ZHThemes : NSObject

@property (nonatomic, assign) uint64_t limit;
@property (nonatomic, strong) NSArray *others;

+ (NSURLSessionDataTask *)themesWithBlock:(void(^)(ZHThemes *themes, NSError *error))block;

@end

/**
 主题列表cell
 */
@interface ThemeCell : UITableViewCell

// 自定义扩展button
@property (nonatomic, strong) UIButton *mAccessBtn;

- (void)setCellModel:(ZHBaseThemes *)base;

@end
