// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import SDLSwift
import Foundation

@main
struct ApplicationRunner: SDLApplication {
  nonisolated(unsafe) static var appDelegate: ApplicationDelegate!

  static func appInit(arguments: [String]) -> SDL_AppResult {
    appDelegate = ApplicationImplementation()
    do {
      try appDelegate.appInit()
    } catch {
      eprint("ERROR:", error)
      return SDL_APP_FAILURE
    }
    return SDL_APP_CONTINUE
  }

  static func appIterate() -> SDL_AppResult {
    do {
      try appDelegate.appIterate()
    } catch {
      eprint("ERROR:", error)
      return SDL_APP_FAILURE
    }
    return SDL_APP_CONTINUE
  }

  static func appEvent(event: SDL_Event) -> SDL_AppResult {
    do {
      return try appDelegate.appEvent(event: event)
    } catch {
      eprint("ERROR:", error)
      return SDL_APP_FAILURE
    }
  }

  static func appQuit(result: SDL_AppResult) {
    appDelegate.appQuit()
    switch result {
    case SDL_APP_SUCCESS: eprint("Application quit successfully")
    case SDL_APP_FAILURE: eprint("Application quit unsuccessfully")
    default: eprint("Unknown result:", result)
    }
  }
}

struct StandardErrorStream: TextOutputStream, Sendable {
  private static let stderr = FileHandle.standardError

  mutating func write(_ string: String) {
    Self.stderr.write(Data(string.utf8))
  }
}

internal func eprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  var stderr = StandardErrorStream()
  print(items, separator: separator, terminator: terminator, to: &stderr)
}
