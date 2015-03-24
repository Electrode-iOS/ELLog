//
//  LogConsoleDestination.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
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
@objc(THGLogConsoleDestination)
public class LogConsoleDestination: LogDestinationBase, LogDestinationProtocol {

    public func log(detail: LogDetail) {
        var output: String = ""

        if showLogLevel {
            if let level = detail.level {
                output += "[\(level)] "
            }
        }

        if showTimestamp {
            if let date = detail.date {
                output += "[\(dateFormatter.stringFromDate(date))] "
            }
        }

        if showCaller {
            if let filename = detail.filename, line = detail.line, function = detail.function {
                output += "(\(function), \(filename.lastPathComponent):\(line)) "
            }
        }

        output += ": "

        if let message = detail.message {
            output += message
        }

        NSLog(output)
    }

    public var showCaller: Bool = false
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false
}



