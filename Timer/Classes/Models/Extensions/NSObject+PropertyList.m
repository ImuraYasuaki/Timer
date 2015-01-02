//
//  NSObject+PropertyList.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "NSObject+PropertyList.h"

#import <objc/runtime.h>

@interface NSObject (PropertyList_Private)

+ (BOOL)isFoundationClass;
+ (BOOL)isCollectionClass;

@end

@implementation NSObject (PropertyList)

+ (id)instanceFromPropertyList:(NSDictionary *)propertyList {
    NSString *className = [[propertyList allKeys] firstObject];
    Class cls = NSClassFromString(className);
    if (!cls) {
        return nil;
    }
    NSObject *object = [[cls alloc] init];

    NSDictionary *properties = [propertyList objectForKey:className];
    NSArray *allKeys = [properties allKeys];
    for (NSString *key in allKeys) {
        NSObject *subobject = [properties objectForKey:key];
        if (subobject == [NSNull null]) {
            subobject = @0;
        } else if ([subobject isKindOfClass:[NSDictionary class]]) {
            NSObject *tmp = [NSObject instanceFromPropertyList:(NSDictionary *)subobject];
            if (tmp) {
                subobject = tmp;
            }
        }
        @try {
            [object setValue:subobject forKeyPath:key];
        }
        @catch (NSException *exception) {
            // nothing to do ...
        }
    }
    return object;
}

- (NSDictionary *)propertyListValue {
    NSMutableDictionary *propertyList = [NSMutableDictionary dictionary];

    unsigned int numberOfProperties = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &numberOfProperties);
    for (unsigned int i = 0; i < numberOfProperties; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
            NSObject *object = [self valueForKeyPath:propertyName];
            if (!object) {
                object = [NSNull null];
            } else if (![object.class isFoundationClass] || [object.class isCollectionClass]) {
                object = [object propertyListValue];
            }
            [propertyList setObject:object forKey:propertyName];
        }
    }
    free(properties);

    return @{NSStringFromClass(self.class): propertyList};
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (PropertyList_Private)

+ (BOOL)isFoundationClass {
    NSString *className = NSStringFromClass(self);
    return [[className stringByReplacingOccurrencesOfString:@"_" withString:@""] hasPrefix:@"NS"];
}

+ (BOOL)isCollectionClass {
    return [self isSubclassOfClass:[NSArray class]] || [self isSubclassOfClass:[NSDictionary class]] || [self isSubclassOfClass:[NSSet class]];
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface NSArray (PropertyList)
@end

@implementation NSArray (PropertyList)

- (NSDictionary *)propertyListValue {
    NSMutableArray *propertyList = [NSMutableArray array];
    for (NSObject *object in self) {
        NSDictionary *child = [object propertyListValue];
        [propertyList addObject:child];
    }
    return @{NSStringFromClass(self.class): propertyList};
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface NSDictionary (PropertyList)
@end

@implementation NSDictionary (PropertyList)

- (NSDictionary *)propertyListValue {
    NSMutableDictionary *propertyList = [NSMutableDictionary dictionary];
    NSArray *allKeys = [self allKeys];
    for (NSString *key in allKeys) {
        NSObject *object = [self objectForKey:key];
        NSDictionary *child = [object propertyListValue];
        [propertyList setObject:child forKey:key];
    }
    return @{NSStringFromClass(self.class): propertyList};
}

@end

////////////////////////////////////////////////////////////////////////////////

@interface NSSet (PropertyList)
@end

@implementation NSSet (PropertyList)

- (NSDictionary *)propertyListValue {
    NSMutableDictionary *propertyList = [NSMutableDictionary dictionary];
    NSAssert(NO, @"must implement!");
    return @{NSStringFromClass(self.class): propertyList};
}

@end
