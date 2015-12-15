//
//  ThemeListCell.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ThemeListCell.h"

@implementation ThemeStories

+ (NSArray *)modelPropertyBlacklist {
    return @[@"tFrame",@"cFrame"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"mID":@"id"};
}

@end

@implementation ThemeEditors

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"mID":@"id"};
}

@end


@implementation ThemeLists

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"des":@"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"stories":ThemeStories.class ,@"editors":ThemeEditors.class };
}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    // default
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    // customer
    self.clipsToBounds = YES;
    _mIcon = ({
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView insertSubview:image atIndex:0];
        image;
    });
    _mTitle = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor convertHexToRGB:@"383838"];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        label;
    });
    // line
    ({
        
    });
    
    return self;
}

- (void)setCellModel:(ThemeStories *)base {
    
    [self clearCell];
    
}

- (void)drawCell {

}


- (void)clearCell {
    
    if (!_mDrawed) {
        return;
    }
    
    _mIcon.frame = CGRectZero;
    _mIcon = nil;
    
    _mTitle.text = @"";
    
    _mDrawed = NO;
}

@end
