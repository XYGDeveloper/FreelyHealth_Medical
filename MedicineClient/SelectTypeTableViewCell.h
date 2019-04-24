//
//  SelectTypeTableViewCell.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTypeTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *typeName;

@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, assign) NSInteger maxEditCount;

@property (nonatomic, copy) void(^contentChangedBlock)();

@property (nonatomic, copy) NSString *text;

//设置是否可以编辑，默认为YES
- (void)setEditAble:(BOOL)editAble;

- (void)setTypeName:(NSString *)typeName
        placeholder:(NSString *)placeholder;

@end
