#!/usr/bin/env python3
# SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
# SPDX-License-Identifier: Zlib OR 0BSD

import sys
from pathlib import Path
import re
from typing import TextIO


sdl_uint64c_pattern = re.compile(r"#define\s+(\w+)\s+SDL_UINT64_C\((\w+)\)\s+/\*(.+)\*/")


def generate_shim(shim: TextIO | Path, headers: Path):
  if isinstance(shim, Path):
    with shim.open("w") as f:
      generate_shim(f, headers)
      return

  shim.writelines([
    #"#pragma once\n\n",
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


if __name__ == "__main__":
  root = Path(sys.argv[0]).resolve().parent.parent
  header_dir = root / "Frameworks/SDL3.xcframework/macos-arm64_x86_64/SDL3.framework/Versions/Current/Headers"
  generate_shim(root / "Sources/SDLSwift/shim.h", header_dir)
  generate_shim(root / "Sources/CSDL3/shim.h", header_dir)
