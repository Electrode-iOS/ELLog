# [3.0.0](https://github.com/Electrode-iOS/ELLog/releases/tag/v3.0.0)

- Migrate to Swift 3
  - Remove conformance to BooleanType, since it does not exist anymore.
  - Make `LogConsoleDestination` and `LogTextfileDestination` concrete.

# [2.1.0](https://github.com/Electrode-iOS/ELLog/releases/tag/v2.1.0)

- Add support for Xcode 8, Swift 2.3, and iOS SDK 10

# [2.0.4](https://github.com/Electrode-iOS/ELLog/releases/tag/v2.0.4)

- Disable `EMBEDDED_CONTENT_CONTAINS_SWIFT` build configuration. Frameworks are not allowed to have this enabled when submitting to Apple.

# [2.0.3](https://github.com/Electrode-iOS/ELLog/releases/tag/2.0.3)

- Fixed issue with a call to NSLog crashing.
- Workaround for a Swift 2.2 bug where a framework that isn't imported in a file causes ambiguity errors.

# [2.0.1](https://github.com/Electrode-iOS/ELLog/releases/tag/v2.0.1)

- Removed redundant `LogDestinationProtocol` conformace already implemented in `LogDestinationBase`

# [2.0.0](https://github.com/Electrode-iOS/ELLog/releases/tag/v2.0.0)

- Updated for Swift 2.2 and Xcode 7.3 compatibility

# [1.0.0](https://github.com/Electrode-iOS/ELLog/releases/tag/v1.0.0)

- Namespaced all log levels with "EL".
- Removed unneccessary framework from unit tests
- Renamed `removeAllDestionations` to `removeAllDestinations`
- Updated to allow ELLog and THGLog to coexist
- Added ability to enable/disable a given logger instance.
- Shuffled up log level to use description instead of debugDescription.
