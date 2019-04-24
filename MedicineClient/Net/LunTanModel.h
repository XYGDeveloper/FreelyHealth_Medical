//
//  LunTanModel.h
//  MedicineClient
//
//  Created by L on 2017/8/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunTanModel : NSObject

//id	string	是	问题ID
//title	string	是	问题标题
//dname	string	是	医生名字
//job	string	是	医生职务
//hname	string	是	医生医院
//answer	string	是	医生回答
//agreenum	int	是	该回答点赞数
//facepath	String	是	医生头像
//readnum	int	是	该问题阅读数
//phone	String	是	提问人电话
//createtime	String	是	提问时间
//answernum	String	是	回答数
//backtime	String	是	回答时间
//imagepath	String	是	问题相关图片集

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *answer;

@property (nonatomic,copy)NSString *agreenum;

@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *readnum;

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *createtime;

@property (nonatomic,copy)NSString *answernum;

@property (nonatomic,copy)NSString *backtime;

@property (nonatomic,copy)NSString *imagepath;


@end
