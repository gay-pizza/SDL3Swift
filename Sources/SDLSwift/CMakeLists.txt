add_library(SDLSwift STATIC
  SDL_Version.swift
  SDL3.swift)
add_library(SDLSwift::SDL3 ALIAS SDLSwift)
set_property(TARGET SDLSwift PROPERTY Swift_MODULE_NAME "SDLSwift")
target_compile_definitions(SDLSwift PRIVATE CMAKE_BUILD)

# Include shim and link SDL
target_include_directories(SDLSwift INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(SDLSwift SDL3::SDL3)
