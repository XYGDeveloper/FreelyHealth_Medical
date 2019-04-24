//
//  MyTeamModel.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface memberModel : NSObject

//id	string	是	医生id
//name	string	是	张三
//job	string	是	职务
//hname	string	是	所在医院
//introduction	string	是	简介
//facepath	string	是	头像图片地址

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *facepath;


@end



@interface MyTeamModel : NSObject

//id	string	是	团队id
//name	string	是	团队名称
//lname	string	是	领头人姓名
//ljob	string	是	领头人职务
//lhname	string	是	领头人医院名称
//introduction	string	是	团队介绍
//members
//JSONArray	是	团队成员
//lfacepath	string	是	领头人头像图片路径


@property (nonatomic,copy)NSString *groupid;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *lname;

@property (nonatomic,copy)NSString *ljob;

@property (nonatomic,copy)NSString *lhname;

@property (nonatomic,copy)NSString *introduction;
@property (nonatomic,copy)NSString *lfacepath;

@property (nonatomic,copy)NSString *shareurl;

@property (nonatomic,copy)NSArray *members;


@end
