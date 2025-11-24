// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import SDLSwift
import Foundation

protocol ApplicationDelegate: ~Copyable {
  mutating func appInit() throws(ApplicationError)
  mutating func appIterate() throws(ApplicationError)
  mutating func appEvent(event: SDL_Event) throws(ApplicationError) -> SDL_AppResult
  mutating func appQuit()
}

enum ApplicationError: Error {
  case sdlError(StaticString, String)
}

extension ApplicationError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .sdlError(let call, let why): "\(call): \(why)"
    }
  }
}
