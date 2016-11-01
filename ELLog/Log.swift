//
//  Log.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

/**
Convenicen function to post logs to the default logging mechanism.

- parameter level: The log level.
- parameter message: The message to display.
*/
public func log(_ level: LogLevel, _ message: String) {
    Logger.defaultInstance.log(level, message: message)
}

