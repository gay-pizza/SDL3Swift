# Add interface library here to invoke 'module.modulemap'
add_library(CSDL3 INTERFACE)
set_property(TARGET CSDL3 PROPERTY Swift_MODULE_NAME "SDL3")
# Include 'shim.h' and link SDL
target_include_directories(CSDL3 INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(CSDL3 INTERFACE SDL3::SDL3)

# Add public wrapper
add_library(SDLSwift STATIC
  SDL_Version.swift
  Events/SDL_EventType.swift
  SDL3.swift)
add_library(SDLSwift::SDL3 ALIAS SDLSwift)
set_property(TARGET SDLSwift PROPERTY Swift_MODULE_NAME "SDLSwift")
target_compile_definitions(SDLSwift PRIVATE CMAKE_BUILD)
target_link_libraries(SDLSwift CSDL3)
