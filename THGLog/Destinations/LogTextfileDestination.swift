//
//  LogTextfileDestination.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

@objc(THGLogTextfileDestination)
public class LogTextfileDestination: LogDestinationProtocol {

    public init(destFilename: String) {
        internalIdentifier = NSUUID().UUIDString
        level = .Debug

        filename = destFilename

        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let path = folder.stringByAppendingPathComponent(filename)
        outputStream = NSOutputStream(toFileAtPath: path, append: true)

        if let outputStream = outputStream {
            outputStream.open()
        } else {
            assertionFailure("LogTestfileDestionation was unable to open \(path) for writing.")
        }
    }

    deinit {
        outputStream?.close()
    }

    public func log(detail: LogDetail) {

        if outputStream == nil {
            return
        }
        
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

        output += "\n"

        outputStream?.write(output)
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
    private let filename: String
    private let outputStream: NSOutputStream?

    private let dateFormatter: NSDateFormatter = NSThread.dateFormatter(dateFormat)

    private static let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
}

extension NSOutputStream {

    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int {
        if let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0

            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }

                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }

            return totalBytesWritten
        }
        
        return -1
    }
    
}
