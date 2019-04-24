//
//  BGLoadingHUD.h
//  HotelClient
//
//  Created by 黄雄彪 on 16/6/30.
//  Copyright © 2016年 sihan. All rights reserved.
//

#import <UIKit/UIKit.h>

//  gif指示器的提示颜色
#define kINFOCOLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 菊花怪颜色
#define kACTIVITYCOLOR [UIColor redColor]

@interface BGLoadingHUD : UIView

@property(nonatomic,strong)UILabel *infolabel;//加载标签
@property(nonatomic,strong)UIView *bgView;//透明背景

@property(nonatomic,strong)UIColor *infoColor;//标签颜色。
/**  
 *      显示加载指示器
 *      message     显示的信息
 *      view        显示在某个视图上
 *      filePath    显示的gif文件路径
 */
+(BGLoadingHUD *)showMessage:(NSString *)message toView:(UIView *)view withGifFilePath:(NSString*)filePath;
/**  
 *      显示加载指示器，gif为默认的文件
 *      message     显示的信息
 *      view        显示在某个视图上
 *
 */
+ (BGLoadingHUD *)showMessage:(NSString*)message toView:(UIView *)view;
//  隐藏指示器
+ (void)hideHUDForView:(UIView *)view;

/**
 *      显示加载指示器，指示器为菊花怪
 *      message     显示的信息
 *      view        显示在某个视图上
 *
 */
+(BGLoadingHUD *)showCommonMessage:(NSString *)message toView:(UIView *)view;
//  隐藏指示器
+(void)hideCommonHUDForView:(UIView *)view;
-(void)showSuccessWithIcon:(NSString*)icon;

@end
