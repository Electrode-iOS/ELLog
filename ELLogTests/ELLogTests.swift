//
//  ELLogTests.swift
//  ELLogTests
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import UIKit
import XCTest
import ELLog
import Crashlytics

class ELLogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func runTestsOn(logger: Logger) {
        let number = NSNumber(integer: 1234)
        
        logger.removeAllDestinations()

        // This destination captures the LogDetail sent to Logger
        let unitTestDestination = LogUnitTestDestination()
        logger.addDestination(unitTestDestination)
        
        let testMessage = "hello \(number)"
        let testLogLevel: LogLevel = [.Debug, .Info]
        logger.log(testLogLevel, message: testMessage)
        XCTAssert(unitTestDestination.lastLogDetail.level == testLogLevel.rawValue)
        XCTAssert(unitTestDestination.lastLogDetail.message == testMessage)
    }
    
    func testInstance() {
        let logger = Logger()
        runTestsOn(logger)
    }

    
    func testSingleton() {
        runTestsOn(Logger.defaultInstance)
    }
    
    func testLogLevel() {
        var level = LogLevel.Debug
        
        XCTAssertTrue(level.contains(.Debug))
        XCTAssertFalse(level.contains(.Error))

        level.insert(.Error)
        XCTAssertTrue(level.contains(.Error))
        
        level.remove(.Debug)
        XCTAssertFalse(level.contains(.Debug))
        
        level = LogLevel.All
        XCTAssertTrue(level.contains(LogLevel.All))

        let obnoxiousLevels:LogLevel = [.Verbose, .Debug]
        level.remove(obnoxiousLevels)
        XCTAssertFalse(level.contains(LogLevel.All))
        
        XCTAssertTrue(level.contains(.Info))
    }
    
}
