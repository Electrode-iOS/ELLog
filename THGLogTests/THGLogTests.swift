//
//  THGLogTests.swift
//  THGLogTests
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import UIKit
import XCTest
import THGLog
import Crashlytics

public enum TestEnum: Printable {
    case One
    case Two
    case Three


    public var description: String {
        get {
            switch self {
            case One:
                return "One"
            case Two:
                return "Two"
            case Three:
                return "Three"
            default:
                return "Unknown"
            }
        }
    }
}

class THGLogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        //XCTAssert(true, "Pass")

        let number = NSNumber(integer: 1234)
        let test: TestEnum = .One

        CLSLogv("hello = %@", getVaList([number]))

        //Logger.defaultInstance.removeAllDestionations()

        let crashlytics = LogCrashlyticsDestination()
        crashlytics.level = LogLevel.Info.rawValue

        Logger.defaultInstance.addDestination(crashlytics)

        Logger.defaultInstance.log(.Debug | .Info, message: "hello \(number)")

        //Logger.defaultInstance.log(.Debug | .Info, message: "Hello \(number)")
        //oldStyleLog(.Warning, "result = %@, %f, %@, %@", self, 3.14, "hello", number)
        //__log("result = %@, %f, %@, %@", test, 3.14, "hello", number)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
