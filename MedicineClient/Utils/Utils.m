//
//  Utils.m
//  Qqw
//
//  Created by zagger on 16/8/17.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "Utils.h"
#import "KissXML.h"
//#import "LoadingView.h"
#import "RootManager.h"
#import "User.h"
#import "LoginViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "OSSApi.h"
#import "OSSModel.h"
#import "UploadToolRequest.h"
#import "OSSImageUploader.h"
#define anHour  3600
#define aMinute 60
@implementation Utils

+ (void)uploadImgs:(NSArray<UIImage *> *)img withResult:(void (^)(id,NSInteger))result{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript" ,nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //请求签名
    UploadHeader *head = [[UploadHeader alloc]init];
    head.target = @"generalDControl";
    head.method = @"getDOssSign";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    UploadBody *body = [[UploadBody alloc]init];
    UploadToolRequest *request = [[UploadToolRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request.mj_keyValues.mutableCopy);
    [manager POST:kApiDomin parameters:request.mj_keyValues.mutableCopy success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        NSLog(@"ppppppppp--------------%@",responseObject);
        [OSSImageUploader asyncUploadImages:img access:[dic objectForKey:@"accessKeyId"] secreat:[dic objectForKey:@"accessKeySecret"] host:[dic objectForKey:@"endpoint"] secutyToken:[dic objectForKey:@"securityToken"] buckName:[dic objectForKey:@"bucket"] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            if (state == UploadImageSuccess) {
                NSMutableArray *temp = [NSMutableArray array];
                for (NSString *str in names) {
                    NSString *imgURLStr = [NSString stringWithFormat:@"http://%@.%@/%@",[dic objectForKey:@"bucket" ],[dic objectForKey:@"endpoint"],str];
                    [temp addObject:imgURLStr];
                }
                NSArray *imgURLStrs = [NSArray arrayWithArray:temp];
                result(imgURLStrs, state);
            }else{
                //                result(0);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
 
}
+(void)addHudOnView:(UIView *)parentView{
    [MBProgressHUD showHUDAddedTo:parentView animated:YES];
}
+(void)addHudOnView:(UIView *)parentView withTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.labelText = title;
}
+ (void)removeHudFromView:(UIView *)parentView {
    if (parentView) {
        for (UIView *subView in parentView.subviews) {
            if ([subView isKindOfClass:[MBProgressHUD class]]) {
                [subView removeFromSuperview];
            }
        }
        parentView.userInteractionEnabled = YES;
    }
}
+ (void)removeAllHudFromView:(UIView *)parentView {
    [self removeHudFromView:parentView];
}

#pragma mark - 提示文案
+ (void)postMessage:(NSString *)message onView:(UIView *)parentView{
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    [Utils showErrorMsg:parentView type:0 msg:message];
}
#pragma mark - 常用操作
+ (void)callPhoneNumber:(NSString *)phoneNumber {
    UIAlertView *alertView = [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"拨打电话：%@",phoneNumber] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
        if (buttonIndex != zg_alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
        }
    }];
    [alertView show];
}

//添加电话号码到通讯录
+ (void)addPhoneNumberToAddressBook:(NSString *)phoneNumber {
    
    ABRecordRef person = ABPersonCreate();
    
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef) @"", NULL);
    
    if (phoneNumber) {
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *venuePhoneNumbers = [phoneNumber componentsSeparatedByString:@" or "];
        for (NSString *venuePhoneNumberString in venuePhoneNumbers)
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
    }
    
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
    CFRelease(multiAddress);
    
    ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.displayedPerson = person;
    controller.allowsAddingToAddressBook = YES;
    
//    UINavigationController *nav = [RootManager sharedManager].tabbarController.selectedViewController;
//    if ([nav isKindOfClass:[UINavigationController class]]) {
//        [nav pushViewController:controller animated:YES];
//    }
    
    CFRelease(person);
}


#pragma mark - json
+ (id)jsonObjectFromString:(NSString *)jsonString {
    if (!jsonString || ![jsonString isKindOfClass:[NSString class]] || jsonString.length <= 0) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
        return object;
    } else {
        return nil;
    }
}

+ (NSString *)stringFromJsonObject:(id)jsonObject {
    if (!jsonObject || ![NSJSONSerialization isValidJSONObject:jsonObject]) {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSDate *)stringExchange:(NSString *)str{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH-mm-sss"];
    NSDate *resDate = [formatter1 dateFromString:str];
    return resDate;
}

#pragma mark - 商品价格显示问题
+ (NSString *)priceDisplayStringFromPrice:(NSString *)price {
    
//    CGFloat priceValue = [price floatValue];
//    return [self priceDisplayStringFromPriceValue:priceValue];
    return [NSString stringWithFormat:@"¥%@",price];
}

+ (NSString *)priceDisplayStringFromPriceValue:(CGFloat)priceValue {
    return [NSString stringWithFormat:@"¥%.2f",priceValue];
    
}

+ (CGFloat)priceValueFromString:(NSString *)price {
    CGFloat priceValue = [price floatValue];
    NSString *priceString = [NSString stringWithFormat:@"%.2f",priceValue];
    
    return [priceString floatValue];
}

#pragma mark - 全局跳转
+ (void)jumpToHomepage {
    [self jumpToTabbarControllerAtIndex:0];
}
//
+ (void)jumpToTabbarControllerAtIndex:(NSUInteger)index {
    if (index == 2 && [self showLoginPageIfNeeded]) {
        return;
    }
    
    if (index == [RootManager sharedManager].tabbarController.selectedIndex) {
        UIViewController *vc = [RootManager sharedManager].tabbarController.selectedViewController;
       
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)vc;
            [nav popToRootViewControllerAnimated:YES];
        }
        
    }
    else if (index < [RootManager sharedManager].tabbarController.viewControllers.count) {
        [RootManager sharedManager].tabbarController.selectedIndex = index;
    }
    
}

