//
//  FriendCircleCell.h
//  ReactCocoaDemo
//
//  Created by letian on 16/12/5.
//  Copyright © 2016年 cmsg. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class recordModel;
//@class CaseDetailModel;
@class HZListDetailModel;
@class AgreeBookModel;
@interface FriendCircleCell : UITableViewCell

//- (void)cellDataWithModel:(recordModel *)model;
//
//- (void)cellClickBt:(dispatch_block_t)clickBtBlock;
//
//- (void)cellDataWithModel1:(CaseDetailModel *)model;
//
//- (void)cellDataWithModel2:(CaseDetailModel *)model;

- (void)cellDataWithAppionmentModel:(HZListDetailModel *)model;
//
- (void)cellDataWithAppionmentagreeModel:(AgreeBookModel *)model;

@end
