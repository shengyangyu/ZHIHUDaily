//
//  NSTimer+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/14.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YSYCategory)

- (void)stopTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