//
+ (BOOL)showLoginPageIfNeeded {
    if ([User hasLogin]) {
        return NO;
    }
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginVC];
    [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
    return YES;
}

+(void)showErrorMsg:(UIView *)view type:(int)type msg:(NSString *)msg{
    if (msg == nil ) {
       [User clearLocalUser];
//        [view makeToast:@"" duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
        return;
    }
    switch (type) {
            //        case 100001:
            //             [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
            //            [User clearLocalUser];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
            //            break;
        case 1102: //您还没有成为VIP会员，请先选择管家！
            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
            break;
        default:
            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
            break;
    }
    
}

+ (BOOL)shouldShowGuidePage {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        return NO;
    }
    
    NSString *appverstion = [UIDevice AppVersion];
    NSString *cachedVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"kCachedAppVersionKey"];
    
    if (!cachedVersion || [appverstion compare:cachedVersion] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}


+ (void)updateCachedAppVersion {
    NSString *appverstion = [UIDevice AppVersion];
    [[NSUserDefaults standardUserDefaults] setObject:appverstion forKey:@"kCachedAppVersionKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//+ (void)refreshHomeViewController
//{
//
//    HomepageViewController *home = [HomepageViewController new];
//    [home.myWebView reload];
//
//}
#pragma mark - Cookies
//+ (void)addCookiesForURL:(NSURL *)url {
//    if (!url) {
//        return;
//    }
//    
//    [self clearCookiesForURL:url];
//    
//    NSString *domain = url.host;
//    
//#warning 添加cookie
//    NSString * str = [NSString stringWithFormat:@"%f,%f",[AppDelegate APP].locationCoordinate.latitude,[AppDelegate APP].locationCoordinate.longitude];
//    NSLog(@"%@",str);
//    [self addCookieForDomain:domain withName:@"__LOCATION" value:str];
//    
//    [self addCookieForDomain:domain withName:@"__TAG" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"__TAG"]];
//    [self addCookieForDomain:domain withName:@"os" value:@"ios"];
//    [self addCookieForDomain:domain withName:@"version" value:[[UIDevice currentDevice]systemVersion]];
//    if ([User LocalUser].token) {
//        [self addCookieForDomain:domain withName:@"__TOKEN" value:[User LocalUser].token];
//    }
//}

+ (void)addCookieForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    [cookieProperties setObject:name ?: @"" forKey:NSHTTPCookieName];
    [cookieProperties setObject:value ?: @"" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain ?: @"" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:24 * 60 * 60] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
}

+ (void)clearCookiesForURL:(NSURL *)url {
    if (!url) {
        return;
    }
    
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookieArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark -
+ (NSArray *)addressInfoFromXml:(NSString *)xmlString {
//    <province name="河北省" postcode="130000" >
//    <city name="石家庄市" postcode="130100" >
//    <area name="长安区" postcode="130102" />
//    <area name="桥东区" postcode="130103" />
    
    DDXMLElement *element = [[DDXMLElement alloc] initWithXMLString:xmlString error:nil];
    NSArray *array = [element elementsForName:@"province"];
    
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    
    for (DDXMLElement *provinceElement in array) {
        NSMutableDictionary *provinceDic = [[NSMutableDictionary alloc] init];
        
        NSString *provinceName = [[provinceElement attributeForName:@"name"] stringValue];
        NSString *provinceCode = [[provinceElement attributeForName:@"postcode"] stringValue];
        NSMutableArray *cityArray = [[NSMutableArray alloc] init];
        
//        [provinceDic safeSetObject:provinceName forKey:@"name"];
//        [provinceDic safeSetObject:provinceCode forKey:@"postcode"];
//        [provinceDic safeSetObject:cityArray forKey:@"cities"];
        
        [provinceDic setValue:provinceName forKey:@"name"];
        [provinceDic setValue:provinceCode forKey:@"postcode"];
        [provinceDic setValue:cityArray forKey:@"cities"];
        
        
        NSArray *xmlCityArray = [provinceElement elementsForName:@"city"];
        for (DDXMLElement *cityElement in xmlCityArray) {
            NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
            
            NSString *cityName = [[cityElement attributeForName:@"name"] stringValue];
            NSString *cityCode = [[cityElement attributeForName:@"postcode"] stringValue];
            NSMutableArray *areaArray = [[NSMutableArray alloc] init];
            
//            [cityDic safeSetObject:cityName forKey:@"name"];
//            [cityDic safeSetObject:cityCode forKey:@"postcode"];
//            [cityDic safeSetObject:areaArray forKey:@"areas"];
            [cityDic setValue:cityName forKey:@"name"];
            [cityDic setValue:cityCode forKey:@"postcode"];
            [cityDic setValue:areaArray forKey:@"areas"];
            
            NSArray *xmlAreaArray = [cityElement elementsForName:@"area"];
            for (DDXMLElement *areaElement in xmlAreaArray) {
                NSMutableDictionary *areaDic = [[NSMutableDictionary alloc] init];
                
                NSString *areaName = [[areaElement attributeForName:@"name"] stringValue];
                NSString *areaCode = [[areaElement attributeForName:@"postcode"] stringValue];
        
//                [areaDic safeSetObject:areaName forKey:@"name"];
//                [areaDic safeSetObject:areaCode forKey:@"postcode"];
                
                [areaDic setValue:areaName forKey:@"name"];
                [areaDic setValue:areaCode forKey:@"postcode"];
                
//                [areaArray safeAddObject:areaDic];
                [areaArray addObject:areaDic];
                
            
            }
            
         //   [cityArray safeAddObject:cityDic];
            [cityArray addObject:cityDic];
            
        }
        
     //   [provinceArray safeAddObject:provinceDic];
        [provinceArray addObject:provinceDic];
        
        
    }
    
    return provinceArray;
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:provinceArray options:0 error:NULL];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    NSLog(@"%@", string);
}
    

+ (NSString *)formateDate:(NSString *)dateString
{
    
    @try {
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)stringWithTimeStamp:(NSNumber *)timeStamp {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970] + 8 * anHour;
    //将传入的参数转化为时间戳
    double dateStamp = [timeStamp doubleValue] + 8 * anHour;
    //计算时间间隔，即当前时间减去传入的时间
    double interval = currentDateStamp - dateStamp;
    //获取当前时间的小时单位（24小时制）
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H"];
    int nowHour = [[formatter stringFromDate:currentDate] intValue];
    //获取当前时间的分钟单位
    NSDateFormatter *minFormatter = [NSDateFormatter new];
    [minFormatter setDateFormat:@"m"];
    int nowMinute = [[minFormatter stringFromDate:currentDate] intValue];
    //今天0点的时间戳
    double todayZeroClock = currentDateStamp - anHour * nowHour - aMinute * nowMinute;
    //时间格式化，为输出做准备
    NSDateFormatter *outputFormat = [NSDateFormatter new];
    [outputFormat setDateFormat:@"M月d日"];
    //进行条件判断，满足不同的条件返回不同的结果
    if (interval < 30 * aMinute) {
        //在30分钟之内
        return @"刚刚";
    } else if (todayZeroClock - dateStamp > 24 * anHour) {
        //已经超过两天以上
        return [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
    } else if (todayZeroClock - dateStamp > 0) {
        //已经超过一天（昨天）
        return @"昨天";
    } else if (interval < anHour) {
        //一个小时之内
        return [NSString stringWithFormat:@"%.0f分钟前", (currentDateStamp - dateStamp) / aMinute];
    } else {
        //今天之内
        return [NSString stringWithFormat:@"%.0f小时前", (currentDateStamp - dateStamp) / anHour];
    }
}


+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)timeFormatterWithTimeString:(NSString *)timeStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:timeStr];
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"MM月dd日 EEEE HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat1 stringFromDate:date];
    return currentDateStr;
}

