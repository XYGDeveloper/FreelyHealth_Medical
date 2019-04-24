//
//  UpdateModel.h
//  MedicineClient
//
//  Created by L on 2017/10/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateModel : NSObject

@property (nonatomic,strong)NSArray *advisories;

@property (nonatomic,copy)NSString *artworkUrl100;

@property (nonatomic,copy)NSString *sellerUrl;

@property (nonatomic,copy)NSString *currency;

@property (nonatomic,copy)NSString *artworkUrl512;

@property (nonatomic,strong)NSArray *ipadScreenshotUrls;

@property (nonatomic,copy)NSString *fileSizeBytes;

@property (nonatomic,strong)NSArray *genres;

@property (nonatomic,strong)NSArray *languageCodesISO2A;

@property (nonatomic,copy)NSString *artworkUrl60;

@property (nonatomic,strong)NSArray *supportedDevices;

@property (nonatomic,copy)NSString *trackViewUrl;

@property (nonatomic,copy)NSString *version;                        //版本号

@property (nonatomic,copy)NSString *artistViewUrl;

@property (nonatomic,copy)NSString *bundleId;

@property (nonatomic,copy)NSString *releaseDate;                    //更新日期

@property (nonatomic,copy)NSString *artistName;                        //版本号

@property (nonatomic,copy)NSString *trackCensoredName;

@property (nonatomic,strong)NSArray *screenshotUrls;

@property (nonatomic,copy)NSString *releaseNotes;                    //更新日志



@end
