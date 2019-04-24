//
//  GetAuthStateManager.h
//  MedicineClient
//
//  Created by XI YANGUI on 2018/4/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyProfilwModel;
typedef void(^CallBackBlock)(NSString *auth);  // 回调
@interface GetAuthStateManager : NSObject
+ (instancetype)shareInstance; // 单例
- (void)getAuthStateWithallBackBlock:(CallBackBlock)callBackBlock;

@end