#pragma Mark 计算富文本的高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str  withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;//行间距 默认为0
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//+(void)showErrorMsg:(UIView *)view type:(int)type msg:(NSString *)msg{
//    if (msg == nil ) {
//        [view makeToast:@"服务器异常" duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
//        return;
//    }
//    switch (type) {
////        case 100001:
////             [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
////            [User clearLocalUser];
////            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotify object:nil];
////            break;
//        case 1102: //您还没有成为VIP会员，请先选择管家！
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_Select_Housekeeper object:nil];
//            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
//            break;
//        default:
//            [view makeToast:msg duration:2.0 position:CSToastPositionCenter style:[[CSToastStyle alloc] initWithDefaultStyle]];
//            break;
//    }
//    
//}
//
//+(void)popBackFreshWithObj:(id)obj view:(UIView*)view{
//    UITabBarController *tabBarController = (UITabBarController *)view.window.rootViewController;
//    UINavigationController *viewController = tabBarController.selectedViewController;
//    [viewController popToRootViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_Select_Address object:obj];
//}

+(UIImage*) imageWithColor:( UIColor*)color1{
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color1 CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIColor (extension)

+ (UIColor *)rgb:(NSString *)rgbHex{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != rgbHex)
    {
        NSScanner *scanner = [NSScanner scannerWithString:rgbHex];
        (void) [scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode);
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end

