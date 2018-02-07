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
    func log(_ detail: LogDetail)
    
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
    var dateFormatter: DateFormatter { get }
    
    /**
     Converts a `LogDetail` into a formatted string based on the current properties.
     This is what you should output into the destination verbatim.
     
     - parameter detail: The `LogDetail` that to be formatted for the destination.
     - returns: The formatted string.
     */
    func formatted(_ detail: LogDetail) -> String
}

/// A struct describing a log message in detail.
@objc(ELLogDetail)
open class LogDetail: NSObject {
    /// The date at which the log call was made.  Note: This will never be an exact time, but approximate.
    open var date: Date? = nil
    
    /// The message.
    @objc open var message: String? = nil
    
    /// The level at which this was logged.
    open var level: UInt? = .none
    
    /// The function in which log was called.
    open var function: String? = nil
    
    /// The filename in which log was called.
    open var filename: String? = nil
    
    /// The line number which called log.
    open var line: UInt? = nil
}

/**
Base class for new destinations.

Provides a default identifier (a GUID), a default level of .Debug, and a date formatter for
use with output timestamps.
*/
@objc(ELLogDestinationBase)
open class LogDestinationBase: NSObject, LogDestinationProtocol, LogDestinationFormattible {
    
    fileprivate static let DateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    public init(level: LogLevel) {
        self.level = level.rawValue
        showCaller = false
        showLogLevel = false
        showTimestamp = false
        dateFormatter = Thread.dateFormatter_ELLog(LogDestinationBase.DateFormat)
    }

    public override convenience init() {
        self.init(level: LogLevel.Debug)
    }

    // MARK: LogDestinationProtocol
    open var identifier: String = UUID().uuidString
    open var level: UInt
    
    /// Subclasses must override
    open func log(_ detail: LogDetail) {
        assert(false, "This method must be overriden by the subclass.")
    }

    // MARK: LogDestinationFormattible
    open var showCaller: Bool
    open var showLogLevel: Bool
    open var showTimestamp: Bool
    open var dateFormatter: DateFormatter
    
    open func formatted(_ detail: LogDetail) -> String {
        var logString: String = ""
        
        if showLogLevel {
            if let level = detail.level {
                logString += "[\(LogLevel(rawValue: level).description)] "
            }
        }
        
        if showTimestamp {
            if let date = detail.date {
                logString += "[\(dateFormatter.string(from: date))] "
            }
        }
        
        if showCaller {
            if let filename = detail.filename, let line = detail.line, let function = detail.function {
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
