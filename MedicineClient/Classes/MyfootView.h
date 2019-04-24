//
//  MyfootView.h
//  MedicineClient
//
//  Created by xyg on 2017/12/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^addMember)();

typedef void (^subMemeber)();

@interface MyfootView : UICollectionReusableView

@property (nonatomic,strong)UIButton *addEve;

@property (nonatomic,strong)UIButton *delEve;

@property (nonatomic,strong)addMember add;

@property (nonatomic,strong)subMemeber mul;

@end
