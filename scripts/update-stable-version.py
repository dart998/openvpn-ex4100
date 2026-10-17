#!/usr/bin/env python3
from pathlib import Path
import re
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: update-stable-version.py <repo-tag>")

repo_tag = sys.argv[1]
image = f"ovelayos/gluetun-wd-ex4100:{repo_tag}"

compose = Path("compose/portainer-stack.yml")
text = compose.read_text()
text, n = re.subn(
    r"ovelayos/gluetun-wd-ex4100:[A-Za-z0-9._-]+",
    image,
    text,
    count=1,
)
if n != 1:
    raise SystemExit(f"could not update image in {compose}")
compose.write_text(text)

env = Path(".env.example")
text = env.read_text()
text, n = re.subn(
    r"^GLUETUN_IMAGE=.*$",
    f"GLUETUN_IMAGE={image}",
    text,
    count=1,
    flags=re.MULTILINE,
)
if n != 1:
    raise SystemExit("could not update .env.example")
env.write_text(text)

readme = Path("README.md")
text = readme.read_text()
text, n = re.subn(
    r"Current stable image: `ovelayos/gluetun-wd-ex4100:[^`]+`",
    f"Current stable image: `{image}`",
    text,
    count=1,
)
if n != 1:
    raise SystemExit("could not update README stable image")
readme.write_text(text)
