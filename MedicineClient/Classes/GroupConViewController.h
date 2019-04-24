//
//  GroupConViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/11/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    GroupConsultTypeInvite,
    GroupConsultTypeJoinOrNot
    
} GroupConsultType;

@interface GroupConViewController : UIViewController

//邀请会诊或是加入或者拒绝会诊
- (instancetype)initWithType:(GroupConsultType)type
                   withPName:(NSString *)name
                         des:(NSString *)des
                  imageArray:(NSMutableArray *)imagepathArr
                      taskNo:(NSString *)taskno;


@end
