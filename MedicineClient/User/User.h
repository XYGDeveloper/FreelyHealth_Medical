//
//  User.h
//  FreelyHealth
//
//  Created by L on 2017/7/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCache.h"

@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString *isauthenticate;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *temptoken;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *dname;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *facepath;
@property (nonatomic, copy) NSString *IMtoken;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) UIImage *img;
@property (nonatomic, copy) NSString *certification;   //证件照
@property (nonatomic, copy) NSString *workcard;        //工作牌
@property (nonatomic, copy) NSString *veriface;        //人脸
@property (nonatomic, copy) NSString *signature;       //笔迹签名
@property (nonatomic, copy) NSString *kefu;            //客服标识

//团队信息
@property (nonatomic, copy) NSString *tgroupid;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *huizhenid;

//会诊信息
@property (nonatomic, copy) NSString *mdtgroupid;
@property (nonatomic, copy) NSString *mdtgroupname;
@property (nonatomic, copy) NSString *mdtgroupfacepath;

/** 本地登陆的用户信息 */
+ (instancetype)LocalUser;

/** 设置本地登陆用户信息，并保存到沙盒 */
+ (void)setLocalUser:(User *)user;

/** 修改用户名，头像等后，将信息保存到沙盒的方法 */
+ (void)saveToDisk;

/** 退出登陆后，调用该方法清理本地用户信息*/
+ (void)clearLocalUser;

/** 返回当前是否有用户登陆 */
+ (BOOL)hasLogin;


@end
