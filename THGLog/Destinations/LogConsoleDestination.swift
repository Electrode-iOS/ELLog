//
//  LogConsoleDestination.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

@objc(THGLogConsoleDestination)
public class LogConsoleDestination: LogDestinationProtocol {

    public init() {
        internalIdentifier = NSUUID().UUIDString
        level = .Debug
    }

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

    public var identifier: String {
        get {
            return internalIdentifier
        }
    }

    public var level: LogLevel

    public var showCaller: Bool = true
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false

    private let internalIdentifier: String
    private let dateFormatter: NSDateFormatter = NSThread.dateFormatter(dateFormat)

    private static let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
}



