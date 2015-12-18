//
//  ThemeListCell.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ThemeListCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ThemeStories

+ (NSArray *)modelPropertyBlacklist {
    return @[@"cellHeight"];
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

+ (NSURLSessionDataTask *)themesListsID:(u_int64_t)mID withIndex:(u_int64_t)mIndex withBlock:(void(^)(ThemeLists *themes, NSError *error))block {
    
    NSString *mBeforeString = @"";
    if (mIndex != -1) {
        mBeforeString = [NSString stringWithFormat:@"/before/%@",@(mIndex)];
    }
    return [[YSY_RequestClient sharedClient] GET:[NSString stringWithFormat:@"%@%@%@",themesextra_Api,@(mID),mBeforeString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ThemeLists *themes = [ThemeLists yy_modelWithJSON:responseObject];
        // 请求成功
        if (block) {
            block(themes, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (block) {
            block(nil, error);
        }
    }];
}

@end

@interface ThemeListCell ()

@property (nonatomic, strong) UIView *mLine;

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
    [self createUI];
    [self autolayoutUI];
    
    return self;
}

- (void)createUI {
    _mIcon = ({
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView insertSubview:image atIndex:0];
        image;
    });
    _mTitle = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:__View_Scale(18.0)];
        label.textColor = [UIColor convertHexToRGB:@"383838"];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        label;
    });
    _mLine = ({
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor convertHexToRGB:@"E8E8E8"];
        [self.contentView addSubview:line];
        line;
    });
}

/**
 在此方法内使用 Masonry 设置控件的约束,设置约束不需要在layoutSubviews中设置，只需要在初始化的时候设置
 */
- (void)autolayoutUI {
    // 左右距离
    CGFloat mpadding = __View_Scale(15.0);
    // cell文字最大宽度
    [self.mTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).offset(mpadding);
    }];
    [self.mIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(__View_Scale(75.0), __View_Scale(60.0)));
        make.top.equalTo(self.mTitle.mas_top);
        make.left.equalTo(self.mTitle.mas_right);
        make.right.mas_equalTo(self.contentView).offset(-mpadding);
    }];
    
    [self.mLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.top.mas_greaterThanOrEqualTo(self.mTitle.mas_bottom).offset(mpadding);
        make.top.mas_greaterThanOrEqualTo(self.mIcon.mas_bottom).offset(mpadding);
        make.left.equalTo(self.mTitle.mas_left);
        make.right.equalTo(self.mIcon.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1.0);
    }];
}

- (void)setMData:(ThemeStories *)mData {
    _mData = mData;
    self.mTitle.text = self.mData.title;
    if (self.mData.images && self.mData.images.count != 0) {
        [self.mIcon setImageWithURL:[NSURL URLWithString:self.mData.images[0]]];
        [self.mIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(__View_Scale(75.0), __View_Scale(60.0)));
        }];
    }
    else {
        self.mIcon.image = nil;
        [self.mIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(__View_Scale(0.0), __View_Scale(0.0)));
        }];
    }
}

@end
