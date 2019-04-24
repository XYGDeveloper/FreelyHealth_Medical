//
//  PhotoUpLoadTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhotoUpLoadTableViewCell.h"


@interface PhotoUpLoadTableViewCell()<HXPhotoViewDelegate>

@end

@implementation PhotoUpLoadTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withApp:(NSArray *)arr
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.oneManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        self.oneManager.openCamera = YES;
        self.oneManager.cacheAlbum = YES;
        self.oneManager.lookLivePhoto = YES;
        //        _oneManager.outerCamera = YES;
        self.oneManager.open3DTouchPreview = YES;
        self.oneManager.cameraType = HXPhotoManagerCameraTypeSystem;
        self.oneManager.photoMaxNum = 6;
        //        _oneManager.videoMaxNum = 6;
        self.oneManager.maxNum = 6;
        //        _oneManager.saveSystemAblum = NO;
        self.oneManager.rowCount = 4;
    
        self.oneManager.networkPhotoUrls = arr.mutableCopy;

        self.onePhotoView = [[HXPhotoView alloc] initWithFrame:CGRectZero WithManager:self.oneManager];
        self.onePhotoView.delegate = self;
        [self.contentView addSubview:self.onePhotoView];
        
        [self.onePhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(10);
        }];
        
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
