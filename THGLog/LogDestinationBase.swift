//
//  LogDestinationBase.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/24/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation


/// Protocol that destination classes must support
@objc(THGLogDestinationProtocol)
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
    /// Specifies whether this destination should show the caller information.
    var showCaller: Bool { get set }
    /// Specifies whether this destination should show the log level.
    var showLogLevel: Bool { get set }
    /// Specifies whether this destination should show the timestampe.
    var showTimestamp: Bool { get set }
}


/// A struct describing a log message in detail.
@objc(THGLogDetail)
public class LogDetail: NSObject {
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

/**
Base class for new destinations.

Provides a default identifier (a GUID), a default level of .Debug, and a date formatter for
use with output timestamps.
*/
//@objc(THGLogDestinationBase)
@objc
public class LogDestinationBase: NSObject {
    public init(level: LogLevel) {
        self.level = level.rawValue
    }

    public override init() {
        level = LogLevel.Debug.rawValue
    }

    public var identifier: String = NSUUID().UUIDString
    public var level: UInt

    internal let dateFormatter: NSDateFormatter = NSThread.dateFormatter(dateFormat)
    internal static let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
}
