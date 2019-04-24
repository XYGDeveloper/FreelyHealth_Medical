//
//  ApplyNoDirctionRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ApplyNoDirctionHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface ApplyNoDirctionBody : NSObject

@property (nonatomic , copy) NSString *patientname;

@property (nonatomic , copy) NSString *patientsex;

@property (nonatomic , copy) NSString *patientage;

@property (nonatomic , copy) NSString *des;

@property (nonatomic , copy) NSString *imagepath;

@property (nonatomic , copy) NSString *patientphone;

@end

@interface ApplyNoDirctionRequest : NSObject

@property (nonatomic,strong)ApplyNoDirctionHeader *head;

@property (nonatomic,strong)ApplyNoDirctionBody *body;

@end
