//
//  Logger-Objc.m
//  ELLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

#import "Logger-Objc.h"
#if defined(__has_include) && __has_include(<ELLog/ELLog-Swift.h>)
    #import <ELLog/ELLog-Swift.h>
#else
    #import "ELLog-Swift.h"
#endif

@implementation ELLoggerObjc

+ (void)log:(ELLogger *)instance logLevel:(NSUInteger)level function:(NSString *)function filename:(NSString *)filename line:(NSUInteger)line format:(NSString *)format, ... {
    va_list argp;
    va_start(argp, format);

    NSString *message = [[NSString alloc] initWithFormat:format arguments:argp];

    va_end(argp);

    [instance _objcLog:level function:function filename:filename line:line message: message];
}

@end
