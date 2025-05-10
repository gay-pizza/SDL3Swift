// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import Testing
@testable import SDLSwift

@Test func testFlags() {
  let flags = SDL_WindowFlags(SDL_WINDOW_MINIMIZED | SDL_WINDOW_HIDDEN)
  #expect(flags == 0x48)
}
