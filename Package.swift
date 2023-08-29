// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TeslaSwift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)
    ],
    products: [
        .library(name: "TeslaSwift", targets: ["TeslaSwift"]),
        .library(name: "TeslaSwiftStreaming", targets: ["TeslaSwiftStreaming"]),
        .library(name: "TeslaSwiftRx", targets: ["TeslaSwiftRx"]),
        .library(name: "TeslaSwiftCombine", targets: ["TeslaSwiftCombine"]),
        .library(name: "TeslaSwiftStreamingRx", targets: ["TeslaSwiftStreamingRx"]),
        .library(name: "TeslaSwiftStreamingCombine", targets: ["TeslaSwiftStreamingCombine"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6"),
        //.package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", Package.Dependency.Requirement.branch("feature/spm-support"))
    ],
    targets: [
        .target(name: "TeslaSwift"),
        .target(name: "TeslaSwiftStreaming", dependencies: ["TeslaSwift", "Starscream"], path: "Sources/Extensions/Streaming"),
        .target(name: "TeslaSwiftRx", dependencies: ["TeslaSwift", "RxSwift", "RxCocoa"], path: "Sources/Extensions/Rx"),
        .target(name: "TeslaSwiftCombine", dependencies: ["TeslaSwift"], path: "Sources/Extensions/Combine"),
        .target(name: "TeslaSwiftStreamingRx", dependencies: ["TeslaSwiftStreaming", "TeslaSwiftRx"], path: "Sources/Extensions/StreamingRx"),
        .target(name: "TeslaSwiftStreamingCombine", dependencies: ["TeslaSwiftStreaming", "TeslaSwiftCombine"], path: "Sources/Extensions/StreamingCombine"),
        //.testTarget(name: "TeslaSwiftTests", dependencies: ["TeslaSwiftPMK", "PromiseKit", "OHHTTPStubsSwift"], path: "TeslaSwiftTests")
    ]
)
