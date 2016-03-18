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
        NSLog(formattedLogString(detail))
    }
    
    internal func formattedLogString(detail: LogDetail) -> String {
        var logString: String = ""
        
        if showLogLevel {
            if let level = detail.level {
                logString += "[\(LogLevel(rawValue: level).description)] "
            }
        }
        
        if showTimestamp {
            if let date = detail.date {
                logString += "[\(dateFormatter.stringFromDate(date))] "
            }
        }
        
        if showCaller {
            if let filename = detail.filename, line = detail.line, function = detail.function {
                logString += "(\(function), \((filename as NSString).lastPathComponent):\(line)) "
            }
        }
        
        logString += ": "
        
        if let message = detail.message {
            logString += message
        }
        
        return logString
    }
}



