//
//  LogTextfileDestination.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

/**
LogTextfileDestination provides output a user-provided filename that will be
created in the /Documents directory of your application.

The default behavior is:

    level = .Debug,
    showCaller = false,
    showLogLevel = true,
    showTimestamp = true
*/
@objc(THGLogTextfileDestination)
public class LogTextfileDestination: LogDestinationBase, LogDestinationProtocol {

    public init(filename: String) {
        self.filename = filename

        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let path = folder.stringByAppendingPathComponent(filename)
        outputStream = NSOutputStream(toFileAtPath: path, append: true)

        if let outputStream = outputStream {
            outputStream.open()
        } else {
            assertionFailure("LogTestfileDestionation was unable to open \(path) for writing.")
        }

        super.init(level: .Debug)
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
                output += "[\(LogLevel(rawValue: level))] "
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

    public var showCaller: Bool = false
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = true

    private let filename: String
    private let outputStream: NSOutputStream?
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
