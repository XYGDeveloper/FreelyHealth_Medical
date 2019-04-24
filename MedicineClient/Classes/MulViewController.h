//
//  MulViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^deleGroup)(NSMutableArray *endArr);

@interface MulViewController : UIViewController

@property (nonatomic,assign)BOOL secondGroups;

@property (nonatomic,strong)NSString *groupID;

@property (nonatomic,strong)NSArray *list;

@property (nonatomic,strong)deleGroup endArr;

@property (nonatomic,assign)BOOL secondsGroup;

@end
