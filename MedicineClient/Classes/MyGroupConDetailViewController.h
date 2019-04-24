//
//  MyGroupConDetailViewController.h
//  MedicineClient
//
//  Created by L on 2018/3/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customdesCell : UITableViewCell
@property (nonatomic,strong)UILabel *intro;
@property (nonatomic,strong)UILabel *sep;
@end

@interface MyGroupConDetailViewController : UIViewController

@property(nonatomic,strong)NSString *id;   //会诊id

@end
