//
//  LogTextfileDestination.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
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
@objc(ELLogTextfileDestination)
public class LogTextfileDestination: LogDestinationBase {

    fileprivate let filename: String
    fileprivate let outputStream: OutputStream?

    @objc public init(filename: String) {
        self.filename = filename

        let folder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = (folder as NSString).appendingPathComponent(filename)
        outputStream = OutputStream(toFileAtPath: path, append: true)

        if let outputStream = outputStream {
            outputStream.open()
        } else {
            assertionFailure("LogTestfileDestionation was unable to open \(path) for writing.")
        }

        super.init(level: .Debug)

        showCaller = false
        showLogLevel = true
        showTimestamp = true
    }

    deinit {
        outputStream?.close()
    }

    public override func log(_ detail: LogDetail) {

        if outputStream == nil {
            return
        }

        outputStream?.write(formatted(detail))
    }
}


extension OutputStream {

    @discardableResult
    func write(_ string: String, encoding: String.Encoding = String.Encoding.utf8, allowLossyConversion: Bool = true) -> Int {
        if let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
            var bytesRemaining = data.count
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
