#!/usr/bin/env python3
# SPDX-FileCopyrightText: (C) 2025 Gay Pizza Specifications <gay.pizza>
# SPDX-License-Identifier: Zlib OR 0BSD

import shutil
import sys
from pathlib import Path
import urllib.request
import urllib.error
import tempfile
import subprocess
from generate_sdl3_modulemaps import generate_shims_modulemaps


def build(release_ver: str):
  # Find path to target XCFramework
  root = Path(sys.argv[0]).resolve().parent.parent
  xcframework = root / "Frameworks/SDL3.xcframework"

  # Download specified SDL release to a temporary DMG disk image
  ver = release_ver
  with tempfile.NamedTemporaryFile(suffix=".dmg") as fp:
    try:
      url = f"https://github.com/libsdl-org/SDL/releases/download/release-{ver}/SDL3-{ver}.dmg"
      print("Downloading:", url, file=sys.stderr)
      with urllib.request.urlopen(url) as response:
        fp.write(response.read())
    except urllib.error.URLError as e:
      sys.exit(str(e))

    # Mount DMG at '/Volumes/SDL3'
    subprocess.run(["hdiutil", "attach", fp.name], check=True)

    try:
      # Remove old xcframework
      if xcframework.is_dir():
        shutil.rmtree(xcframework)

      # Copy xcframework from DMG to destination
      shutil.copytree("/Volumes/SDL3/SDL3.xcframework", xcframework, symlinks=True)
    finally:
      # Unmount disk image
      subprocess.run(["hdiutil", "detach", "/Volumes/SDL3"], check=True)

  # Generate shims and modulemaps for each available library
  generate_shims_modulemaps(xcframework)


if __name__ == "__main__":
  if len(sys.argv) != 2:
    print(f"Usage: ./{Path(sys.argv[0]).name} <version>", file=sys.stderr)
  else:
    build(sys.argv[1])
