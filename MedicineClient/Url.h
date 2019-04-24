//
//  Url.h
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#ifndef Url_h
#define Url_h

//--------------------------------------------域名配置---------------------------------------------
//本地环境
//#define kApiDomin @"http://192.168.1.146:8080/qd/api/server/services"
//测试环境
#define kApiDomin   @"http://101.132.105.34:6066/qd/api/server/services"
//正式环境
//#define kApiDomin   @"https://api.zhiyi365.cn/qd/api/server/services"

//---------------------------------------------通用参数-------------------------------------------

static NSString *const referReqStatusreferedRece = @"1";
static NSString *const referReqStatusWaitRece =    @"2";
static NSString *const referReqStatusFinished =    @"3";
static NSString *const referReqStatusReceived =    @"4";

//请求订单列表时状态区分 1-待接受 2-已接受 3-已完成
static NSString *const OrderReqStatusWaitRece =    @"1";
static NSString *const OrderReqStatusReceived =    @"2";
static NSString *const OrderReqStatusFinished =    @"3";
//会诊邀请
static NSString *const HuizhenReqStatusNoResponse = @"1";
static NSString *const HuizhenReqStatusAttend     = @"2";
static NSString *const HuizhenReqStatusNoAttend   = @"3";
//---------------------------------------------接口列表-------------------------------------------

#define KNotification_receTask @"KNotification_receTask"
#define KNotification_rejecttask @"KNotification_rejecttask"
#define KNotification_finishtask @"KNotification_finishtask"
#define KNotification_refreshHZLIST @"KNotification_refreshHZLIST"

//-----------------------------------------------------------------------------------------------

//NSString* const KCIFlyFaceResultSST      = @"sst";
//NSString* const KCIFlyFaceResultGID      = @"gid";
//NSString* const KCIFlyFaceResultRST      = @"rst";
//NSString* const KCIFlyFaceResultVerf     = @"verf";
//NSString* const KCIFlyFaceResultScore    = @"score";

#endif /* Url_h */
