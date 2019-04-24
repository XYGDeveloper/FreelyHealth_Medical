//
//  UDIDIdenity.m
//  FreelyHeath
//
//  Created by L on 2018/2/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UDIDIdenity.h"
#import "UDIDManager.h"
@implementation UDIDIdenity
+ (NSString *)UDID {
    [UDIDManager clearUDID];
    
    NSString *udid = [UDIDManager UDID];
    if (udid == nil) {
        NSLog(@"udid %@", [UDIDManager UDID]);
        udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if ([UDIDManager saveUDID:udid]) {
            NSLog(@"save OK");
        } else {
            NSLog(@"save fail");
        }
    }
     return  [UDIDManager UDID];
}
@end
