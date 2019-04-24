//
//  ImageLoaderTools.m
//  MedicineClient
//
//  Created by L on 2018/2/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ImageLoaderTools.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#import <MJExtension.h>
@interface ImageLoaderTools()
@property (nonatomic,strong)OSSApi *Ossapi;
@property (nonatomic,strong)OSSModel *model;
@end
@implementation ImageLoaderTools

+ (void)uploadImgs:(NSArray<UIImage *> *)img withResult:(void (^)(id))result{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript" ,nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[User LocalUser].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"generalDControl" forHTTPHeaderField:@"target"];
    [manager.requestSerializer setValue:@"getDOssSign" forHTTPHeaderField:@"method"];
    [manager.requestSerializer setValue:Versioncode forHTTPHeaderField:@"versioncode"];
    [manager.requestSerializer setValue:Devicenum forHTTPHeaderField:@"devicenum"];
    [manager.requestSerializer setValue:Fromtype forHTTPHeaderField:@"fromtype"];
    
    [manager POST:kApiDomin parameters:@{} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        [OSSImageUploader asyncUploadImages:img access:[dic objectForKey:@"accessKeyId"] secreat:[dic objectForKey:@"accessKeySecret"] host:[dic objectForKey:@"endpoint"] secutyToken:[dic objectForKey:@"securityToken"] buckName:[dic objectForKey:@"bucket"] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            if (state == UploadImageSuccess) {
                NSMutableArray *temp = [NSMutableArray array];
                for (NSString *str in names) {
                    NSString *imgURLStr = [NSString stringWithFormat:@"http://%@.%@%@",[dic objectForKey:@"bucket" ],@"oss-cn-shenzhen.aliyuncs.com/",str];
                    [temp addObject:imgURLStr];
                }
                NSArray *imgURLStrs = [NSArray arrayWithArray:temp];
                result(imgURLStrs);
            }else{
                result(0);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        result(0);
    }];
}

@end
