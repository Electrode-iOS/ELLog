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
open class LogUnitTestDestination: LogDestinationBase {
    
    /// The last LogDetail logged through this destination
    @objc open var lastLogDetail: LogDetail = LogDetail()

    public convenience init() {
        self.init(level: LogLevel.Debug)
        showCaller = false
        showLogLevel = true
        showTimestamp = false
    }

    open override func log(_ detail: LogDetail) {
        lastLogDetail = detail
    }
    
}
