add_executable(Minimal MACOSX_BUNDLE main.swift)
target_link_libraries(Minimal SDLSwift::SDL3)
sdl3swift_xcode_properties(Minimal)
sdl3swift_windows_copydll(Minimal)
