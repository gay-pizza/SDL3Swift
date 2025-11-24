// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import SDLSwift

struct ApplicationImplementation: ApplicationDelegate {

  private var window: OpaquePointer?
  private var renderer: OpaquePointer?
  private var isFullScreen = false
  private var tick = 0
  private var frameCount = 0
  private var previousTickNS: UInt64 = 0
  private var fpsText = ""

  mutating func appInit() throws(ApplicationError) {
    // Set target update rate to 5 Hz
    SDL_SetHint(SDL_HINT_MAIN_CALLBACK_RATE, "5")

    // Initialise SDL
    guard SDL_Init(SDL_INIT_VIDEO) else {
      throw .sdlError("SDL_Init", String(cString: SDL_GetError()))
    }

    // Create the window & renderer
    guard SDL_CreateWindowAndRenderer("AppMainCallbacks", 640, 480, SDL_WindowFlags(SDL_WINDOW_RESIZABLE),
      &self.window, &self.renderer
    ) else {
      throw .sdlError("SDL_CreateWindowAndRenderer", String(cString: SDL_GetError()))
    }

    SDL_SetRenderLogicalPresentation(renderer, 640, 480, SDL_LOGICAL_PRESENTATION_LETTERBOX)

    self.previousTickNS = SDL_GetTicksNS()
  }

  mutating func appIterate() throws(ApplicationError) {
    // Calcuate frames per second
    let ticksNS = SDL_GetTicksNS()
    if Int64(bitPattern: ticksNS &- self.previousTickNS) >= 1000000000
    {
      self.previousTickNS = ticksNS
      self.fpsText = "\(self.frameCount) FPS"
      self.frameCount = 0
    }
    else
    {
      self.frameCount += 1
    }

    // Clear the screen
    SDL_SetRenderDrawColorFloat(renderer, 0, 0, 0, 1)
    SDL_RenderClear(renderer)

    // Animate rectangle each frame
    var dst = SDL_FRect(
      x: 32 + 64 * Float(self.tick & 0x1),
      y: 32 + 64 * Float(self.tick >> 1),
      w: 64,
      h: 64)
    SDL_SetRenderDrawColorFloat(renderer, 1, 1, 1, 1)
    SDL_RenderFillRect(renderer, &dst)
    self.tick += 1
    if self.tick == 4 {
      self.tick = 0
    }

    // Draw text field labels
    SDL_SetRenderDrawColorFloat(renderer, 0, 1, 0, 1)
    SDL_RenderDebugText(renderer, 32, 480 - 72, "Frames/second:")
    SDL_RenderDebugText(renderer, 32, 480 - 48, "Callback rate (0-9/SHIFT + 0-9):")
    SDL_RenderDebugText(renderer, 32, 480 - 32, "Vertical synch (V/SHIFT + V):")

    // Display frames-per-second
    SDL_RenderDebugText(renderer, 32 + 150, 480 - 72, self.fpsText)

    // Display callback rate
    if let callbackRateText = SDL_GetHint(SDL_HINT_MAIN_CALLBACK_RATE) {
      SDL_RenderDebugText(renderer, 32 + 275, 480 - 48, callbackRateText)
    }

    // Display renderer vSync setting
    var vSync: Int32 = 0
    if SDL_GetRenderVSync(renderer, &vSync) {
      let vSyncText = switch vSync {
      case SDL_RENDERER_VSYNC_DISABLED: "SDL_RENDERER_VSYNC_DISABLED"
      case SDL_RENDERER_VSYNC_ADAPTIVE: "SDL_RENDERER_VSYNC_ADAPTIVE"
      default: String(vSync)
      }
      SDL_RenderDebugText(renderer, 32 + 275, 480 - 32, vSyncText)
    }

    SDL_RenderPresent(renderer)

  }

  mutating func appEvent(event: SDL_Event) throws(ApplicationError) -> SDL_AppResult {
    switch SDL_EventType(event.type) {
    case SDL_EVENT_QUIT:
      return SDL_APP_SUCCESS
    case SDL_EVENT_KEY_DOWN:
      if !event.key.repeat {
        switch SDL_Keycode(event.key.key) {
        case SDLK_ESCAPE:
          return SDL_APP_SUCCESS
        case SDLK_0:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "waitevent" : "0")
        case SDLK_1:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "1" : "10")
        case SDLK_2:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "2" : "20")
        case SDLK_3:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "3" : "30")
        case SDLK_4:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "4" : "40")
        case SDLK_5:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "5" : "50")
        case SDLK_6:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "6" : "60")
        case SDLK_7:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "7" : "70")
        case SDLK_8:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "8" : "80")
        case SDLK_9:
          self.setCallbackRate(hz: (event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0) ? "9" : "90")
        case SDLK_V:
          self.toggleVSync(adaptive: event.key.mod & UInt16(SDL_KMOD_SHIFT) != 0)
        case SDLK_RETURN:
          if event.key.mod & UInt16(SDL_KMOD_ALT) != 0 {
            self.toggleFullScreen()
          }
        default:
          break
        }
      }
      return SDL_APP_CONTINUE
    case SDL_EVENT_WINDOW_ENTER_FULLSCREEN, SDL_EVENT_WINDOW_LEAVE_FULLSCREEN:
      self.isFullScreen = event.type == SDL_EVENT_WINDOW_ENTER_FULLSCREEN.rawValue
      return SDL_APP_CONTINUE
    default:
      return SDL_APP_CONTINUE
    }
  }

  mutating func appQuit() {
    SDL_DestroyRenderer(self.renderer)
    SDL_DestroyWindow(self.window)
    SDL_Quit()
  }

  private mutating func setCallbackRate(hz: String) {
    guard SDL_SetHint(SDL_HINT_MAIN_CALLBACK_RATE, hz) else {
      eprint("ERROR: SDL_SetHint:", String(cString: SDL_GetError()))
      return
    }
  }

  private mutating func toggleVSync(adaptive: Bool = false) {
    var vSync: Int32 = 0
    guard SDL_GetRenderVSync(renderer, &vSync) else {
      eprint("ERROR: SDL_GetRenderVSync:", String(cString: SDL_GetError()))
      return
    }
    let on = adaptive ? SDL_RENDERER_VSYNC_ADAPTIVE : 1
    vSync = vSync == on
      ? SDL_RENDERER_VSYNC_DISABLED
      : on
    guard SDL_SetRenderVSync(renderer, vSync) else {
      eprint("ERROR: SDL_SetRenderVSync:", String(cString: SDL_GetError()))
      return
    }
  }

  private mutating func toggleFullScreen() {
    if !SDL_SetWindowFullscreen(self.window, !self.isFullScreen) {
      eprint("ERROR: SDL_SetWindowFullscreen:", String(cString: SDL_GetError()))
    }
  }
}
