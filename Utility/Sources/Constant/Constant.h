//
//  Constant.h
//  VoipTest
//
//  Created by zhouqiang on 29/08/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT int kCallAppID;
FOUNDATION_EXPORT int kAccountType;
FOUNDATION_EXPORT NSString *kMasterSecret;
FOUNDATION_EXPORT NSString *kJPUSHKey;
FOUNDATION_EXPORT NSString *kChannel;

FOUNDATION_EXPORT NSString *NSStrinWithHexFormatFromData(NSData *token);

@interface Constant : NSObject

@end
