// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "SDL3",
  platforms: [ .macOS(.v10_13), .iOS(.v12), .tvOS(.v12) ],
  products: [
    .library(name: "SDL3", targets: [ "SDL3" ]),
  ],
  targets: [
    .target(
      name: "SDL3",
      dependencies: [
        .target(
          name: "SDLFramework",
          condition: .when(platforms: [ .macOS ])),
        .target(
          name: "CSDL3",
          condition: .when(platforms: [ .linux, .windows ])),
      ]),
    .testTarget(
      name: "SDLTests",
      dependencies: [ "SDL3" ]),
    .binaryTarget(
      name: "SDLFramework",
      path: "Frameworks/SDL3.xcframework"),
    .systemLibrary(
      name: "CSDL3",
      pkgConfig: "sdl3",
      providers: [
        .aptItem([ "libsdl3-dev" ]),
        .yumItem([ "SDL3-devel" ]),
      ]),
    .executableTarget(
      name: "Minimal",
      dependencies: [ "SDL3" ],
      path: "Sources/Examples/Minimal",
      exclude: [ "CMakeLists.txt" ]),
    .executableTarget(
      name: "GPUClear",
      dependencies: [ "SDL3" ],
      path: "Sources/Examples/GPUClear",
      exclude: [ "CMakeLists.txt" ]),
  ]
)
