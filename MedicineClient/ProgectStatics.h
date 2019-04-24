//
//  ProgectStatics.h
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#ifndef ProgectStatics_h
#define ProgectStatics_h

//全局宏定义区---------------------------

#define Font(a) [UIFont systemFontOfSize:a]

#define BFont(a) [UIFont boldSystemFontOfSize:a]

#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define HexColorA(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 \
alpha:a]

//weak, strong操作-----------------------

#define weakify(var) __weak typeof(var) ZGWeak_##var = var;

#define strongify(var) \
_Pragma("clang  diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = ZGWeak_##var; \
_Pragma("clang diagnostic pop")

//-----------------------------------------

//常用颜色宏定义--------------------------

#define Navigation_titlecolor HexColor(0xffffff) //导航白色标题

#define AppStyleColor HexColor(0x61C9DD) //主题蓝色

#define DefaultBackgroundColor HexColor(0xF4F4F4) //默认背景色

#define DefaultGrayTextClor HexColor(0x666666) //默认灰色字体颜色

#define DefaultGrayLightTextClor HexColor(0x999999) //默认浅色灰色字体颜色

#define DefaultRedTextClor HexColor(0xf02b20) //默认灰色字体颜色

#define DefaultBlackLightTextClor HexColor(0x333333) //默认深黑色字体颜色

#define DefaultBlackLightTextClor HexColor(0x333333) //默认深黑色字体颜色

#define DefaultBlueTextClor HexColor(0x4DA8F0) //默认蓝色字体颜色

#define DividerGrayColor HexColor(0xCFCFCF) //灰色分隔线颜色

#define DividerDarkGrayColor HexColor(0xd6d7dc) //深灰色分隔线

#define tabarTextColor HexColor(0x68D8C8) //默认背景色

#define PriceColor HexColor(0xd63d3e) //默认背景色

#endif /* ProgectStatics_h */
