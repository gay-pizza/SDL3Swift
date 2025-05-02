#!/usr/bin/env python3

import sys
from pathlib import Path
import re


def main():
  root = Path(sys.argv[0]).resolve().parent.parent
  with root.joinpath("Sources/SDLSwift/shim.h").open("w") as shim:
    shim.write("#include <SDL3/SDL.h>\n")
    header_dir = root / "Frameworks/SDL3.xcframework/macos-arm64_x86_64/SDL3.framework/Versions/Current/Headers"
    p = re.compile(r"#define\s+(\w+)\s+SDL_UINT64_C\((\w+)\)\s+/\*(.+)\*/")
    for h in sorted(header_dir.glob(r"**/*.h")):
      with h.open("r") as hf:
        has_matches = False
        for l in hf:
          m = p.match(l)
          if m is not None:
            if not has_matches:
              shim.write(f"\n/* {h.name} */\n")
              has_matches = True
            shim.write(f"#undef {m.group(1)}\n#define {m.group(1)} {m.group(2)}ul  /*{m.group(3)}*/\n")


if __name__ == "__main__":
  main()
