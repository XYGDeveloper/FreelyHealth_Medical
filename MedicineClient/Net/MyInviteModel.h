//
//  MyInviteModel.h
//  MedicineClient
//
//  Created by xyg on 2017/12/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInviteModel : NSObject

@property (nonatomic,copy)NSString *createuser;  //发起人

@property (nonatomic,copy)NSString *item;  //主题
@property (nonatomic,copy)NSString *createtime;  //创建时间

@property (nonatomic,strong)NSString *id;


@end
