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

    // I think there's a swift bug here.  I should pass "&argp", it works on sim, but not on device.
    // Passing "(va_list *)argp" works on both.  You'd figure it *wouldn't* work on sim given the above.
    // Typecasting it to va_list* silences the incompatible pointer type warning you'd normally get here. :(
    [instance _objcLog:level function:function filename:filename line:line format:format args:(va_list *)argp];
    va_end(argp);
}

@end
