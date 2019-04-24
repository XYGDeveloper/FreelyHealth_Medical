//
//  SelectHospitalViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JopModel;
typedef void (^selectHospital)(JopModel *model);

@interface SelectHospitalViewController : UITableViewController

@property (nonatomic,strong)selectHospital hospital;

@property (nonatomic,assign)BOOL Auhospital;

@end
