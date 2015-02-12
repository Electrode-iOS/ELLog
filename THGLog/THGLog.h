//
//  WMLog.h
//  walmart
//
//  Created by Wes Ostler on 2/5/15.
//  Copyright (c) 2015 Walmart. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

// We want to use our own version of the following log levels:
//
// Error
// Warn
// Info
// Debug
// Verbose
//
// All we have to do is undefine the default values, and then define our own however we want.

#undef DDLogError
#undef DDLogWarn
#undef DDLogInfo
#undef DDLogDebug
#undef DDLogVerbose

// Now define everything how we want it

#define THGLOG_FLAG_ERROR        (1 << 0)  // 0...000001
#define THGLOG_FLAG_WARN         (1 << 1)  // 0...000010
#define THGLOG_FLAG_INFO         (1 << 2)  // 0...000100
#define THGLOG_FLAG_DEBUG        (1 << 3)  // 0...001000
#define THGLOG_FLAG_VERBOSE      (1 << 4)  // 0...010000

/// Custom flags for tagging and debugging purposes.
#define THGLOG_FLAG_CUSTOM_DEBUG_1     (1 << 5) // 0...0100000
#define THGLOG_FLAG_CUSTOM_DEBUG_2     (1 << 6) // 0...1000000
#define THGLOG_FLAG_CUSTOM_DEBUG_3     (1 << 7) // 0..10000000

/**
 * These levels are defined hierarchically to support the priority filtering feature.
 * Example: Set thgLogLevel to THGLOG_LEVEL_INFO and you get info and everything above it, including warn and error, but not debug and verbose.
 */
#define THGLOG_LEVEL_ERROR       (THGLOG_FLAG_ERROR)                       // 0...000001
#define THGLOG_LEVEL_WARN        (THGLOG_FLAG_WARN | THGLOG_LEVEL_ERROR )   // 0...000011
#define THGLOG_LEVEL_INFO        (THGLOG_FLAG_INFO | THGLOG_LEVEL_WARN )    // 0...000111
#define THGLOG_LEVEL_DEBUG       (THGLOG_FLAG_DEBUG | THGLOG_LEVEL_INFO  )  // 0...001111
#define THGLOG_LEVEL_VERBOSE     (THGLOG_FLAG_VERBOSE | THGLOG_LEVEL_DEBUG) // 0...011111

#define THGLogError(frmt, ...)       LOG_MAYBE(NO, thgLogLevel, THGLOG_FLAG_ERROR, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogWarn(frmt, ...)        LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_WARN,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogInfo(frmt, ...)        LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_INFO,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogDebug(frmt, ...)       LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_DEBUG,  0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogVerbose(frmt, ...)     LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_VERBOSE,  0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

/**
 * Custom logging macros for the custom flags above, very useful in debugging.
 * Example: Use one of the three debugging macros below while debugging and set the thgLogLevel to the associated custom debug flag to easily silence all other logs.
 */
#define THGLogCustomDebug1(frmt, ...)        LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_CUSTOM_DEBUG_1, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogCustomDebug2(frmt, ...)        LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_CUSTOM_DEBUG_2, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define THGLogCustomDebug3(frmt, ...)        LOG_MAYBE(YES, thgLogLevel, THGLOG_FLAG_CUSTOM_DEBUG_3, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

typedef enum {
    THGLogFlagError              = (1 << 0), // 0...00001
    THGLogFlagWarning            = (1 << 1), // 0...00010
    THGLogFlagInfo               = (1 << 2), // 0...00100
    THGLogFlagDebug              = (1 << 3), // 0...01000
    THGLogFlagVerbose            = (1 << 4), // 0...10000
    THGLogFlagCustomDebug1       = (1 << 5), // 0..100000
    THGLogFlagCustomDebug2       = (1 << 6), // 0.1000000
    THGLogFlagCustomDebug3       = (1 << 7), // 010000000
} THGLogFlag;

typedef enum {
    THGLogLevelOff       = 0,
    THGLogLevelError     = (THGLogFlagError),                       // 0...00001
    THGLogLevelWarning   = (THGLogLevelError | THGLogFlagWarning), // 0...00011
    THGLogLevelInfo      = (THGLogLevelWarning | THGLogFlagInfo),    // 0...00111
    THGLogLevelDebug     = (THGLogLevelInfo | THGLogFlagDebug),   // 0...01111
    THGLogLevelVerbose   = (THGLogLevelDebug | THGLogFlagVerbose), // 0...11111
    THGLogLevelAll       = NSUIntegerMax                           // 1111....11111 (THGLogLevelVerbose plus any other flags)
} THGLogLevel;

/**
 * This is the global log level that is applied to the entire project. | any of the above THGLogLevel/THGLogFlag enums together to only log statements with that level. Note that this is not a const. To allow dynamic logging, thgLogLevel can be changed anywhere in the app.
 * Example: THGLogLevelInfo | THGLogFlagCustomDebug2 will log the THGLogLevelInfo level and above (So info, warning, and error) in addition to the THGLogFlagCustom2 level.
 */
#ifdef DEBUG
static NSUInteger thgLogLevel = THGLogLevelAll;
#else
static NSUInteger thgLogLevel = THGLogLevelOff;
#endif

@interface THGLog : DDLog

/**
 * Adds the system console logger. Log messages will be sent to the system console, viewable in Console.app.
 */
+ (void)addSystemConsoleLogger;

/**
 * Adds the Xcode console logger. Log messages will be sent to the Xcode console, viewable in Xcode.
 * @param enabled Whether or not to enable Xcode colors.
 */
+ (void)addXcodeConsoleLoggerWithColorsEnabled:(BOOL)enabled;

/**
 * Adds the file logger. Log messages will be sent to a file on the file system.
 * @param frequency How often to roll the log file. Once the log file gets to be this old, it is rolled.
 * @param maxFiles The maximum number of archived log files to keep on disk. For example, if this property is set to 3, then the LogFileManager will only keep 3 archived log files (plus the current active log file) on disk. Once the active log file is rolled/archived, then the oldest of the existing 3 rolled/archived log files is deleted. You may optionally disable this option by setting it to zero.
 */
+ (void)addFileLoggerWithFrequency:(NSInteger)frequency maxNumberOfFiles:(NSInteger)maxFiles;

/**
 * Sets the text color of a log message in the Xcode console for the flag specified.
 * @param textColor The color you want the text to be.
 * @param bgColor The color you want the background area behind the text to be.
 * @param flag The flag you want to assign a color to.
 */
+ (void)setXcodeConsoleTextColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor forFlag:(THGLogFlag)flag;

@end
