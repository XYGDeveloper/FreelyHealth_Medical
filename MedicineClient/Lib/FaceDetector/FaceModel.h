//
//  FaceModel.h
//  MedicineClient
//
//  Created by L on 2017/8/29.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceModel : NSObject

@property (nonatomic,copy)NSString *ret;

//2017-08-29 14:23:34.023443+0800 MedicineClient[4690:1024777] result:{"ret":"0","uid":"3150810207","gid":"288c915cc1536a5a310c66cf6bb42dca","sst":"reg","rst":"success","sid":"wfr010017a8@ch3de10d0054653de300"}

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *sst;

@property (nonatomic,copy)NSString *rst;

@property (nonatomic,copy)NSString *sid;

@property (nonatomic,copy)NSString *gid;



@end
