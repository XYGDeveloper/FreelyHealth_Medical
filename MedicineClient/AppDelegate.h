//
//  AppDelegate.h
//  MedicineClient
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioToolbox.h>
#import <RongCallKit/RongCallKit.h>
#import <RongIMKit/RongIMKit.h>
#import "MessageListViewController.h"
#import "getMessageListApi.h"
#import "MymessageListRequest.h"
#import "MyMessageModel.h"
#import "GetIMtokenApi.h"
#import "GetImTokenRequest.h"
#import "GroupInfoModel.h"
#import "getUnreadMessageCounts.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MessageListViewController *message;
@property (strong, nonatomic) UITabBarController *tabbar;
@property (nonatomic,strong)getUnreadMessageCounts *listApi;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)GetIMtokenApi *getAllGroupsApi;
@property (nonatomic,strong)NSArray *getAllGroups;

@end

