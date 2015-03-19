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
    // MARK: Protocol support bits
    private var value: UInt = 0
    public init(nilLiteral: ()) {}
    public init(rawValue: UInt) { value = rawValue }
    public var boolValue: Bool { return value != 0 }
    public var rawValue: UInt { return value }
    public static var allZeros: LogLevel { return self(rawValue: 0) }

    // MARK: LogLevel, actual values.

    public static var None: LogLevel       { return self(rawValue: 0) }
    public static var Error: LogLevel      { return self(rawValue: 1 << 0) }
    public static var Debug: LogLevel      { return self(rawValue: 1 << 1) }
    public static var Info: LogLevel       { return self(rawValue: 1 << 2) }
    public static var Verbose: LogLevel    { return self(rawValue: 1 << 3) }
    public static var All: LogLevel        { return .Error | .Debug | .Info | .Verbose }

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
}

public protocol LogDestinationProtocol: class {
    func log(detail: LogDetail)

    var identifier: String { get }
    var level: LogLevel { get set }

    var showCaller: Bool { get set }
    var showLogLevel: Bool { get set }
}

public struct LogDetail {
    var date: NSDate?

    var message: String? = nil
    var level: LogLevel? = .None

    // these 3 are tied together
    var function: String? = nil
    var filename: String? = nil
    var line: UInt?
}

private func loggerConsole() -> Logger {
    let logger = Logger()
    let console = LogConsoleDestination()
    logger.addDestination(console)
    return logger
}

@objc(THGLogger)
public final class Logger: NSObject {
    public static let defaultInstance = loggerConsole()

    public var showCallerLocation: Bool = true
    public var showCallingFunction: Bool = true

    override public init() {

    }

    public func log(level: LogLevel, message: String, function: String = __FUNCTION__, filename: String = __FILE__, line: UInt = __LINE__) {
        var detail = LogDetail()

        detail.date = NSDate()
        detail.message = message
        detail.level = level
        detail.function = function
        detail.filename = filename
        detail.line = line

        log(detail)
    }

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
        detail.level = LogLevel(rawValue: level)
        detail.function = function
        detail.filename = filename
        detail.line = line

        log(detail)

    }

    private func log(detail: LogDetail) {
        for destination in destinations.values {
            if let level = detail.level {
                if (level & .Error) && (destination.level & .Error) {
                    destination.log(detail)
                } else if (level & .Debug) && (destination.level & .Debug) {
                    destination.log(detail)
                } else if (level & .Info) && (destination.level & .Info) {
                    destination.log(detail)
                } else if (level & .Verbose) && (destination.level & .Verbose) {
                    destination.log(detail)
                }
            }
        }
    }

    public func addDestination(destination: LogDestinationProtocol) -> String {
        destinations[destination.identifier] = destination
        return destination.identifier
    }

    public func removeDestination(identifier: String) {
        destinations.removeValueForKey(identifier)
    }

    public func removeAllDestionations() {
        destinations.removeAll(keepCapacity: false)
    }

    public func destination(identifier: String) -> LogDestinationProtocol? {
        return destinations[identifier]
    }

    private var destinations = Dictionary<String, LogDestinationProtocol>()
}

