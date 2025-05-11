// SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
// SPDX-License-Identifier: Zlib OR 0BSD

#if CMAKE_BUILD || canImport(Darwin)
@_exported import SDL3
#else
@_exported import CSDL3
#endif
