//
//  PhotoPickManager.h
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerType)
{
    PickerType_Camera = 0, // 拍照
    PickerType_Photo, // 照片
};

typedef void(^CallBackBlock)(NSDictionary *infoDict, BOOL isCancel);  // 回调

@interface PhotoPickManager : NSObject

+ (instancetype)shareInstance; // 单例

- (void)presentPicker:(PickerType)pickerType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock;

@end
