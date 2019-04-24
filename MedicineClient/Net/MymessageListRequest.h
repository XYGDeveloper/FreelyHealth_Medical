//
//  MymessageListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/5/17.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface myMessageHeader : NSObject
@property (nonatomic,  copy)NSString *target;
@property (nonatomic,  copy)NSString *method;
@property (nonatomic , copy)NSString *versioncode;
@property (nonatomic , copy)NSString *devicenum;
@property (nonatomic , copy)NSString *fromtype;
@property (nonatomic , copy)NSString *token;
@end

@interface myMessageBody : NSObject
//获取消息列表
//读取消息
@property (nonatomic , copy)NSString *id;

@end
@interface MymessageListRequest : NSObject
@property (nonatomic,strong)myMessageHeader *head;
@property (nonatomic,strong)myMessageBody *body;
@end
