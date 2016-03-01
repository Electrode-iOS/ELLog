//
//  LogConsoleDestination.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

/**
LogConsoleDestination provides output to the console via NSLog. 

The default behavior is:

    level = .Debug,
    showCaller = false,
    showLogLevel = true,
    showTimestamp = false
*/
@objc(ELLogConsoleDestination)
public class LogConsoleDestination: LogDestinationBase, LogDestinationProtocol {

    // LogDestinationProtocol compliance
    public var showCaller: Bool = false
    public var showLogLevel: Bool = true
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

        NSLog("%@", output)
    }
}



