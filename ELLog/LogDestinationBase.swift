//
//  LogDestinationBase.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/24/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation


/// Protocol that destination classes must support
@objc(ELLogDestinationProtocol)
public protocol LogDestinationProtocol: class {
    /**
    Sent to the destination when a log statement is executed.

    - parameter detail: Detailed information about the log statement.
    */
    func log(detail: LogDetail)
    
    /**
    A unique identifier representing this destination.
    */
    var identifier: String { get }
    
    /**
    The levels that this destination actually records.  See LogLevel.
    */
    var level: UInt { get set }
}

@objc(ELLogDestinationFormattible)
public protocol LogDestinationFormattible: class {
    /// Specifies whether this destination should show the caller information.
    var showCaller: Bool { get }
    
    /// Specifies whether this destination should show the log level.
    var showLogLevel: Bool { get set }
    
    /// Specifies whether this destination should show the timestamp.
    var showTimestamp: Bool { get set }
    
    /// The dateformatter that will be used to format the timestamp.
    var dateFormatter: NSDateFormatter { get }
    
    /**
     Converts a `LogDetail` into a formatted string based on the current properties.
     This is what you should output into the destination verbatim.
     
     - parameter detail: The `LogDetail` that to be formatted for the destination.
     - returns: The formatted string.
     */
    func formatted(detail: LogDetail) -> String
}

/// A struct describing a log message in detail.
@objc(ELLogDetail)
public class LogDetail: NSObject {
    /// The date at which the log call was made.  Note: This will never be an exact time, but approximate.
    public var date: NSDate? = nil
    
    /// The message.
    public var message: String? = nil
    
    /// The level at which this was logged.
    public var level: UInt? = .None
    
    /// The function in which log was called.
    public var function: String? = nil
    
    /// The filename in which log was called.
    public var filename: String? = nil
    
    /// The line number which called log.
    public var line: UInt? = nil
}

/**
Base class for new destinations.

Provides a default identifier (a GUID), a default level of .Debug, and a date formatter for
use with output timestamps.
*/
@objc(ELLogDestinationBase)
public class LogDestinationBase: NSObject, LogDestinationProtocol, LogDestinationFormattible {
    
    private static let DateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    public init(level: LogLevel) {
        self.level = level.rawValue
        showCaller = false
        showLogLevel = false
        showTimestamp = false
        dateFormatter = NSThread.dateFormatter_ELLog(LogDestinationBase.DateFormat)
    }

    public override convenience init() {
        self.init(level: LogLevel.Debug)
    }

    // MARK: LogDestinationProtocol
    public var identifier: String = NSUUID().UUIDString
    public var level: UInt
    
    /// Subclasses must override
    public func log(detail: LogDetail) {
        assert(false, "This method must be overriden by the subclass.")
    }

    // MARK: LogDestinationFormattible
    public var showCaller: Bool
    public var showLogLevel: Bool
    public var showTimestamp: Bool
    public var dateFormatter: NSDateFormatter
    
    public func formatted(detail: LogDetail) -> String {
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
