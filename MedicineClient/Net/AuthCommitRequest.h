//
//  AuthCommitRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthCommitHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface AuthCommitBody : NSObject

//name	string	是	医生名称
//sex	string	是	性别
//email	string	是	邮箱
//hid	string	是	医院id
//did	string	是	科室id
//pid	string	是	职位id
//certification
//string	是	资格证图片地址
//workcard	string	是	工牌图片地址
//veriface	string	是	人脸识别图片地址
//signature
//string	是	签名图片地址

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *email;

@property (nonatomic,copy)NSString *hid;

@property (nonatomic,copy)NSString *did;

@property (nonatomic,copy)NSString *pid;

@property (nonatomic,copy)NSString *certification;

@property (nonatomic,copy)NSString *workcard;

@property (nonatomic,copy)NSString *veriface;

@property (nonatomic,copy)NSString *signature;
@property (nonatomic,copy)NSString *hospitalname;     //新添加医院名
@property (nonatomic,copy)NSString *departmentname;   //新添加科室名

@end

@interface AuthCommitRequest : NSObject


@property (nonatomic,strong)AuthCommitHeader *head;

@property (nonatomic,strong)AuthCommitBody *body;

@end
