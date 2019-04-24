//
//  MeViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/11.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+PS.h"
#import "UIView+PS.h"

//#import "PSBottomBar.h"
#define Max_OffsetY  50

#define WeakSelf(x)      __weak typeof (self) x = self

#define HalfF(x) ((x)/2.0f)

#define  kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)
@interface MeViewController : UIViewController

@end
