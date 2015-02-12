//
//  WMLog.m
//  walmart
//
//  Created by Wes Ostler on 2/5/15.
//  Copyright (c) 2015 Walmart. All rights reserved.
//

#import "THGLog.h"

@implementation THGLog

+ (void)addSystemConsoleLogger {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

+ (void)addXcodeConsoleLoggerWithColorsEnabled:(BOOL)enabled {
    DDTTYLogger *xcodeConsoleLogger = [DDTTYLogger sharedInstance];
    
    [xcodeConsoleLogger setColorsEnabled:enabled];
    [DDLog addLogger:xcodeConsoleLogger];
}

+ (void)addFileLoggerWithFrequency:(NSInteger)frequency maxNumberOfFiles:(NSInteger)maxFiles {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = frequency;
    fileLogger.logFileManager.maximumNumberOfLogFiles = maxFiles;
    
    [DDLog addLogger:fileLogger];
}

+ (void)setXcodeConsoleTextColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor forFlag:(THGLogFlag)flag {
    [[DDTTYLogger sharedInstance] setForegroundColor:textColor backgroundColor:bgColor forFlag:(DDLogFlag)flag];
}

@end
