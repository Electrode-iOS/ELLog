//
//  ELLogObjcTests.m
//  ELLog
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
@import ELLog;
@import Crashlytics;


@interface ELLogObjcTests : XCTestCase

@end

@implementation ELLogObjcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");

    ELLogger *l = ELLogger.defaultInstance;
    ELLogTextfileDestination *textfile = [[ELLogTextfileDestination alloc] initWithFilename:@"blah.txt"];
    textfile.level = LogLevelError;

    [l addDestination:textfile];
    ELLog(LogLevelDebug, @"value = %@, do you like it?  %@", @1, @"Yayusss...");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
