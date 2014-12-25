//
//  Configuration.m
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "Configuration.h"

#include <TimerLib/ConfigManager.h>

@interface iOSConfiguration : Configuration
@end

@implementation Configuration

+ (instancetype)defaultConfiguration {
    static Configuration *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[iOSConfiguration alloc] init];
    });
    return shared;
}

- (NSString *)timerFilePath {
    NSAssert(NO, @"cannot call this method.");
    return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation iOSConfiguration

- (NSString *)timerFilePath {
    static NSString *filePath = nil;
    if (!filePath) {
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSAssert(directoryPath, @"could not found timer file path.");

        NSString *fileName = [NSString stringWithUTF8String:ConfigManager::SavedTimerFileName];
        std::string path;
        ConfigManager::getSavedTimerPath([directoryPath UTF8String], [fileName UTF8String], path);

        filePath = [NSString stringWithUTF8String:path.c_str()];
    }
    return filePath;
}

@end
