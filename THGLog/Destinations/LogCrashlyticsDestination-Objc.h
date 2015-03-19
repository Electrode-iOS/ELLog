//
//  LogCrashlyticsDestination-Objc.h
//  THGLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void crashlyticsLog(NSString *format, va_list args);
