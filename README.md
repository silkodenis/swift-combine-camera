[![License](https://img.shields.io/github/license/silkodenis/swift-combine-camera.svg)](https://github.com/silkodenis/swift-combine-camera/blob/main/LICENSE)
![swift](https://github.com/silkodenis/swift-combine-camera/actions/workflows/swift.yml/badge.svg?branch=main)

# Combine Camera

Combine Camera is a Swift package for integrating video capturing in iOS applications, built using Combine and AVFoundation in a declarative style, well-suited for UDF (Unidirectional Data Flow) architectures.

## Features

- Declarative programming style with Combine
- Simple and intuitive video capturing setup
- Support for switching cameras
- Requesting camera access and managing access status
- Real-time pixel buffer processing

### Requirements

- **iOS 14**+
- **Xcode 12**+
- **Swift 5.3**+

### Using Swift Package Manager from Xcode
To add CombineCamera to your project in Xcode:
1. Open your project in Xcode.
2. Navigate to `File` → `Swift Packages` → `Add Package Dependency...`.
3. Paste the repository URL: `https://github.com/silkodenis/swift-combine-camera.git`.
4. Choose the version you want to use (you can specify a version, a commit, or a branch).
5. Click `Next` and Xcode will download the package and add it to your project.

### Using Swift Package Manager from the Command Line

If you are managing your Swift packages manually or through a package.swift file, add CombineCamera as a dependency:

1. Open your `Package.swift`.
2. Add `CombineCamera` to your package's dependencies:

```swift
let package = Package(
    name: "YourProjectName",
    dependencies: [
        .package(url: "https://github.com/silkodenis/swift-combine-camera.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["CombineCamera"]
        )
    ]
)
```

This setup specifies that CombineCamera should be pulled from the master branch and included in the YourTargetName target of your project.

## Demo Application

To see a working example of how to use the CombineCamera package, check out the CombineCamera [Demo App](https://github.com/silkodenis/combine-camera-demo-app) repository. This demo application demonstrates how to integrate CombineCamera in an iOS project with a UDF (Unidirectional Data Flow) architecture using Combine.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License
This project is licensed under the [Apache License, Version 2.0](LICENSE).
