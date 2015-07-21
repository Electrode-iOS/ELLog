//
//  Logger-Objc.h
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
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


@interface LoggerObjc: NSObject
+ (void)log:(id)instance logLevel:(NSUInteger)level function:(NSString *)function filename:(NSString *)filename line:(NSUInteger)line format:(NSString *)format, ...;
@end


#define THGLogCustom(instance, lvl, frmt, ...) \
    [LoggerObjc log:instance \
           logLevel:lvl \
           function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
           filename:[NSString stringWithUTF8String:__FILE__] \
               line:__LINE__ \
             format:frmt, ## __VA_ARGS__]

#define THGLog(lvl, frmt, ...) \
    THGLogCustom(THGLogger.defaultInstance, lvl, frmt, ## __VA_ARGS__)

#define THGLogError(frmt, ...) \
    THGLog(LogLevelError, frmt, ## __VA_ARGS__)

#define THGLogDebug(frmt, ...) \
    THGLog(LogLevelDebug, frmt, ## __VA_ARGS__)

#define THGLogInfo(frmt, ...) \
    THGLog(LogLevelInfo, frmt, ## __VA_ARGS__)

#define THGLogVerbose(frmt, ...) \
    THGLog(LogLevelVerbose, frmt, ## __VA_ARGS__)

