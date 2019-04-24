//
//  DetailViewController.h
//  MedicineClient
//
//  Created by L on 2017/8/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+HUWebImage.h"
#import "HUImagePickerViewController.h"

@interface customFootDetailCell : UITableViewCell
@property (nonatomic,strong)UILabel *intro;
@property (nonatomic,strong)UILabel *sep;
@end

@interface DetailViewController : UIViewController
@property (nonatomic,strong)NSString *tasktype;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *taskno;
@end
