//
//  HeaderCollectionReusableView.h
//  MedicineClient
//
//  Created by xyg on 2017/12/10.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockEve)();

@interface HeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong)UILabel *headLabel;

@property (nonatomic,strong)blockEve eve;

@end
