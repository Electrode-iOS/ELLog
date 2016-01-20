//
//  LogCrashlyticsDestination-Objc.m
//  ELLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

#import "LogCrashlyticsDestination-Objc.h"

@import Darwin;

typedef void (CLSLogv_function)(NSString *format, va_list args);

static CLSLogv_function *clsLog = nil;

void crashlyticsLog(NSString *format, va_list args) {

    Class c = NSClassFromString(@"Crashlytics");

    if (c) {
        if (!clsLog)
            clsLog = dlsym(RTLD_DEFAULT, "CLSLogv");

        clsLog(format, args);
    }
}
