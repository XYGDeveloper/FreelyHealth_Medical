//
//  GroupUploadPicTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/11/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GroupUploadPicTableViewCell.h"
#import "EditTableViewCell.h"

@interface GroupUploadPicTableViewCell()<HXPhotoViewDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *line;

@end


@implementation GroupUploadPicTableViewCell
//
//- (EditTableViewCell *)photoHeader {
//    if (!_photoHeader) {
//        _photoHeader = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        [_photoHeader setTypeName:@"图像资料" placeholder:@""];
//        _photoHeader.editing = NO;
//        _photoHeader.selectionStyle = UITableViewCellSelectionStyleNone;
//        _photoHeader.textField.keyboardType = UIKeyboardTypeDefault;
//
//    }
//    return _photoHeader;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withApp:(NSArray *)arr
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
      
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = Font(16);
        self.label.text = @"图像资料";
        self.label.textColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(42);
            make.right.mas_equalTo(0);
        }];
        
        self.line = [[UILabel alloc]init];
        
        self.line.backgroundColor =[UIColor colorWithRed:200/255.0 green:199/255.0 blue:203/255.0 alpha:1.0f];
        
        [self.contentView addSubview:self.line];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.label.mas_bottom);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(0.5);
            make.right.mas_equalTo(0);
        }];
        
        self.oneManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        self.oneManager.openCamera = YES;
        self.oneManager.cacheAlbum = YES;
        self.oneManager.lookLivePhoto = YES;
                _oneManager.outerCamera = YES;
        self.oneManager.open3DTouchPreview = YES;
        self.oneManager.cameraType = HXPhotoManagerCameraTypeSystem;
        self.oneManager.photoMaxNum = 4;
        //        _oneManager.videoMaxNum = 6;
        self.oneManager.maxNum = 8;
        //        _oneManager.saveSystemAblum = NO;
        self.oneManager.rowCount = 4;
        self.oneManager.networkPhotoUrls = arr.mutableCopy;
        self.onePhotoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(10,52.5, kScreenWidth- 20, 80) WithManager:self.oneManager];
        self.onePhotoView.delegate = self;
        [self.contentView addSubview:self.onePhotoView];
        
    }
    
    return self;
    
}


- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        if (self.select) {
            self.select(images);
        }
    }];
    
    if (self.onePhotoView == photoView) {
        
        NSSLog(@"onePhotoView - %@",[allList firstObject].thumbPhoto);
        
    }
    
    
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
    
}


@end
