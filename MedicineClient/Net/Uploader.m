//
//  Uploader.m
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.
//

#import "Uploader.h"
#import "AFURLRequestSerialization.h"
@interface Uploader ()<ApiRequestDelegate>

@property (nonatomic, strong) ImageUploadApi *imgUploadApi;

@property (nonatomic, copy) void(^completionBlock)(ApiCommand *cmd, BOOL success, NSString *imageUrl);

@end

@implementation Uploader

+ (instancetype)sharedUploader {
    static Uploader *__loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __loader = [[Uploader alloc] init];
    });
    return __loader;
}

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock {
    self.completionBlock = completionBlock;
    [self.imgUploadApi uploadImage:image];
}

#pragma mark - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    if (self.completionBlock) {
        self.completionBlock(command, YES, responsObject);
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    if (self.completionBlock) {
        self.completionBlock(command, NO, nil);
    }
}

#pragma mark - Properties
- (ImageUploadApi *)imgUploadApi {
    if (!_imgUploadApi) {
        _imgUploadApi = [[ImageUploadApi alloc] init];
        _imgUploadApi.delegate = self;
    }
    return _imgUploadApi;
}

@end






@implementation ImageUploadApi

- (void)uploadImage:(UIImage *)image {
   
    [self startRequestWithParams:nil multipart:^(id<AFMultipartFormData> multipartBlock) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
            [imageData writeToFile:filePath atomically:YES];
            
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            [multipartBlock appendPartWithFileURL:fileUrl name:@"file" error:nil];
        }
    }];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-main/upload");
    return command;
}

- (id)reformData:(id)responseObject {
    return responseObject[@"file_url"];
}

@end
