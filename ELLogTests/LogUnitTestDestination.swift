//
//  LogUnitTestDestination.swift
//  ELLog
//
//  Created by Steven Riggins on 2/4/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import Foundation
import ELLog
// Use instances of this destination to capture output from Logger
// for testing purposes

@objc(ELLogUnitTestDestination)
public class LogUnitTestDestination: LogDestinationBase, LogDestinationProtocol {
    
    public func log(detail: LogDetail) {
        lastLogDetail = detail
    }
    
    public var showCaller: Bool = false
    public var showLogLevel: Bool = true
    public var showTimestamp: Bool = false
    
    public var lastLogDetail: LogDetail = LogDetail()
}
