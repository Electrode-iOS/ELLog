//
//  LogUnitTestDestination.swift
//  ELLog
//
//  Created by Steven Riggins on 2/4/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation
import ELLog

/**

Defines a log destination that captures the last LogDetail logged.

 */
@objc(ELLogUnitTestDestination)
public class LogUnitTestDestination: LogDestinationBase, LogDestinationProtocol {
    
    /// The last LogDetail logged through this destination
    public var lastLogDetail: LogDetail = LogDetail()

    // LogDestinationProtocol compliance
    public var showCaller: Bool = false
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false

    public func log(detail: LogDetail) {
        lastLogDetail = detail
    }
    
}
