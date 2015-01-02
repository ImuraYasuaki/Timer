//
//  SystemService.h
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "Service.h"

@interface SystemService : Service

- (NSUInteger)OSMajorVersion;
- (void)OSMajorVersionBranching:(NSUInteger)version lessBlock:(void (^)(void))lessBlock laterBlock:(void (^)(void))laterBlock;
- (void)OSMajorVersionBranching:(NSUInteger)version lessBlock:(void (^)(void))lessBlock;
- (void)OSMajorVersionBranching:(NSUInteger)version laterBlock:(void (^)(void))laterBlock;

@end
