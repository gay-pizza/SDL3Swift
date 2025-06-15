// swift-tools-version: 6.0

import PackageDescription

let sdl3SwiftDependencies: [Target.Dependency]
let csdl3Target: Target
#if canImport(ObjectiveC)
  sdl3SwiftDependencies = [
    .target(
      name: "SDLFramework",
      condition: .when(platforms: [ .macOS, .iOS, .tvOS, .macCatalyst ])),
  ]
  csdl3Target = .systemLibrary(name: "CSDL3")  // Dummy target
#else
  sdl3SwiftDependencies = [
    .target(
      name: "CSDL3",
      condition: .when(platforms: [ .linux, .windows ])),
  ]
  csdl3Target = .systemLibrary(
    name: "CSDL3",
    pkgConfig: "sdl3",
    providers: [
      .aptItem(["libsdl3-dev"]),
      .yumItem(["SDL3-devel"]),
    ])
#endif

let package = Package(
  name: "SDL3Swift",
  platforms: [ .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .macCatalyst(.v13) ],
  products: [
    .library(name: "SDLSwift", targets: [ "SDLSwift" ]),
  ],
  targets: [
    .target(
      name: "SDLSwift",
      dependencies: sdl3SwiftDependencies,
      exclude: [
        "CMakeLists.txt",
        "module.modulemap",
        "shim.h",
      ]),
    .testTarget(
      name: "SDLTests",
      dependencies: [ "SDLSwift" ]),
    .binaryTarget(
      name: "SDLFramework",
      path: "Frameworks/SDL3.xcframework"),
    csdl3Target,
    .executableTarget(
      name: "Minimal",
      dependencies: [ "SDLSwift" ],
      path: "Sources/Examples/Minimal",
      exclude: [ "CMakeLists.txt" ]),
    .executableTarget(
      name: "GPUClear",
      dependencies: [ "SDLSwift" ],
      path: "Sources/Examples/GPUClear",
      exclude: [ "CMakeLists.txt" ]),
  ]
)
