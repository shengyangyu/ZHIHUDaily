//
//  YSYGestureRecognizer.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/5.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/// State of the gesture
typedef NS_ENUM(NSUInteger, YSYGestureRecognizerState) {
    YSYGestureRecognizerStateBegan, ///< gesture start
    YSYGestureRecognizerStateMoved, ///< gesture moved
    YSYGestureRecognizerStateEnded, ///< gesture end
    YSYGestureRecognizerStateCancelled, ///< gesture cancel
};

@interface YSYGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nonatomic, copy) void (^action)(YSYGestureRecognizer *gesture, YSYGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end
