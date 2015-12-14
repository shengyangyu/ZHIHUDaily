//
//  ThemeListCell.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThemeLists : NSObject

+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withBlock:(void(^)(ThemeLists *themes, NSError *error))block;

@end

@interface ThemeListCell : UITableViewCell

@end
