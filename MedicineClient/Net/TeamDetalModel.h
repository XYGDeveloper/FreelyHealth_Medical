//
//  TeamDetalModel.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamDetalModel : NSObject

//name	string	是	医生名称
//dname	string	是	科室名称
//job	string	是	职务
//hname	string	是	医院名称
//introduction	string	是	简介
//agreenum	int	是	好评数
//backnum	int	是	回答数
//facepath	string	是	头像路径
//id	string	是	医生id

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *backnum;

@property (nonatomic,copy)NSString *agreenum;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *shareurl;

@property (nonatomic,copy)NSString *menzhen;

@end
