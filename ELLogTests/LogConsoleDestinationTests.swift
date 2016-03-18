//
//  LogConsoleDestinationTests.swift
//  ELLog
//
//  Created by Sam Grover on 3/17/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import XCTest
@testable import ELLog

class LogConsoleDestinationTests: XCTestCase {
    
    let logDetailMock = LogDetail()
    
    override func setUp() {
        super.setUp()
        
        logDetailMock.date = NSDate(timeIntervalSince1970: 0)
        logDetailMock.message = "Let there be light."
        logDetailMock.filename = "TestFolder/TestFilename.swift"
        logDetailMock.line = 42
        logDetailMock.function = "testFunction"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLogConsoleDestinationDefault() {
        let logConsoleDestination = LogConsoleDestination()
        XCTAssertFalse(logConsoleDestination.showCaller)
        XCTAssertTrue(logConsoleDestination.showLogLevel)
        XCTAssertFalse(logConsoleDestination.showTimestamp)
        
        let expectedLogString = ": Let there be light."
        XCTAssert(logConsoleDestination.formattedLogString(logDetailMock) == expectedLogString)
    }
    
    func testLogConsoleDestinationLevel() {
        let logConsoleDestination = LogConsoleDestination()
        logDetailMock.level = LogLevel.Verbose.rawValue
        let expectedLogString = "[VERBOSE] : Let there be light."
        XCTAssert(logConsoleDestination.formattedLogString(logDetailMock) == expectedLogString)
    }
    
    func testLogConsoleDestinationCaller() {
        let logConsoleDestination = LogConsoleDestination()
        logConsoleDestination.showCaller = true
        let expectedLogString = "(testFunction, TestFilename.swift:42) : Let there be light."
        XCTAssert(logConsoleDestination.formattedLogString(logDetailMock) == expectedLogString)
    }
    
    func testLogConsoleDestinationTimestamp() {
        let logConsoleDestination = LogConsoleDestination()
        logConsoleDestination.showTimestamp = true
        let expectedLogString = "[1969-12-31 16:00:00.000] : Let there be light."
        XCTAssert(logConsoleDestination.formattedLogString(logDetailMock) == expectedLogString)
    }
    
    func testLogConsoleDestinationShowAll() {
        let logConsoleDestination = LogConsoleDestination()
        logConsoleDestination.showCaller = true
        logConsoleDestination.showTimestamp = true
        logDetailMock.level = LogLevel.Verbose.rawValue
        let expectedLogString = "[VERBOSE] [1969-12-31 16:00:00.000] (testFunction, TestFilename.swift:42) : Let there be light."
        logConsoleDestination.log(logDetailMock)
        XCTAssert(logConsoleDestination.formattedLogString(logDetailMock) == expectedLogString)
    }
}
