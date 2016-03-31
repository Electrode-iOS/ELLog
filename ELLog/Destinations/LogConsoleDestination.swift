//
//  LogConsoleDestination.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

/**
LogConsoleDestination provides output to the console via NSLog. 

The default behavior is:

    level = .Debug,
    showCaller = false,
    showLogLevel = true,
    showTimestamp = false
*/
@objc(ELLogConsoleDestination)
public class LogConsoleDestination: LogDestinationBase {

    public override init(level: LogLevel) {
        super.init(level: level)
        showCaller = false
        showLogLevel = true
        showTimestamp = false
    }
    
    public convenience init() {
        self.init(level: .Debug)
    }
    
    public override func log(detail: LogDetail) {
        NSLog(formatted(detail))
    }
    
}



