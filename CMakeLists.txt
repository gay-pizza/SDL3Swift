cmake_minimum_required(VERSION "3.28" FATAL_ERROR)
# HACK: This should only really ever be set if we're the top level project,
#       but CMAKE_OSX_DEPLOYMENT_TARGET needs to be set before project() is
#       called, so we can't check PROJECT_IS_TOP_LEVEL yet, c'est la vie.
if (CMAKE_OSX_DEPLOYMENT_TARGET VERSION_LESS "10.13")
  set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "Minimum MacOS version" FORCE)
endif()
#set(CMAKE_Swift_LANGUAGE_VERSION 5)
project(SDL3Swift LANGUAGES C Swift)

option(USE_BUNDLED_FRAMEWORK "Link against the bundled SDL3.xcframework (Apple-only)" ${APPLE})
option(BUILD_EXAMPLES "Build example programs" ${PROJECT_IS_TOP_LEVEL})

set(_apple_platforms "Darwin;iOS;tvOS;visionOS;watchOS")
if (USE_BUNDLED_FRAMEWORK AND CMAKE_SYSTEM_NAME IN_LIST _apple_platforms)
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

add_subdirectory(Sources/SDLSwift)

if (BUILD_EXAMPLES)
  add_subdirectory(Sources/Examples/Minimal)
  add_subdirectory(Sources/Examples/GPUClear)
endif()
