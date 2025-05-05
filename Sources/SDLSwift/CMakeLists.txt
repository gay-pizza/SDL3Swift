add_library(SDLSwift INTERFACE)
add_library(SDLSwift::SDL3 ALIAS SDLSwift)
set_property(TARGET SDLSwift PROPERTY Swift_MODULE_NAME "SDL3")

target_include_directories(SDLSwift INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")

target_link_libraries(SDLSwift INTERFACE SDL3::SDL3)

target_sources(SDLSwift INTERFACE
  ../SDL3/SDL3.swift
  ../SDL3/SDL_Version.swift)
