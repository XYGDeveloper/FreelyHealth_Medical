//
//  PSBottomBar.h
//  PSGenericClass
//
//  Created by Ryan_Man on 16/6/14.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    
    BottomBarType_Original,
    BottomBarType_Up
    
}BottomBarType;

typedef void (^clickBarBlock)(BottomBarType type);

@interface PSBottomBar : UIView
@property (nonatomic,copy)clickBarBlock block;
@end
