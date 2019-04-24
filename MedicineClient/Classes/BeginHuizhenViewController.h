//
//  BeginHuizhenViewController.h
//  MedicineClient
//
//  Created by L on 2018/5/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ImgTableviewCell : UITableViewCell
@property (nonatomic,strong)UILabel *intro;
@property (nonatomic,strong)UILabel *sep;
@end
@interface BeginHuizhenViewController : UIViewController
@property (nonatomic,assign)BOOL isModify;
@property (nonatomic,strong)NSString *hzid;

@end
