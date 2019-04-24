//
//  SelectMachRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachListHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface MachListBody : NSObject

@property (nonatomic , copy) NSString *name;

@end

@interface SelectMachRequest : NSObject

@property (nonatomic,strong)MachListHeader *head;

@property (nonatomic,strong)MachListBody *body;

@end
