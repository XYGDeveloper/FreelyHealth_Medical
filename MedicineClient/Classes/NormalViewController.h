//
//  NormalViewController.h
//  MedicineClient
//
//  Created by L on 2017/12/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface NormalViewController : RCConversationViewController

@property (nonatomic,assign)BOOL isGroupCon;

@property (nonatomic,strong)NSString  *item;

@property (nonatomic,strong)NSString  *mdtgroupname;


@end
