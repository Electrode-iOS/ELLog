## Crashlytics Support

Crashlytics support is optional and is not included within the ELLog framework. Source is supplied that you can use to log to Crashlytics using the following installation instructions:

## Installation

1. Add ELLog to your project as a submdodule
2. Embed ELLog.framework into your application
3. Add ELLog/Destinations/Crashlytics/LogCrashlyticsDestination.swift to your project. **MAKE SURE TO UNCHECK 'Copy files if needed'** This will tell Xcode to not copy the file into your project hierarchy, which allows the source to be updated when you update the ELLog submodule

## Using LogCrashlyticsDestination

```
        let crashlyticsDestination = LogCrashlyticsDestination(level: [.Error, .Debug])
        Logger.defaultInstance.addDestination(crashlyticsDestination)


        logger.log(.Debug, "Some breadcrumb you would like to see attached to a crash report")
```
