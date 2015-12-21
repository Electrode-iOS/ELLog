//
//  LogCrashlyticsDestination.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

// This is an example of declaring a C function from ObjC code.
@asmname("crashlyticsLog")
internal func crashlyticsLog(format: NSString, args: CVaListPointer)

/**
LogCrashlyticsDestination provides output the Crashlytics framework.  Crashlytics
detection is done at runtime and is weakly bound to this class.

The default behavior is:

    level = .Debug,
    showCaller = true,
    showLogLevel = true,
    showTimestamp = false
*/
@objc(THGLogCrashlyticsDestination)
public class LogCrashlyticsDestination: LogDestinationBase, LogDestinationProtocol {

    public func log(detail: LogDetail) {
        var output: String = ""

        if showLogLevel {
            if let level = detail.level {
                output += "[\(LogLevel(rawValue: level).description)] "
            }
        }

        if showTimestamp {
            if let date = detail.date {
                output += "[\(dateFormatter.stringFromDate(date))] "
            }
        }

        if showCaller {
            if let filename = detail.filename, line = detail.line, function = detail.function {
                output += "(\(function), \((filename as NSString).lastPathComponent):\(line)) "
            }
        }

        output += ": "

        if let message = detail.message {
            output += message
        }

        let emptyPointer = CVaListPointer(_fromUnsafeMutablePointer: nil)
        crashlyticsLog(output, args: emptyPointer)
    }

    public var showCaller: Bool = true
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false
}

