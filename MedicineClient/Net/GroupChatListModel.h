//
//  GroupChatListModel.h
//  MedicineClient
//
//  Created by L on 2018/5/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupChatListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *facepath;
@property (nonatomic,copy)NSString *name;

//name    string    是    会诊成员名
//facepath    string    是    会诊成员头像
//id    string    是    会诊成员id

@end
