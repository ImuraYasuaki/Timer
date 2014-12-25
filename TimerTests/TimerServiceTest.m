//
//  TimerServiceTest.m
//  Timer
//
//  Created by myuon on 2014/12/22.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TimerService.h"
#import "NSObject+Debug.h"

@interface TimerServiceTest : XCTestCase

@end

@implementation TimerServiceTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadAllTimrs {
    NSArray *timers = [[TimerService sharedService] allTimers];
    for (TimerDTO *timer in timers) {
        NSLog(@"%@", [timer toDictionary]);
    }
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
