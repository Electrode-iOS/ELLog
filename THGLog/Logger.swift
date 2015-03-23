//
//  Logger.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

struct TestPrintable : Printable {
    var description: String { return "Testing Printable" }
}

public struct LogLevel: RawOptionSetType, BooleanType, DebugPrintable {
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
    public static var All: LogLevel        { return .Error | .Debug | .Info | .Verbose }

    /// Returns a string representation of the current logging level(s).
    public var debugDescription: String {
        var options: Array<String> = []

        let level = LogLevel(rawValue: value)

        if level == .None {
            return "NONE"
        }

        if level == .All {
            return "ALL"
        }

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

/// Protocol that destination classes must support
@objc(THGLogDestinationProtocol)
public protocol LogDestinationProtocol: class {
    /**
    Sent to the destination when a log statement is executed.

    :param: detail Detailed information about the log statement.
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
    /// Specifies whether this destination should show the caller information.
    var showCaller: Bool { get set }
    /// Specifies whether this destination should show the log level.
    var showLogLevel: Bool { get set }
    /// Specifies whether this destination should show the timestampe.
    var showTimestamp: Bool { get set }
}

/// A struct describing a log message in detail.
@objc(THGLogDetail)
public class LogDetail {
    /// The date at which the log call was made.  Note: This will never be an exact time, but approximate.
    var date: NSDate? = nil
    /// The message.
    var message: String? = nil
    /// The level at which this was logged.
    var level: UInt? = .None
    /// The function in which log was called.
    var function: String? = nil
    /// The filename in which log was called.
    var filename: String? = nil
    /// The line number which called log.
    var line: UInt? = nil
}


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
        var detail = LogDetail()

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
    
    :param: destination The destination to add.
    :returns: the identifier of the destination.  Useful for later lookup.
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
    public func _objcLog(level: UInt, function: String, filename: String, line: UInt, format: String, args: UnsafeMutablePointer<va_list>) {
        let valist = CVaListPointer(_fromUnsafeMutablePointer: args)

        func curriedStringWithFormat(valist: CVaListPointer) -> String {
            let output = NSString(format: format, arguments: valist)
            return output as String
        }

        let message = curriedStringWithFormat(valist)

        var detail = LogDetail()

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
    let console = LogConsoleDestination(level: .Debug)
    logger.addDestination(console)
    return logger
}

@objc(THGLogDestinationBase)
public class LogDestinationBase: LogDestinationProtocol {
    public init(level: LogLevel) {
        self.level = level.rawValue
    }

    public init() {
        level = LogLevel.Debug.rawValue
    }

    public func log(detail: LogDetail) {
        // do nothing.
    }

    public var identifier: String = NSUUID().UUIDString
    public var level: UInt

    public var showCaller: Bool = true
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false

    internal let dateFormatter: NSDateFormatter = NSThread.dateFormatter(dateFormat)
    internal static let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

}
