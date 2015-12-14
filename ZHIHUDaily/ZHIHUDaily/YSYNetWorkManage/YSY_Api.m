//
//  YSY_Api.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSY_Api.h"

@implementation YSY_Api

const NSTimeInterval kRequestTimeOutInSeconds = 30.0;
NSString * const kSuccessCode = @"0000";

NSString * const kServiceUrl = @"news-at.zhihu.com";
NSString * const startImage_Api = @"api/4/start-image/1080*1776";
NSString * const version_Api = @"api/4/version/ios/2.3.0";
NSString * const latest_Api = @"api/4/news/latest";
NSString * const downloadnews_Api = @"api/4/news/3892357";
NSString * const beforenews_Api = @"api/4/news/before/20131119";
NSString * const storyextra_Api = @"api/4/story-extra/#{id}";
NSString * const longcomments_Api = @"api/4/story/4232852/long-comments";
NSString * const shorcommentst_Api =@"api/4/story/4232852/short-comments";
NSString * const themes_Api = @"api/4/themes";
NSString * const themesextra_Api = @"api/4/theme/";

NSString * const newshot_Api = @"api/3/news/hot";
NSString * const sections_Api = @"api/3/sections";
NSString * const sectionsshow_Api = @"api/3/section/1";

@end
