#!/usr/bin/env python3
"""Install/remove only Outfit's user-owned application launcher and icon."""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import stat
import tempfile

ID = "io.github.ctl0v0.omafit"
ASSETS = Path(__file__).resolve().parents[1] / "assets"
FILES = (
    (f"{ID}.svg", f"icons/hicolor/scalable/apps/{ID}.svg",
     (b"<!-- Outfit managed icon -->", b"<!-- OmaFit managed icon -->")),
    (f"{ID}.desktop", f"applications/{ID}.desktop",
     (b"X-Outfit-Managed=true", b"X-OmaFit-Managed=true")),
)


def sync(data: Path, remove: bool = False) -> None:
    if not data.is_absolute():
        raise ValueError("The application data directory must be absolute.")
    # Check all destinations before changing either file.
    for _source, relative, markers in FILES:
        target = data / relative
        if target.is_symlink():
            raise ValueError(f"Refusing to replace a symlink: {target}")
        if target.exists():
            info = target.stat()
            if (not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid()
                    or info.st_size > 64 * 1024):
                raise ValueError(f"An unmanaged file already exists: {target}")
            # Accept the historical ownership marker for in-place upgrades/removal.
            lines = [line.strip() for line in target.read_bytes().splitlines()]
            if not any(marker in lines for marker in markers):
                raise ValueError(f"An unmanaged file already exists: {target}")
    for source, relative, _marker in FILES:
        target = data / relative
        if remove:
            target.unlink(missing_ok=True)
            continue
        body = (ASSETS / source).read_bytes()
        if target.exists() and target.read_bytes() == body:
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        fd, staging = tempfile.mkstemp(prefix=".outfit-", dir=target.parent)
        try:
            with os.fdopen(fd, "wb") as stream:
                stream.write(body)
                os.fchmod(stream.fileno(), 0o644)
                stream.flush()
                os.fsync(stream.fileno())
            os.replace(staging, target)
        finally:
            Path(staging).unlink(missing_ok=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--remove", action="store_true")
    args = parser.parse_args()
    configured = Path(os.environ.get("XDG_DATA_HOME", ""))
    data = configured if configured.is_absolute() else Path.home() / ".local/share"
    try:
        sync(data, args.remove)
    except (OSError, ValueError) as error:
        raise SystemExit(str(error))
    print("Outfit Apps launcher " + ("removed." if args.remove else "installed."))
