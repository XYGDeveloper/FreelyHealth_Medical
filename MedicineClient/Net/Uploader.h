//
//  Uploader.h
//
//  Created by xyg on 2017/3/18.
//  Copyright © 2017年 xyg. All rights reserved.
//

#import "BaseApi.h"
#import "ApiCommand.h"
#import <UIKit/UIKit.h>
@interface Uploader : NSObject

+ (instancetype)sharedUploader;

/**
 *  上传图片
 *
 *  @param image           图片
 *  @param completionBlock 回调方法
 */
- (void)uploadImage:(UIImage *)image withCompletionBlock:(void(^)(ApiCommand *cmd, BOOL success, NSString *imageUrl))completionBlock;

@end


@interface ImageUploadApi : BaseApi

- (void)uploadImage:(UIImage *)image;

@end
