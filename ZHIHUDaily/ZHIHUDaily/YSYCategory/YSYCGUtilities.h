//
//  YSYCGUtilities.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/5.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
YY_EXTERN_C_BEGIN

/// Get main screen's scale.
CGFloat YYScreenScale();

/// Get main screen's size. Height is always larger than width.
CGSize YYScreenSize();

/// Convert pixel to point.
static inline CGFloat CGFloatFromPixel(CGFloat value) {
    return value / YYScreenScale();
}



// main screen's scale
#ifndef kScreenScale
#define kScreenScale YYScreenScale()
#endif

// main screen's size (portrait)
#ifndef kScreenSize
#define kScreenSize YYScreenSize()
#endif

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth YYScreenSize().width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight YYScreenSize().height
#endif

YY_EXTERN_C_END