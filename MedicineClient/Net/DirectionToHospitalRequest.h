//
//  DirectionToHospitalRequest.h
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DirectionToHospitalHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface DirectionToHospitalBody : NSObject


@property (nonatomic,  copy)NSString *patientname;

@property (nonatomic,  copy)NSString *patientsex;

@property (nonatomic , copy) NSString *patientage;

@property (nonatomic , copy) NSString *des;

@property (nonatomic , copy) NSString *imagepath;

@property (nonatomic , copy) NSString *patientphone;

@property (nonatomic , copy) NSString *tid;

@end

@interface DirectionToHospitalRequest : NSObject

@property (nonatomic,strong)DirectionToHospitalHeader *head;

@property (nonatomic,strong)DirectionToHospitalBody *body;


@end
