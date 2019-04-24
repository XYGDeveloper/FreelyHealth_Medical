//
//  OSSRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface UploadBody : NSObject

//status	String 	否	不填 所有 1未支付 2进行中 3 已完成



@end



@interface UploadToolRequest : NSObject

@property (nonatomic,strong)UploadHeader *head;

@property (nonatomic,strong)UploadBody *body;

@end
