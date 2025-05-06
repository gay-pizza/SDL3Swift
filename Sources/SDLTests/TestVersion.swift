// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import Testing
@testable import SDLSwift

@Test func testVersion() {
  let dynamic = SDL_GetVersion()

  #expect(SDL_VERSION == SDL_VERSIONNUM(
    SDL_VERSIONNUM_MAJOR(SDL_VERSION),
    SDL_VERSIONNUM_MINOR(SDL_VERSION),
    SDL_VERSIONNUM_MICRO(SDL_VERSION)))

  #expect(SDL_VERSIONNUM_MAJOR(SDL_VERSION) == 3)
  #expect(SDL_VERSIONNUM_MINOR(SDL_VERSION) >= 2)
  #expect(SDL_VERSIONNUM_MICRO(SDL_VERSION) >= 0)

  #expect(dynamic >= SDL_VERSION)
  #expect(SDL_VERSION_ATLEAST(
    SDL_VERSIONNUM_MAJOR(dynamic),
    SDL_VERSIONNUM_MINOR(dynamic),
    SDL_VERSIONNUM_MICRO(dynamic)))
}
