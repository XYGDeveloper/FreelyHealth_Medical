//
//  KeshViewController.h
//  MedicineClient
//
//  Created by xyg on 2017/8/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JopModel;

typedef void (^selectKeshi)(JopModel *model);

@interface KeshViewController : UITableViewController

@property (nonatomic,strong)selectKeshi keshi;
@property (nonatomic,assign)BOOL Aukeshi;

@end
