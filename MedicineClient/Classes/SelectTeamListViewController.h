//
//  SelectTeamListViewController.h
//  MedicineClient
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JopModel;
typedef void (^selectHospital)(JopModel *model);

@interface SelectTeamListViewController : UITableViewController

@property (nonatomic,strong)selectHospital hospital;


@end
