//
//  ConversationViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface HuizhenConversationViewController : RCConversationViewController

@property (nonatomic,assign)BOOL isGroupCon;

@property (nonatomic,assign)BOOL isPrivateCon;

@property (nonatomic,strong)NSString  *item;

@property (nonatomic,strong)NSString  *mdtgroupname;

@property (nonatomic,assign)BOOL isVedioChat;

@property (nonatomic,strong)NSString  *huizhenid;
@property (nonatomic,strong)NSString  *faqi;

@end
