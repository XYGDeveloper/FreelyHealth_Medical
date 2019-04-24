//
//  AuModel.h
//  MedicineClient
//
//  Created by L on 2018/4/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuModel : NSObject
//        {"msg":"请求成功","data":{"id":"0cb84fa0362111e8912b00163e00b3a0","method":"doctorAuthentication","phone":"15899562341","isauthenticate":"2","sex":"男","dname":"肿瘤全科","isteam":"N","hname":"上海曙光医院","facepath":"http:\/\/zhiyi365.oss-cn-shanghai.aliyuncs.com\/img\/20170914\/cdafa914d0064b37a53760a9cd158036.jpg","token":"da353817fdf342d2aeab1321e26a302a","name":"吖吖啊","pname":"主治医师"},"returncode":"10000"}
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *isauthenticate;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *dname;
@property (nonatomic,copy)NSString *isteam;
@property (nonatomic,copy)NSString *hname;
@property (nonatomic,copy)NSString *facepath;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *pname;

@end
