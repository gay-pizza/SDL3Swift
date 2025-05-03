// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import SDL3

guard SDL_Init(SDL_INIT_VIDEO) else {
  fatalError("SDL_Init(): \(String(cString: SDL_GetError()))")
}
defer { SDL_Quit() }

let flags = SDL_WindowFlags(SDL_WINDOW_RESIZABLE) | SDL_WindowFlags(SDL_WINDOW_HIGH_PIXEL_DENSITY)
guard let window = SDL_CreateWindow("Minimal SDL3Swift", 640, 480, flags) else {
  fatalError("SDL_CreateWindow(): \(String(cString: SDL_GetError()))")
}
defer { SDL_DestroyWindow(window) }

guard let renderer = SDL_CreateRenderer(window, nil) else {
  fatalError("SDL_CreateRenderer(): \(String(cString: SDL_GetError()))")
}
defer { SDL_DestroyRenderer(renderer) }
SDL_SetRenderVSync(renderer, 1)

loop: while true {
  var event = SDL_Event()
  while SDL_PollEvent(&event) {
    switch SDL_EventType(event.type) {
    case SDL_EVENT_QUIT:
      break loop
    default:
      break
    }
  }

  SDL_SetRenderDrawColor(renderer, 0x20, 0xA0, 0x20, 0xFF)
  SDL_RenderClear(renderer)
  SDL_RenderPresent(renderer)
}
