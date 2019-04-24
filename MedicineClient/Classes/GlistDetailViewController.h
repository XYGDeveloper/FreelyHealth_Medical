//
//  GlistDetailViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/12/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customFootCell : UITableViewCell
@property (nonatomic,strong)UILabel *intro;
@property (nonatomic,strong)UILabel *sep;
@end

typedef enum : NSUInteger {
    
    GroupConsultTypeInvite,
    GroupConsultTypeJoinOrNot,
    GroupConsultTypeReject,
    GroupConsultTypeAgree,

} GroupConsultType;

@interface GlistDetailViewController : UIViewController

@property (nonatomic,assign)BOOL isenter;   //1从我的会诊邀请进入。  0从会诊邀请进入

@property (nonatomic,strong)NSString *mdtgroupid;

@property (nonatomic,strong)NSString *mdtgroupname;

- (instancetype)initWithType:(GroupConsultType)type withID:(NSString *)tid;

- (instancetype)initWithType:(GroupConsultType)type withID:(NSString *)tid isAgree:(BOOL)isAgree;

- (instancetype)initWithType:(GroupConsultType)type withid:(NSString *)tid;

@end
