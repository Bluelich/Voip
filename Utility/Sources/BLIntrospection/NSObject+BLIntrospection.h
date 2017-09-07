//
//  NSObject+BLIntrospection.h
//  Test
//
//  Created by zhouqiang on 25/07/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (BLIntrospection)

@property (nonatomic,strong,readonly,nullable)id        JSONObject;
@property (nonatomic,strong,readonly,nullable)NSData   *JSONData;
@property (nonatomic,  copy,readonly,nullable)NSString *JSONString;
@property (nonatomic,  copy,readonly)NSString *description_pretty;

+ (NSArray *)classes;
+ (nullable NSArray *)properties;
+ (nullable NSArray *)instanceVariables;
+ (nullable NSArray *)classMethods;
+ (nullable NSArray *)instanceMethods;

+ (nullable NSArray *)protocols;
+ (nullable NSDictionary *)descriptionForProtocol:(Protocol *)proto;

+ (NSString *)parentClassHierarchy;

@end
NS_ASSUME_NONNULL_END
