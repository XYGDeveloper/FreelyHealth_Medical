//
//  LYZAdView.h
//  LeYiZhu-iOS
//
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 乐易住智能科技. All rights reserved.
//

#import "BaseMessageView.h"

@interface AdViewMessageObject : NSObject
@property (nonatomic, strong) NSString                         *autitle;
@property (nonatomic, strong) NSString                         *auaucontent;
@property (nonatomic, strong) NSString                         *aubuttonTitle;
@property (nonatomic, assign) BOOL                               auisforce;
@end

NS_INLINE AdViewMessageObject * MakeAdViewObject(NSString *autitle, NSString *auaucontent,NSString *aubuttonTitle,BOOL auisforce ) {
    
    AdViewMessageObject *object = [AdViewMessageObject new];
    object.autitle   = autitle;
    object.auaucontent = auaucontent;
    object.aubuttonTitle  = aubuttonTitle;
    object.auisforce = auisforce;
    return object;
}

@interface LYZAdView : BaseMessageView

@end
