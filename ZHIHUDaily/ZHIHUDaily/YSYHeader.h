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
#import "YSY_NetWorkManage.h"

/**** UI Size ****/
#define __MainScreenFrame [[UIScreen mainScreen] bounds]
#define __MainScreen_Width  __MainScreenFrame.size.width
#define __MainScreen_Height (__MainScreenFrame.size.height - 20)
 // 缩放比例 640为设计图尺寸
#define __MainScreen_Scale (__MainScreen_Width/320.0)
#define __LeftScreen_Width (225.0/320*__MainScreen_Width) // leftVC 宽度
#define __View_Scale(x) (x * (__MainScreen_Width/320.0))
/**** Global set ****/

/**** RestorationIdentifier ****/
#define YSY_LeftVC_Key @"YSY_LeftVC_Key"
#define YSY_MainVC_Key @"YSY_MainVC_Key"





#endif /* YSYHeader_h */
