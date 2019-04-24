//
//  AppionmentListDetailModel.h
//  FreelyHeath
//
//  Created by L on 2018/5/15.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppionmentDetailModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *dname;
@property (nonatomic,copy)NSString *hname;
@property (nonatomic,copy)NSString *dintroduction;
@property (nonatomic,copy)NSString *dpost;
@property (nonatomic,copy)NSString *dfacepath;
@end

@interface AppionmentListDetailModel : NSObject
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *mdtgroupid;
@property(nonatomic,copy)NSString *jinru;

@property(nonatomic,copy)NSString *blimages;
@property(nonatomic,copy)NSString *topic;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *member;
@property(nonatomic,copy)NSString *zhengzhuang;
@property(nonatomic,copy)NSString *huizhentime;
@property(nonatomic,copy)NSString *huizhenprice;
@property(nonatomic,copy)NSString *diagnose;
@property(nonatomic,strong)NSArray *members;

@end
