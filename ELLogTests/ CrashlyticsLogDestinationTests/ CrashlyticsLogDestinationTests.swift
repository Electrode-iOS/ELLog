//
//  CrashlyticsLogDestinationTests.swift
//  walmart
//
//  Created by Steven Riggins on 4/3/16.
//  Copyright © 2016 Walmart. All rights reserved.
//
//

// This test is not included as part of the ELLog test suit
// because the Crashlytics logging code, while
// in the ELLog framework *repository* is not in the ELLog *framework*
// This allows ELLog to not rely on linking with Crashlytics
// Include this file in any test suite using the CrashlyticsLogDestination

import XCTest
import Walmart
import ELLog

class CrashlyticsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testForLoggingCrash() {
        CrashlyticsLogger.sharedInstance.log(.Debug, message: "%@%d%.2f this would crash the older crashytics logging code")
        XCTAssert(true, "this is to make unit test servers happy that at least one assert runs")
    }

}
