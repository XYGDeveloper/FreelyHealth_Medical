//
//  MyReferApi.m
//  MedicineClient
//
//  Created by L on 2017/10/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyReferApi.h"
#import "MyTaskModel.h"
#import "MyTaskRequest.h"
@interface MyReferApi()

@property (nonatomic, copy) NSString *orderStatus;


@end


@implementation MyReferApi

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super init]) {
        self.orderStatus = orderStatus;
    }
    return self;
}



- (void)refresh {
    
    MyTaskHeader *header = [[MyTaskHeader alloc]init];
    
    header.target = @"taskControl";
    
    header.method = @"taskOutList";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    MyTaskBody *bodyer = [[MyTaskBody alloc]init];
    
    bodyer.status = self.orderStatus;
    
    MyTaskRequest *requester = [[MyTaskRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self refreshWithParams:requester.mj_keyValues.mutableCopy];
    
}

- (void)loadNextPage {
    
    MyTaskHeader *header = [[MyTaskHeader alloc]init];
    
    header.target = @"taskControl";
    
    header.method = @"taskOutList";
    
    header.versioncode = Versioncode;
    
    header.devicenum = Devicenum;
    
    header.fromtype = Fromtype;
    
    header.token = [User LocalUser].token;
    
    MyTaskBody *bodyer = [[MyTaskBody alloc]init];
    
    bodyer.status = self.orderStatus;
    
    MyTaskRequest *requester = [[MyTaskRequest alloc]init];
    
    requester.head = header;
    
    requester.body = bodyer;
    
    NSLog(@"%@",requester);
    
    [self loadNextPageWithParams:requester.mj_keyValues.mutableCopy];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *myTask = [MyTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"tasks"]];
    
    return myTask;
}


@end
