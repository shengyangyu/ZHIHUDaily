//
//  YSY_Api.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  放置程序中的一些基本值

#import <Foundation/Foundation.h>

@interface YSY_Api : NSObject

// 超时时间
UIKIT_EXTERN const NSTimeInterval kRequestTimeOutInSeconds;
// 返回成功码
UIKIT_EXTERN NSString * const kSuccessCode;
/*****************API*******************/
// 域名
UIKIT_EXTERN NSString * const kServiceUrl;
// 启动界面图像 尺寸 320*432、480*728、720*1184、1080*1776
UIKIT_EXTERN NSString * const startImage_Api;
// 版本查询 当前版本 2.3.0
UIKIT_EXTERN NSString * const version_Api;
// 最新消息
UIKIT_EXTERN NSString * const latest_Api;
// 离线下载 消息id 3892357
UIKIT_EXTERN NSString * const downloadnews_Api;
// 过往消息 日期 20131119
// 知乎日报的生日为 2013年5月19日 若before后数字小于20130520 只会接收到空消息
UIKIT_EXTERN NSString * const beforenews_Api;
// 新闻额外信息 消息id id
UIKIT_EXTERN NSString * const storyextra_Api;
// 新闻对应长评论查看 消息id 4232852
UIKIT_EXTERN NSString * const longcomments_Api;
// 新闻对应短评论查看
UIKIT_EXTERN NSString * const shorcommentst_Api;
// 主题日报列表查看
UIKIT_EXTERN NSString * const themes_Api;
// 主题日报内容查看 主题日报的id 11
UIKIT_EXTERN NSString * const themesextra_Api;
// 信息详情 #{id}
UIKIT_EXTERN NSString * const story_Api;
/******请注意！ 此 API 仍可访问，但是其内容未出现在最新的『知乎日报』 App 中****/
// 热门消息
UIKIT_EXTERN NSString * const newshot_Api;
// 栏目总览 请注意！
UIKIT_EXTERN NSString * const sections_Api;
// 栏目具体消息查看 栏目的id 11
UIKIT_EXTERN NSString * const sectionsshow_Api;

@end
