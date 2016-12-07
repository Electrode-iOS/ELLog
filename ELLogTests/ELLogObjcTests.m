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
#import "ELLogTests-Swift.h"


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


- (void) runTestsOn:(ELLogger *)logger {
    NSNumber *number = [NSNumber numberWithInt:1234];
    
    [logger removeAllDestinations];
    
    // This destination captures the LogDetail sent to Logger
    ELLogUnitTestDestination *unitTestDestination = [[ELLogUnitTestDestination alloc] init];
    [logger addDestination:unitTestDestination];
    
    NSString *testMessage = [NSString stringWithFormat:@"hello %@", number];
    NSInteger testLogLevel = ELLogLevelError | ELLogLevelDebug;
    
    // Call the Obj-C interface directly to test outside of macro
    [ELLoggerObjc log:logger
             logLevel:testLogLevel
             function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
             filename:[NSString stringWithUTF8String:__FILE__]
                 line:__LINE__
               format:testMessage];

    // Cannot test 'level' because optional scalars are no longer exported to Obj-C
    XCTAssertEqualObjects(unitTestDestination.lastLogDetail.message, testMessage);
}

- (void) testInstance {
    ELLogger *logger = [[ELLogger alloc] init];
    [self runTestsOn:logger];
}


- (void) testSingleton {
    [self runTestsOn:ELLogger.defaultInstance];
}

- (void)testMacros {
    ELLogDebug(@"testing that ELLogDebug builds");
    ELLogVerbose(@"testing that ELLogVerbose builds");
    ELLogInfo(@"testing that ELLogInfo builds");
    ELLogError(@"testing that ELLogError builds");
}

@end
