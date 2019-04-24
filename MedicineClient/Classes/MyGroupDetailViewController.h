//
//  MyGroupDetailViewController.h
//  MedicineClient
//
//  Created by L on 2017/12/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface customCell : UITableViewCell
@property (nonatomic,strong)UILabel *intro;
@property (nonatomic,strong)UILabel *sep;
@end

@interface MyGroupDetailViewController : UIViewController

@property (nonatomic,strong)NSString *item;

@end
