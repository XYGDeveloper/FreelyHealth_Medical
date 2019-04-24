//
//  TeamIndexViewController.h
//  MedicineClient
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZspMenu.h"
@interface TeamIndexViewController : UIViewController<ZspMenuDataSource, ZspMenuDelegate>

@property (nonatomic, strong) ZspMenu *menu;

@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, strong) NSArray *choose;

@property (nonatomic, strong) NSArray *yuexiu;
@property (nonatomic, strong) NSArray *tianhe;
@property (nonatomic, strong) NSArray *panyu;
@property (nonatomic, strong) NSArray *hanzhu;
@property (nonatomic, strong) NSArray *baiyun;
@property (nonatomic, strong) NSArray *liwan;
@property (nonatomic, strong) NSArray *huangpu;

- (void)refreshTeamPage;




@end
