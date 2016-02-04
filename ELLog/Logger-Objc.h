//
//  Logger-Objc.h
//  ELLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LogLevel) {
    LogLevelNone = 0,
    LogLevelError = 1 << 0,
    LogLevelDebug = 1 << 1,
    LogLevelInfo = 1 << 2,
    LogLevelVerbose = 1 << 3,
    LogLevelAll = LogLevelError | LogLevelDebug | LogLevelInfo | LogLevelVerbose
};


@interface ELLoggerObjc: NSObject
+ (void)log:(id)instance logLevel:(NSUInteger)level function:(NSString *)function filename:(NSString *)filename line:(NSUInteger)line format:(NSString *)format, ...;
@end


#define ELLogCustom(instance, lvl, frmt, ...) \
    [ELLoggerObjc log:instance \
           logLevel:lvl \
           function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
           filename:[NSString stringWithUTF8String:__FILE__] \
               line:__LINE__ \
             format:frmt, ## __VA_ARGS__]

#define ELLog(lvl, frmt, ...) \
    ELLogCustom(ELLogger.defaultInstance, lvl, frmt, ## __VA_ARGS__)

#define ELLogError(frmt, ...) \
    ELLog(LogLevelError, frmt, ## __VA_ARGS__)

#define ELLogDebug(frmt, ...) \
    ELLog(LogLevelDebug, frmt, ## __VA_ARGS__)

#define ELLogInfo(frmt, ...) \
    ELLog(LogLevelInfo, frmt, ## __VA_ARGS__)

#define ELLogVerbose(frmt, ...) \
    ELLog(LogLevelVerbose, frmt, ## __VA_ARGS__)

