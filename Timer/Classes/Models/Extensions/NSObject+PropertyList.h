//
//  NSObject+PropertyList.h
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

@interface NSObject (PropertyList)

+ (id)instanceFromPropertyList:(NSDictionary *)propertyList;
- (NSDictionary *)propertyListValue;

@end
