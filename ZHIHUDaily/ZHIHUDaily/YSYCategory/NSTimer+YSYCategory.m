//
//  NSTimer+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/14.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "NSTimer+YSYCategory.h"

@implementation NSTimer (YSYCategory)

- (void)stopTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
