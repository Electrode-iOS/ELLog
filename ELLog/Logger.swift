//
//  Logger.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

/**
Logging Level option flags.
*/
public struct LogLevel: OptionSetType, BooleanType, CustomStringConvertible {
    /// Logging disabled.
    public let rawValue: UInt
    
    public static let None = LogLevel(rawValue: 0)
    
    /// Error logging enabled.
    public static let Error = LogLevel(rawValue: 1 << 0)
    
    /// Debug logging enabled.
    public static let Debug = LogLevel(rawValue: 1 << 1)
    
    /// Info logging enabled.
    public static let Info = LogLevel(rawValue: 1 << 2)
    
    /// Verbose logging enabled.
    public static let Verbose = LogLevel(rawValue: 1 << 3)
    
    /// All logging enabled.
    public static let All:LogLevel = [.Error, .Debug, .Info, .Verbose]

    /// Returns a string representation of the current logging level(s).
    public var description: String {
        var options: Array<String> = []

        if self == .None {
            return "NONE"
        }
        
        if contains(LogLevel.All) {
            return "ALL"
        }
        
        if contains(.Error) {
            options.append("ERROR")
        }

        if contains(.Debug) {
            options.append("DEBUG")
        }

        if contains(.Info) {
            options.append("INFO")
        }

        if contains(.Verbose) {
            options.append("VERBOSE")
        }

        return options.joinWithSeparator(", ")
    }

    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    // BooleanType
    public var boolValue: Bool { return rawValue  != 0 }
}

/**
Logger class.

Logs messages to the added destinations based on LogLevel flags.
*/
@objc(ELLogger)
public class Logger: NSObject {

    /**
    The default logger instance.  This is typically a LogConsoleDestination with a log level of .Debug.
    */
    public static let defaultInstance = loggerDefault()
    
    /**
    Allows this logger to be enabled/disabled.
    */
    public var enabled: Bool {
        get {
            objc_sync_enter(self)
            let value = _enabled
            objc_sync_exit(self)
            return value
        }
        set(value) {
            objc_sync_enter(self)
            _enabled = value
            objc_sync_exit(self)
        }
    }
    private var _enabled = false
    
    public override init() {
        super.init()
        let console = LogConsoleDestination(level: [.Debug, .Error])
        addDestination(console)
    }

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
        // if this logger isn't enabled, gtfo.
        if !enabled {
            return
        }
        
        // cycle through the destinations and start writing.
        for destination in destinations.values {
            if let rawLevel = detail.level {
                let level: LogLevel = LogLevel(rawValue: rawLevel)
                let destinationLevel: LogLevel = LogLevel(rawValue: destination.level)

                if level.contains(.Error) && destinationLevel.contains(.Error) {
                    destination.log(detail)
                } else if level.contains(.Debug) && destinationLevel.contains(.Debug) {
                    destination.log(detail)
                } else if level.contains(.Info) && destinationLevel.contains(.Info) {
                    destination.log(detail)
                } else if level.contains(.Verbose) && destinationLevel.contains(.Verbose) {
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
    logger.enabled = true
    return logger
}

