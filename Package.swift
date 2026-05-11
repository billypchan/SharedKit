// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "SharedKit",
  defaultLocalization: "en",
  platforms: [.iOS(.v17), .watchOS(.v10), .macOS(.v14)],
  products: [
    .library(name: "SharedKit", targets: ["SharedKit"]),
  ],
  targets: [
    .target(
      name: "SharedKit",
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "SharedKitTests",
      dependencies: ["SharedKit"]
    ),
  ]
)
