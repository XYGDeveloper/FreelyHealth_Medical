//
//  SelectHuanzheTableViewController.h
//  MedicineClient
//
//  Created by L on 2018/5/3.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HuanZheModel;
typedef void (^selectHospital)(HuanZheModel *model);
@interface SelectHuanzheTableViewController : UITableViewController
@property (nonatomic,strong)selectHospital hospital;
@end
