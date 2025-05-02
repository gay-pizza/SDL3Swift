cmake_minimum_required(VERSION "3.28" FATAL_ERROR)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "Minimum MacOS version" FORCE)
#set(CMAKE_Swift_LANGUAGE_VERSION 5)
project(SDL3Swift LANGUAGES C OBJC Swift)

set(_apple_platforms "Darwin;iOS;tvOS;visionOS;watchOS")
if (CMAKE_SYSTEM_NAME IN_LIST _apple_platforms)
  find_library(SDL3 SDL3 REQUIRED PATHS "${CMAKE_CURRENT_SOURCE_DIR}/Frameworks" NO_DEFAULT_PATH)
  add_library(SDL3::SDL3 SHARED IMPORTED)
  set_target_properties(SDL3::SDL3 PROPERTIES
    FRAMEWORK ON
    IMPORTED_LOCATION "${SDL3}"
    BUILD_RPATH "@loader_path/../Frameworks")
else()
  find_package(SDL3 REQUIRED CONFIG)
endif()

function (sdl3swift_xcode_properties target)
  if ("${SDL3}" MATCHES "xcframework")
    set_target_properties(${target} PROPERTIES
      XCODE_EMBED_FRAMEWORKS "${SDL3}"
      XCODE_EMBED_FRAMEWORKS_REMOVE_HEADERS_ON_COPY YES
      XCODE_EMBED_FRAMEWORKS_CODE_SIGN_ON_COPY YES)
  endif()
endfunction()

option(BUILD_EXAMPLES "Build example programs" ${PROJECT_IS_TOP_LEVEL})

add_subdirectory(Sources/SDLSwift)

if (BUILD_EXAMPLES)
  add_subdirectory(Sources/Examples/Minimal)
endif()
