//
//  Service.m
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "Service.h"

@implementation Service

+ (instancetype)sharedService {
    static NSMutableDictionary *services = nil;
    if (!services) {
        services = [NSMutableDictionary dictionary];
    }
    NSString *className = NSStringFromClass(self);
    id service = [services objectForKey:className];
    if (!service ) {
        service = [[[self class] alloc] init];
        NSAssert(service, @"could not instantiate");

        [services setObject:service forKey:className];
    }
    return service;
}

@end
