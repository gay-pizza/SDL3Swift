// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

/// Construct a numeric version from version components.
///
/// (1,2,3) becomes 1002003.
///
/// - Parameters:
///   - major: The major version number.
///   - minor: The minor version number.
///   - patch: The patch (or micro) version number.
///
/// - Returns: The combined numeric version.
@inlinable public func SDL_VERSIONNUM(_ major: Int32, _ minor: Int32, _ patch: Int32) -> Int32 {
  major * 1000000 + minor * 1000 + patch
}

/// Extracts the major component from a version number.
///
/// 1002003 becomes 1.
///
/// - Parameter version: The version number.
///
/// - Returns: The major version component.
@inlinable public func SDL_VERSIONNUM_MAJOR(_ version: Int32) -> Int32 {
  version / 1000000
}

/// Extracts the minor component from a version number.
///
/// 1002003 becomes 2.
///
/// - Parameter version: The version number.
///
/// - Returns: The minor version component.
@inlinable public func SDL_VERSIONNUM_MINOR(_ version: Int32) -> Int32 {
  (version / 1000) % 1000
}

/// Extracts the micro component from a version number.
///
/// 1002003 becomes 3.
///
/// - Parameter version: The version number.
///
/// - Returns: The micro (or patch level) version component.
@inlinable public func SDL_VERSIONNUM_MICRO(_ version: Int32) -> Int32 {
  version % 1000
}

/// The version number for the current SDL version.
///
/// See also: `SDL_GetVersion`.
@inlinable public var SDL_VERSION: Int32 {
  SDL_VERSIONNUM(
    SDL_MAJOR_VERSION,
    SDL_MINOR_VERSION,
    SDL_MICRO_VERSION)
}

/// Compare version components against the compiled SDL version.
///
/// - Parameters:
///   - major: The major version component.
///   - minor: The minor version component.
///   - patch: The patch (or micro) version component.
///
/// - Returns: `true` if compiled with SDL at least X.Y.Z, otherwise `false`.
@inlinable public func SDL_VERSION_ATLEAST(_ major: Int32, _ minor: Int32, _ patch: Int32) -> Bool {
  SDL_VERSION >= SDL_VERSIONNUM(major, minor, patch)
}
