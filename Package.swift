// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "SDL3Swift",
  platforms: [ .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .macCatalyst(.v13) ],
  products: [
    .library(name: "SDLSwift", targets: [ "SDLSwift" ]),
  ],
  targets: [
    .target(
      name: "SDLSwift",
      dependencies: [
        .target(
          name: "SDLFramework",
          condition: .when(platforms: [ .macOS, .iOS, .tvOS, .macCatalyst ])),
        .target(
          name: "CSDL3",
          condition: .when(platforms: [ .linux, .windows ])),
      ],
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
    .systemLibrary(
      name: "CSDL3",
      pkgConfig: "sdl3",
      providers: [
        .aptItem([ "libsdl3-dev" ]),
        .yumItem([ "SDL3-devel" ]),
      ]),
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
