// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import XCTest
@testable import SDL3

final class TestAvailability: XCTestCase {
  func testAPIAvailability() {
    XCTAssertNotNil(SDL_Init.self)
    XCTAssertNotNil(SDL_Quit.self)
    XCTAssertNotNil(SDL_GetVersion.self)
    XCTAssertNotNil(SDL_CreateWindow.self)
  }
}
