// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

import SDL3
import Foundation

// Initialise SDL
guard SDL_Init(SDL_INIT_VIDEO) else {
  fatalError("SDL_Init(): \(String(cString: SDL_GetError()))")
}
defer { SDL_Quit() }

// Create the window
let flags = SDL_WINDOW_RESIZABLE | SDL_WINDOW_HIGH_PIXEL_DENSITY
guard let window = SDL_CreateWindow("Minimal GPU Example", 640, 480, SDL_WindowFlags(flags)) else {
  fatalError("SDL_CreateWindow(): \(String(cString: SDL_GetError()))")
}
defer { SDL_DestroyWindow(window) }

// Open GPU device
// Pass all shader formats to allow all backends as we're not using shaders
let allShaderFormats =
  SDL_GPU_SHADERFORMAT_PRIVATE |
  SDL_GPU_SHADERFORMAT_SPIRV |
  SDL_GPU_SHADERFORMAT_DXBC |
  SDL_GPU_SHADERFORMAT_DXIL |
  SDL_GPU_SHADERFORMAT_MSL |
  SDL_GPU_SHADERFORMAT_METALLIB
guard let device = SDL_CreateGPUDevice(allShaderFormats, true, nil) else {
  fatalError("SDL_CreateGPUDevice(): \(String(cString: SDL_GetError()))")
}
defer { SDL_DestroyGPUDevice(device) }

// Attach device to window
guard SDL_ClaimWindowForGPUDevice(device, window) else {
  fatalError("SDL_ClaimWindowForGPUDevice(): \(String(cString: SDL_GetError()))")
}
defer { SDL_ReleaseWindowFromGPUDevice(device, window) }

// Print some information about the current display mode
if let driver = SDL_GetGPUDeviceDriver(device) {
  print("Driver:", String(cString: driver))
}
/*
if let mode = SDL_GetCurrentDisplayMode(SDL_GetPrimaryDisplay()) {
  print("BPP:", mode.pointee.format.bitsPerPixel)
}
*/
var windowWidth: Int32 = 0, windowHeight: Int32 = 0
if SDL_GetWindowSize(window, &windowWidth, &windowHeight) {
  print("Window size: \(windowWidth)x\(windowHeight)")
}
if SDL_GetWindowSizeInPixels(window, &windowWidth, &windowHeight) {
  print("Swapchain size: \(windowWidth)x\(windowHeight)")
}
print()

// Set swap interval
SDL_SetGPUSwapchainParameters(device, window, SDL_GPU_SWAPCHAINCOMPOSITION_SDR, SDL_GPU_PRESENTMODE_VSYNC)

var prevTick = SDL_GetTicksNS()

var frames = 0
var accumulator = 0.0

var theta = 0.0

// Main loop
loop: while true {
  // Poll & handle events
  var event = SDL_Event()
  while SDL_PollEvent(&event) {
    switch SDL_EventType(event.type) {
    case SDL_EVENT_QUIT:
      break loop
    default:
      break
    }
  }

  guard let cmdBuffer = SDL_AcquireGPUCommandBuffer(device) else {
    fatalError("SDL_AcquireGPUCommandBuffer(): \(String(cString: SDL_GetError()))")
  }

  // wait for & obtain the next swapchain texture
  var swapchainTex: OpaquePointer? = nil
  guard SDL_WaitAndAcquireGPUSwapchainTexture(cmdBuffer, window, &swapchainTex, nil, nil) else {
    fatalError("SDL_WaitAndAcquireGPUSwapchainTexture(): \(String(cString: SDL_GetError()))")
  }
  guard swapchainTex != nil else {
    SDL_CancelGPUCommandBuffer(cmdBuffer)
    continue
  }

  // Calculate delta time
  let tick = SDL_GetTicksNS()
  let delta = Double(tick &- prevTick) * 0.000000001
  prevTick = tick

  // Frames per second counter
  frames += 1
  accumulator += delta
  if accumulator >= 1.0 {
    print("FPS: \(frames)")
    frames = 0
    accumulator = fmod(accumulator, 1.0)
  }

  // Animate clear colour
  let uniSin = 0.5 + 0.5 * sin(Float(theta))
  let clear = SDL_FColor(
    r: 0.125 + 0.5 * uniSin,
    g: 0.625 - 0.5 * uniSin,
    b: 0.125,
    a: 1.0)
  theta = fmod(theta + delta / 1.5, 2 * .pi)

  // Render pass (clear the screen)
  var info = SDL_GPUColorTargetInfo()
  info.texture = swapchainTex
  info.clear_color = clear
  info.load_op = SDL_GPU_LOADOP_CLEAR
  info.store_op = SDL_GPU_STOREOP_STORE
  let pass = SDL_BeginGPURenderPass(cmdBuffer, &info, 1, nil)
  SDL_EndGPURenderPass(pass)

  SDL_SubmitGPUCommandBuffer(cmdBuffer)
}
