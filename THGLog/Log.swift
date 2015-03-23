//
//  Log.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

/**
Convenicen function to post logs to the default logging mechanism.

:param: level The log level.
:param: message The message to display.
*/
public func log(level: LogLevel, message: String) {
    Logger.defaultInstance.log(level, message: message)
}

