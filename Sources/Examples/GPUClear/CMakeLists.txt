add_executable(GPUClear MACOSX_BUNDLE main.swift)
target_link_libraries(GPUClear SDLSwift::SDL3)
sdl3swift_xcode_properties(GPUClear)
sdl3swift_windows_copydll(GPUClear)
