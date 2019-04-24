//
//  UpdateProfileRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface updateProfileHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface updateProfileBody : NSObject

//name	string	是	名称
//sex	string	是	性别
//email	string	是	邮箱
//hname	int	是	医院名
//dname	String	是	科室
//pname	String	是	职称
//introduction 	String	是	详情
//certification	String	是	资格证
//workcard 	String	是	工牌

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *email;

//hid	String	是	医院id
//did	String	是	科室id
//pid	String	是	职称id

@property (nonatomic,copy)NSString *hid;

@property (nonatomic,copy)NSString *did;

@property (nonatomic,copy)NSString *pid;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *menzhen;

@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *certification;

@property (nonatomic,copy)NSString *workcard;

@property (nonatomic,copy)NSString *hospitalname;   //新添加的医院名

@property (nonatomic,copy)NSString *departmentname; //新添加的科室名

@end


@interface UpdateProfileRequest : NSObject


@property (nonatomic,strong)updateProfileHeader *head;

@property (nonatomic,strong)updateProfileBody *body;

@end
