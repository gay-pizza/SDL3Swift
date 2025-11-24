// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import Darwin

/// Protocol that implements `main`
public protocol SDLmain: ~Copyable {
  typealias SDL_main = (@convention(c) (
      _ argc: CInt,
      _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
    ) -> CInt)

  /// Entry point that is passed to `SDL_RunApp`.
  static var entryPoint: SDL_main { get }
}

public extension SDLmain {
  static func main() -> Void {
    // Hand control to SDL to run the entry point
    SDL_RunApp(CommandLine.argc, CommandLine.unsafeArgv, Self.entryPoint, nil)
  }
}

public protocol SDLApplication: ~Copyable {
  static func appInit(arguments: [String]) -> SDL_AppResult
  static func appIterate() -> SDL_AppResult
  static func appEvent(event: SDL_Event) -> SDL_AppResult
  static func appQuit(result: SDL_AppResult)
}

public extension SDLApplication {

  /// Provide entry point that calls `SDL_EnterAppMainCallbacks`.
  //static var entryPoint: SDL_main { SDL_AppMain }

  static func main() -> Void {
    withUnsafePointer(to: self) {
      //$0.withMemoryRebound(to: SDLApplication.Type.self, capacity: 1) {
        // Smuggle pointer to self through the black market
        globalAppPointer = $0
      }

      // Hand control to SDL to run the entry point
      exit(SDL_RunApp(CommandLine.argc, CommandLine.unsafeArgv, SDL_AppMain, nil))
    //}
  }
}

// MARK: - Implementation gore

// SAFETY: Used once in the main thread to work around being unable to pass a local pointer into a closure.
nonisolated(unsafe) fileprivate var globalAppPointer: UnsafePointer<SDLApplication.Type>?

fileprivate func SDL_AppInit(
  _ appstate: UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
  _ argc: CInt,
  _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
) -> SDL_AppResult {
  // Grab application instance from main
  guard let application = globalAppPointer else {
    fatalError("application pointer was nil! Was the pre-run step overriden?")
  }
  appstate!.pointee = UnsafeMutableRawPointer(mutating: globalAppPointer)

  defer {
    // Zero out unsafeAppstate now that it is unused
    globalAppPointer = nil
  }

  // Collect modified C-style argc/argv into string array
  let arguments = (0..<Int(argc)).map { String(cString: argv![$0]!) }
  return application.pointee.appInit(arguments: arguments)
}

fileprivate func SDL_AppIterate(_ appstate: UnsafeMutableRawPointer?) -> SDL_AppResult {
  UnsafeRawPointer(appstate)!.withMemoryRebound(to: SDLApplication.Type.self, capacity: 1) { application in
    application.pointee.appIterate()
  }
}

fileprivate func SDL_AppEvent(_ appstate: UnsafeMutableRawPointer?,
  _ event: UnsafeMutablePointer<SDL_Event>?
) -> SDL_AppResult {
  UnsafeRawPointer(appstate)!.withMemoryRebound(to: SDLApplication.Type.self, capacity: 1) { application in
    application.pointee.appEvent(event: event!.pointee)
  }
}

fileprivate func SDL_AppQuit(_ appstate: UnsafeMutableRawPointer?, _ result: SDL_AppResult) {
  UnsafeRawPointer(appstate)!.withMemoryRebound(to: SDLApplication.Type.self, capacity: 1) { application in
    application.pointee.appQuit(result: result)
  }
}

fileprivate func SDL_AppMain(_ argc: CInt, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?) -> CInt {
  SDL_EnterAppMainCallbacks(argc, argv, SDL_AppInit, SDL_AppIterate, SDL_AppEvent, SDL_AppQuit)
}
