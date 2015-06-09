//
//  Logger.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

/**
Logging Level option flags.
*/
public struct LogLevel: RawOptionSetType, BooleanType, CustomDebugStringConvertible {
    /// Logging disabled.
    public static var None: LogLevel       { return self(rawValue: 0) }
    /// Error logging enabled.
    public static var Error: LogLevel      { return self(rawValue: 1 << 0) }
    /// Debug logging enabled.
    public static var Debug: LogLevel      { return self(rawValue: 1 << 1) }
    /// Info logging enabled.
    public static var Info: LogLevel       { return self(rawValue: 1 << 2) }
    /// Verbose logging enabled.
    public static var Verbose: LogLevel    { return self(rawValue: 1 << 3) }
    /// All logging enabled.
    public static var All: [LogLevel]      { return [.Error, .Debug, .Info, .Verbose] }

    /// Returns a string representation of the current logging level(s).
    public var debugDescription: String {
        var options: Array<String> = []

        let level = LogLevel(rawValue: value)

        if level == .None {
            return "NONE"
        }
        
        // FIXME: return proper debug description for All
//        if level == LogLevel.All {
//            return "ALL"
//        }

        if level & .Error {
            options.append("ERROR")
        }

        if level & .Debug {
            options.append("DEBUG")
        }

        if level & .Info {
            options.append("INFO")
        }

        if level & .Verbose {
            options.append("VERBOSE")
        }

        return ", ".join(options)
    }

    // It's unlikely that you need to refer to these directly.
    private var value: UInt = 0
    public init(nilLiteral: ()) {}
    public init(rawValue: UInt) { value = rawValue }
    public var boolValue: Bool { return value != 0 }
    public var rawValue: UInt { return value }
    public static var allZeros: LogLevel { return self(rawValue: 0) }

}

/**
Logger class.

Logs messages to the added destinations based on LogLevel flags.
*/
@objc(THGLogger)
public final class Logger: NSObject {

    /**
    The default logger instance.  This is typically a LogConsoleDestination with a log level of .Debug.
    */
    public static let defaultInstance = loggerDefault()

    /**
    Dispatches the provided log information to the logging destination.
    */
    public func log(level: LogLevel, message: String, function: String = __FUNCTION__, filename: String = __FILE__, line: UInt = __LINE__) {
        let detail = LogDetail()
        detail.date = NSDate()
        detail.message = message
        detail.level = level.rawValue
        detail.function = function
        detail.filename = filename
        detail.line = line

        log(detail)
    }

    /**
    Add a new destination to this Logger instance.  This appends another destination
    to the list.  Only messages with a log level matching what this destination consumes
    will be sent here.
    
    - parameter destination: The destination to add.
    - returns: the identifier of the destination.  Useful for later lookup.
    */
    public func addDestination(destination: LogDestinationProtocol) -> String {
        destinations[destination.identifier] = destination
        return destination.identifier
    }

    /**
    Removes an existing destination by identifier.
    */
    public func removeDestination(identifier: String) {
        destinations.removeValueForKey(identifier)
    }

    /**
    Removes all destinations from this Logger instance.
    */
    public func removeAllDestionations() {
        destinations.removeAll(keepCapacity: false)
    }

    /**
    Lookup an existing destination by its identifier.
    */
    public func destination(identifier: String) -> LogDestinationProtocol? {
        return destinations[identifier]
    }
    
    /**
    Don't call this.  This is purely for interacting with the objective-c interface to this class.
    */
    public func _objcLog(level: UInt, function: String, filename: String, line: UInt, message: String) {
        let detail = LogDetail()
        detail.date = NSDate()
        detail.message = message
        detail.level = level
        detail.function = function
        detail.filename = filename
        detail.line = line

        log(detail)
    }

    private func log(detail: LogDetail) {
        for destination in destinations.values {
            if let rawLevel = detail.level {
                let level: LogLevel = LogLevel(rawValue: rawLevel)
                let destinationLevel: LogLevel = LogLevel(rawValue: destination.level)

                if (level & .Error) && (destinationLevel & .Error) {
                    destination.log(detail)
                } else if (level & .Debug) && (destinationLevel & .Debug) {
                    destination.log(detail)
                } else if (level & .Info) && (destinationLevel & .Info) {
                    destination.log(detail)
                } else if (level & .Verbose) && (destinationLevel & .Verbose) {
                    destination.log(detail)
                }
            }
        }
    }

    private var destinations = Dictionary<String, LogDestinationProtocol>()
}


/// Private convenience method for instantiating the default logging scheme.
private func loggerDefault() -> Logger {
    let logger = Logger()
    let console = LogConsoleDestination(level: .Debug | .Error)
    logger.addDestination(console)
    return logger
}

