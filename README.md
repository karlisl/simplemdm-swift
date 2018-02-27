# SimpleMDM Swift

![CocoaPods](https://img.shields.io/cocoapods/v/SimpleMDM.svg) ![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.12+-222222.svg)

Swift library for SimpleMDM API.

**Please Note:** This is not the offical library and therefore is not officially supported. It does not currently wrap the complete functionality of the SimpleMDM API. For a current listing of API functionality, please refer to the SimpleMDM documentation at https://www.simplemdm.com/docs/api/.


## Requirements

- iOS 9.0+ | macOS 10.12+
- Xcode 9

## Integration

#### CocoaPods (iOS 9+, OS X 10.12+)

You can use [CocoaPods](http://cocoapods.org/) to install `SimpleMDM` by adding it to your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
    pod 'SimpleMDM'
end
```

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `SimpleMDM` by adding the proper description to your `Package.swift` file:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/karlisl/simplemdm-swift.git", from: "0.1.0"),
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually (iOS 9+, OS X 10.12+)

To use this library in your project manually just drag SimpleMDM.swift to the project tree.

## Usage

### Initialization

```swift
import SimpleMDM
```

```swift
// Set SimpleMDM API key
SimpleMDM.apiKey = "ab46akuRfn19x1O"
```

### Apps

```swift
// List all apps
SimpleMDM.Apps.all { (apps) in
    print(apps)
}

// Retreive specific app
SimpleMDM.Apps.find(appId: 1234) { (app) in
    print(app)
}
```

### App groups

```swift
// Update associated apps on associated devices
SimpleMDM.AppGroups.update(appGroupId: 1234) { (success) in
    print(success)
}
```

### Devices

```swift
// List all devices
SimpleMDM.Devices.all { (devices) in
    print(devices)
}

// List installed apps for specific device
SimpleMDM.Devices.installedApps(forDeviceWithId: 1234) { (apps) in
    print(apps)
}

// Push assigned apps to specific device
SimpleMDM.Devices.pushApps(deviceId: 1234) { (success) in
    print(success)
}

// Refresh information about specific device
SimpleMDM.Devices.refresh(deviceId: 1234) { (success) in
    print(success)
}
```

### Device groups

```swift
// List all device groups
SimpleMDM.DeviceGroups.all { (deviceGroups) in
    print(deviceGroups)
}
```

### Managed App Configs

```swift
// List all managed app configs for specific app
SimpleMDM.ManagedAppConfigs.all(appId: 1234) { (managedAppConfigs) in
    print(managedAppConfigs)
}
```

## License

SimpleMDM Swift is released under the [MIT License](LICENSE).