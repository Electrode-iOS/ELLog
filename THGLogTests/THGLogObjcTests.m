//
//  THGLogObjcTests.m
//  THGLog
//
//  Created by Brandon Sneed on 3/9/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
@import THGLog;
@import Crashlytics;


@interface THGLogObjcTests : XCTestCase

@end

@implementation THGLogObjcTests

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

    Logger *l = nil;
    THGLog(LogLevelDebug, @"value = %@", @1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
