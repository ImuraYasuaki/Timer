//
//  NSObject+Debug.m
//  Timer
//
//  Created by myuon on 2014/12/22.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "NSObject+Debug.h"

#import <objc/runtime.h>

@implementation NSObject (Debug)

- (NSDictionary *)toDictionary {
    BOOL isNormalClass = [self isKindOfClass:[NSString class]]
    || [self isKindOfClass:[NSDate class]]
    || [self isKindOfClass:[NSNumber class]]
    || [self isKindOfClass:[NSValue class]];
    if (isNormalClass) {
        return @{@"__value": self};
    }
    BOOL isCollectionClass = [self isKindOfClass:[NSArray class]]
    || [self isKindOfClass:[NSDictionary class]];
    if (isCollectionClass) {
        return @{@"__value": self};
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count > 0) {
        for (unsigned int i = 0; i < count; ++i) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            id object = [self valueForKey:propertyName];
            [dictionary setObject:object forKey:propertyName];
        }
    }
    return @{NSStringFromClass([self class]): dictionary};
}

@end
