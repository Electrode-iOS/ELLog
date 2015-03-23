//
//  Logger-Objc.m
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

#import "Logger-Objc.h"
#import <THGLog/THGLog-Swift.h>

@implementation LoggerObjc

+ (void)log:(Logger *)instance logLevel:(NSUInteger)level function:(NSString *)function filename:(NSString *)filename line:(NSUInteger)line format:(NSString *)format, ... {
    va_list argp;
    va_start(argp, format);
    [instance _objcLog:level function:function filename:filename line:line format:format args:&argp];
    va_end(argp);
}

@end
