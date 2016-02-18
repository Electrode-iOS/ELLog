//
//  ViewController.m
//  ELLogSampleObjc
//
//  Created by Brandon Sneed on 4/17/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

#import "ViewController.h"
@import ELLog;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //ELLogDebug(@"got log?  %@", @YES);

    Logger *logger = Logger.defaultInstance;
    [LoggerObjc log:logger logLevel:LogLevelDebug function:@"function" filename:@"file.m" line:100 format:@"got log? = %@, did you like it? %s", @YES, "yayussss..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
