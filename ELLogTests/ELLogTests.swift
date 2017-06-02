//
//  ELLogTests.swift
//  ELLogTests
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
import XCTest
@testable import ELLog

class ELLogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func runTestsOn(_ logger: Logger) {
        let number = NSNumber(value: 1234 as Int)
        
        logger.removeAllDestinations()
        
        XCTAssertTrue(logger.destinationsForTesting().isEmpty)
        
        // This destination captures the LogDetail sent to Logger
        let unitTestDestination = LogUnitTestDestination()
        let identifier = unitTestDestination.identifier
        logger.addDestination(unitTestDestination)
        
        XCTAssert(logger.destinationsForTesting().count == 1)
        XCTAssert(logger.destination(identifier) === unitTestDestination)
        
        let testMessage = "hello \(number)"
        let testLogLevel: LogLevel = [.Debug, .Info]

        logger.log(testLogLevel, message: testMessage)
        XCTAssert(unitTestDestination.lastLogDetail.level == testLogLevel.rawValue)
        XCTAssert(unitTestDestination.lastLogDetail.message == testMessage)
        
        logger.removeDestination(identifier)
        XCTAssertTrue(logger.destinationsForTesting().isEmpty)
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
        
        XCTAssertTrue(LogLevel.Error.rawValue < LogLevel.Info.rawValue)
        XCTAssertTrue(LogLevel.Info.rawValue < LogLevel.Debug.rawValue)
        XCTAssertTrue(LogLevel.Debug.rawValue < LogLevel.Verbose.rawValue)
    }
    
}
