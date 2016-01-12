//
//  YSYHeader.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#ifndef YSYHeader_h
#define YSYHeader_h

/**** file path ****/
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import <YYModel/YYModel.h>
#import <YYWebImage/YYWebImage.h>
#import <AFNetworking/AFNetworking.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "YSY_NetWorkManage.h"

/**** UI Size ****/
#define __MainScreenFrame [[UIScreen mainScreen] bounds]
#define __MainScreen_Width  __MainScreenFrame.size.width
#define __MainScreen_Height __MainScreenFrame.size.height
#define __MainScreen_Height_1 (__MainScreenFrame.size.height - 20)
 // 缩放比例 640为设计图尺寸
#define __MainScreen_Scale (__MainScreen_Width/320.0)
#define __LeftScreen_Width (225.0/320*__MainScreen_Width) // leftVC 宽度
#define __View_Scale(x) (x * (__MainScreen_Width/320.0))
/**** Global set ****/

/**** RestorationIdentifier ****/
#define YSY_LeftVC_Key @"YSY_LeftVC_Key"
#define YSY_MainVC_Key @"YSY_MainVC_Key"


/**** yykit copy ****/

#ifdef __cplusplus
#define YY_EXTERN_C_BEGIN  extern "C" {
#define YY_EXTERN_C_END  }
#else
#define YY_EXTERN_C_BEGIN
#define YY_EXTERN_C_END
#endif


YY_EXTERN_C_BEGIN

#ifndef kSystemVersion
#define kSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#ifndef YYSYNTH_DUMMY_CLASS
#define YYSYNTH_DUMMY_CLASS(_name_) \
@interface YYSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation YYSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

YY_EXTERN_C_END

#endif /* YSYHeader_h */
