// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

#if os(Windows)
public extension SDL_EventType {
  init(_ value: UInt32) {
    self.init(Int32(value))
  }
}
#endif
