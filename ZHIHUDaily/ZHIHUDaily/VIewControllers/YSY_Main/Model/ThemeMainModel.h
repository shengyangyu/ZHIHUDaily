//
//  ThemeMainModel.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeListModel.h"

@interface ThemeMainModel : NSObject

@property (nonatomic, strong) NSArray *top_stories;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, copy) NSString *c_date;

+ (NSURLSessionDataTask *)themesLateWithBlock:(void(^)(ThemeMainModel *themes, NSError *error))block;


@end

@interface ThemeMainBeforeModel : NSObject

@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, copy) NSString *c_date;

+ (NSURLSessionDataTask *)themesBeforeWithDate:(NSString *)mDate withBlock:(void(^)(ThemeMainBeforeModel *themes, NSError *error))block;

@end
