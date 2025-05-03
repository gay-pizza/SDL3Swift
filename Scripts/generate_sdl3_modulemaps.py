#!/usr/bin/env python3
# SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
# SPDX-License-Identifier: Zlib OR 0BSD

import sys
from pathlib import Path
import plistlib
from generate_sdl3_shim import generate_shim


def generate_shims_modulemaps(xcframework: Path):
  # Read XCFramework property list
  with xcframework.joinpath("Info.plist").open("rb") as f:
    plist = plistlib.load(f)

  for a in plist["AvailableLibraries"]:
    # Get framework paths
    libid = a["LibraryIdentifier"]
    framework = xcframework / libid / a["LibraryPath"]
    library = xcframework / libid / a["BinaryPath"]
    headers = library.parent / "Headers"
    modules = library.parent / "Modules"

    # Generate shim.h for Swift
    with headers.joinpath("shim.h").open("w") as shim:
      shim.write("#pragma once\n\n")
      generate_shim(shim, headers)

    # Create modules folder in framework
    modules.mkdir(exist_ok=True)
    if str(modules.relative_to(framework)).startswith("Versions"):
      symlink = framework.joinpath("Modules")
      if symlink.is_symlink():
        symlink.unlink()
      symlink.symlink_to("Versions/Current/Modules")

    # Generate module.modulemap for framework
    with modules.joinpath("module.modulemap").open("w") as map:
      map.writelines([
        "framework module SDL3 [extern_c] {\n",
        "    header \"shim.h\"\n",
        "    export *\n",
        "}\n"])


if __name__ == "__main__":
  # Find path to target XCFramework
  root = Path(sys.argv[0]).resolve().parent.parent
  generate_shims_modulemaps(root / "Frameworks/SDL3.xcframework")
