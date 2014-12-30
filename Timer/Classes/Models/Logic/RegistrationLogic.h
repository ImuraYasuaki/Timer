//
//  RegistrationLogic.h
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TimerDTO.h"

@interface RegistrationLogic : NSObject

+ (BOOL)canRegisterWithTimer:(TimerDTO *)timer;

@end
