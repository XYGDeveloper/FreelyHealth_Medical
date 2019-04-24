//
//  UpdateControlManager.h
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionUpdateApi.h"
#import "VersionUpdateRequest.h"
#import "UpdateModel.h"
#import "LYZUpdateView.h"
#import "BaseMessageView.h"
@interface UpdateControlManager : NSObject<ApiRequestDelegate,BaseMessageViewDelegate>

@property (nonatomic,strong)VersionUpdateApi *update;

@property (nonatomic,strong)UpdateModel *model;

+ (instancetype)sharedUpdate;

- (void)updateVersion;



@end
