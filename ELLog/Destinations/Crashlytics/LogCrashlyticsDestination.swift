//
//  LogCrashlyticsDestination.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
import ELLog
import Crashlytics

/**
LogCrashlyticsDestination provides output the Crashlytics framework.  Crashlytics
detection is done at runtime and is weakly bound to this class.

The default behavior is:

    level = .Debug,
    showCaller = true,
    showLogLevel = false,
    showTimestamp = false
*/
@objc(ELLogCrashlyticsDestination)
public class LogCrashlyticsDestination: LogDestinationBase, LogDestinationProtocol {

    // LogDestinationProtocol compliance
    public var showCaller: Bool = true
    public var showLogLevel: Bool = false
    public var showTimestamp: Bool = false

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

        CLSLogv("%@", getVaList([output]))
    }
}

