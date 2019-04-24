//
//  SeMulViewController.h
//  MedicineClient
//
//  Created by L on 2017/12/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^deleGroup)();

@interface SeMulViewController : UIViewController

@property (nonatomic,assign)BOOL secondGroups;

@property (nonatomic,strong)NSString *groupID;

@property (nonatomic,strong)NSArray *list;

@property (nonatomic,strong)deleGroup endArr;

@end
