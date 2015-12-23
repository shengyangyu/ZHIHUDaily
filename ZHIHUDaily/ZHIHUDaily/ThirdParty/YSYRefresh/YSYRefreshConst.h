//
//  YSYRefreshConst.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// 运行时objc_msgSend
#define YSYRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define YSYRefreshMsgTarget(target) (__bridge void *)(target)

// 状态检查
#define YSYRefreshCheckState \
YSYRefreshState oldState = self.mState; \
if (mState == oldState) return; \
[super setMState:mState];

/**********常量***********/
UIKIT_EXTERN const CGFloat YSYRefreshAnimationDuration;
UIKIT_EXTERN const CGFloat YSYRefreshFootHeight;

// kvo key
UIKIT_EXTERN NSString *const YSYRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const YSYRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const YSYRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const YSYRefreshKeyPathPanState;