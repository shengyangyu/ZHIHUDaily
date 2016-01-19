//
//  YSYSectionHeadView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/14.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYSectionHeadView.h"

const CGFloat kMainHeaderHeight = 36.0f;

@implementation YSYSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kMainHeaderHeight)];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.ysy_centerX = self.ysy_width/2;
}

- (void)setDataModel:(NSString *)model {
    self.contentView.backgroundColor = [UIColor ysy_convertHexToRGB:@"00AFF5"];
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[self stringConvertToTitle:model] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor whiteColor] ,NSBackgroundColorAttributeName:[UIColor ysy_convertHexToRGB:@"00AFF5"]}];
}

- (NSString *)stringConvertToTitle:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:str];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CH"];
    [formatter setDateFormat:@"MM月dd日 EEEE"];
    NSString *sectionTitleText = [formatter stringFromDate:date];
    
    return sectionTitleText;
}

@end
