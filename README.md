# ELLog [![Build Status](https://travis-ci.org/Electrode-iOS/ELLog.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELLog)

ELLog is a framework that provides versatile logging options for Swift and Objective-C code.

## Introduction

ELLog provides a default instance that funnels through NSLog to the console. It also provides options to log to a textfile.  It's fully extensible and makes it easy to add new logging destinations.

Provides the following functionality:

* log(level, message) - Uses Logger.defaultInstance to log to the console.
* Macros for use in Objective-C.
* Logger classes can be created should you want to log differently in a particular section of your app.
* Ability to add custom destinations to a given Logger instance.  Add one, or add many.
* Ability to specify levels per destination.  ie: Only log .Error level messages to Crashlytics.

## Optional Features

ELLog provides optional logging to Crashlytics. See the README in Destinations/Crashlytics/README.md

## Common Usage

A basic out of the box setup, log to .Debug and ultimately to the console:

```Swift
log(.Debug, "HEAD KNIGHT: Ni!")
```

Log to a custom Logger instance:
```Swift
let headKnight = Logger()

headKnight.log(.Debug, "We are the Knights Who Say... Ni!")
```

Configure and use a custom logger instance:
```Swift
let headKnight = Logger()

// we want to log any messages that are flagged with .Error or .Debug
let shrubbery = LogCrashlyticsDestination(level: [LogLevel.Error, LogLevel.Debug])

// add it to our logger instance.
headKnight.addDestination(shrubbery)

// this will go to the Crashlytics destination.
headKnight.log(.Debug, "We are the Knights Who Say... Ni!")

// this won't go anywhere.  we didn't setup a destination for .Info.
headKnight.log(.Info, "We are the Knights Who Say... Ni!")

// this will go to the Crashlytics destination as well.
headKnight.log(.Error, "We are the Knights Who Say... Ni!")
```

Customize the Logger's default instance and send a log message:
```Swift
// .Error log messages should go to Crashlytics, yeah?
let shrubbery = LogCrashlyticsDestination(.Error)

// Remember, defaultInstance is setup to log to console.
// Let's add a destination for Crashlytics as well.
Logger.defaultInstance.addDestination(shrubbery)

// We want this message to go to both .Debug AND .Error.
log(.Debug | .Error, "We shall say 'nee' again to you if you do not appease us.")
```
or...
```Objc
LogTextfileDestination *gardenStore = [[LogTextfileDestination alloc] initWithFilename:@"errors.txt"];
gardenStore.level = LogLevelError;

[Logger.defaultInstance addDestination:gardenStore];

...

ELLog(ELLogLevelError, @"value = %@", @1);

// or ...

ELLogError(@"value = %@", @1);
```

Use a custom logging instance in Objective-C:
```Objc
LogTextfileDestination *gardenStore = [[LogTextfileDestination alloc] initWithFilename:@"errors.txt"];
gardenStore.level = LogLevelError;

Logger *myLogger = [[Logger alloc] init];
[myLogger addDestination:gardenStore];

...

ELLogCustom(myLogger, LogLevelError, @"value = %@", @1);
```

## Contributions

We appreciate your contributions to all of our projects and look forward to interacting with you via Pull Requests, the issue tracker, via Twitter, etc.  We're happy to help you, and to have you help us.  We'll strive to answer every PR and issue and be very transparent in what we do.

When contributing code, please refer to our [Dennis](https://github.com/Electrode-iOS/Dennis).

## License

The MIT License (MIT)

Copyright (c) 2015 Walmart, WalmartLabs, and other Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
