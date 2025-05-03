#!/usr/bin/env python3

import re
import sys
from pathlib import Path
import plistlib


def main():
  # Find path to target XCFramework
  root = Path(sys.argv[0]).resolve().parent.parent
  xcframework = root / "Frameworks/SDL3.xcframework"

  # Read XCFramework property list
  with xcframework.joinpath("Info.plist").open("rb") as f:
    plist = plistlib.load(f)

  sdl_uint64c_pattern = re.compile(r"#define\s+(\w+)\s+SDL_UINT64_C\((\w+)\)\s+/\*(.+)\*/")

  for a in plist["AvailableLibraries"]:
    # Get framework paths
    libid = a["LibraryIdentifier"]
    framework = xcframework / libid / a["LibraryPath"]
    library = xcframework / libid / a["BinaryPath"]
    headers = library.parent / "Headers"
    modules = library.parent / "Modules"

    # Generate shim.h for Swift
    with headers.joinpath("shim.h").open("w") as shim:
      shim.writelines([
        "#pragma once\n\n",
        "#include <SDL3/SDL.h>\n"])
      for h in sorted(headers.glob("**/*.h")):
        with h.open("r") as hf:
          has_matches = False
          for line in hf:
            m = sdl_uint64c_pattern.match(line)
            if m is not None:
              if not has_matches:
                shim.write(f"\n/* {h.name} */\n")
                has_matches = True
              shim.writelines([
                f"#undef {m.group(1)}\n",
                f"#define {m.group(1)} {m.group(2)}ul  /*{m.group(3)}*/\n"])

    # Create modules folder in framework
    modules.mkdir(exist_ok=True)
    if str(modules.relative_to(framework)).startswith("Versions"):
      symlink = framework.joinpath("Modules")
      if not framework.joinpath("Modules").is_symlink():
        symlink.symlink_to("Versions/Current/Modules")

    # Generate module.modulemap for framework
    with modules.joinpath("module.modulemap").open("w") as map:
      map.writelines([
        "framework module SDL3 [extern_c] {\n",
        "    header \"shim.h\"\n",
        "    export *\n",
        "}\n"])


if __name__ == "__main__":
  main()
