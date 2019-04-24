//
//  UpdateProfileModel.h
//  MedicineClient
//
//  Created by L on 2017/8/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateProfileModel : NSObject

@property (nonatomic,copy)NSString *email;

@property (nonatomic,copy)NSString *workcard;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *tname;

@property (nonatomic,copy)NSString *did;

@property (nonatomic,copy)NSString *hid;

@property (nonatomic,copy)NSString *pid;

@property (nonatomic,copy)NSString *certification;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *pname;

@property (nonatomic,copy)NSString *menzhen;

@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *isauthenticate;

@property (nonatomic,copy)NSString *hospitalname;   //新添加的医院名

@property (nonatomic,copy)NSString *departmentname; //新添加的科室名


@end
