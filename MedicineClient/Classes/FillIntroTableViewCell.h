//
//  FillIntroTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/2/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
@interface FillIntroTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *typeName;

@property (nonatomic, strong, readonly) SZTextView *textField;

@property (nonatomic, assign) NSInteger maxEditCount;

@property (nonatomic, copy) void(^contentChangedBlock)();

@property (nonatomic, copy) NSString *text;

//设置是否可以编辑，默认为YES
- (void)setEditAble:(BOOL)editAble;

- (void)setTypeName:(NSString *)typeName
        placeholder:(NSString *)placeholder;
@end
