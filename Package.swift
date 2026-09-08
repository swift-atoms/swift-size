// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-size",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Size", targets: ["Size"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-vector.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
    ],
    targets: [
        .target(name: "Size", dependencies: [
            .product(name: "Vector", package: "swift-vector"),
            .product(name: "Magnitude", package: "swift-magnitude"),
        ]),
        .testTarget(name: "Size Tests", dependencies: [.target(name: "Size")]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
