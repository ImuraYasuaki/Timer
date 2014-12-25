//
//  Configuration.h
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (nonatomic, readonly) NSString *timerFilePath;

+ (instancetype)defaultConfiguration;

@end
