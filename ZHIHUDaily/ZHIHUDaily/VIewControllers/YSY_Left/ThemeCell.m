//
//  ThemeCell.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ThemeCell.h"

@implementation ZHBaseThemes

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"mID":@"id", @"des":@"description" };
}

@end

@implementation ZHThemes

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"others":ZHBaseThemes.class };
}

+ (NSURLSessionDataTask *)themesWithBlock:(void(^)(ZHThemes *themes, NSError *error))block {
    
    return [[YSY_RequestClient sharedClient] GET:themes_Api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ZHThemes *themes = [ZHThemes yy_modelWithJSON:responseObject];
        // 请求成功
        if (block) {
            block(themes, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (block) {
            block([ZHThemes new], error);
        }
    }];
}

@end

@implementation ThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    // default
    self.contentView.backgroundColor = [UIColor convertHexToRGB:@"232A30"];
    self.backgroundView.backgroundColor = [UIColor convertHexToRGB:@"232A30"];
    self.textLabel.backgroundColor = [UIColor clearColor];
    // select
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor convertHexToRGB:@"1B2228"];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    // customer accessoryView
    self.mAccessBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(accessAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(__View_Scale(51.0f), __View_Scale(51.0f)));
            make.top.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-__View_Scale(17.0f));
        }];
        btn;
    });
    
    return self;
}

- (void)setCellModel:(ZHBaseThemes *)base {
    self.textLabel.text = base.name;
    [self.mAccessBtn setImage:[UIImage imageNamed:@"Menu_Follow"] forState:UIControlStateNormal];
}

- (void)accessAction:(UIButton *)sender {


}

@end
