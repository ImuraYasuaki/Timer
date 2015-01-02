//
//  SystemService.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "SystemService.h"

@interface SystemService ()
@property (assign) NSUInteger OSMajorVersion;
@end

@implementation SystemService

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *versionNumberComponents = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
        self.OSMajorVersion = [[versionNumberComponents firstObject] integerValue];
    }
    return self;
}

- (void)OSMajorVersionBranching:(NSUInteger)version lessBlock:(void (^)(void))lessBlock laterBlock:(void (^)(void))laterBlock {
    if (self.OSMajorVersion < version) {
        if (lessBlock) {
            lessBlock();
        }
    } else {
        if (laterBlock) {
            laterBlock();
        }
    }
}

- (void)OSMajorVersionBranching:(NSUInteger)version lessBlock:(void (^)(void))lessBlock {
    [self OSMajorVersionBranching:version lessBlock:lessBlock laterBlock:nil];
}

- (void)OSMajorVersionBranching:(NSUInteger)version laterBlock:(void (^)(void))laterBlock {
    [self OSMajorVersionBranching:version lessBlock:nil laterBlock:laterBlock];
}

@end
