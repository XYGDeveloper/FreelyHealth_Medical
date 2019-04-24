//
//  UpdateApp.h
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface updateAppHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@end

@interface updateAppBody : NSObject

@end


@interface UpdateApp : NSObject

@property (nonatomic,strong)updateAppHeader *head;

@property (nonatomic,strong)updateAppBody *body;


@end
