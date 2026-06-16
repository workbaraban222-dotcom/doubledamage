from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import os
import sys

ROOT = Path(__file__).resolve().parent
os.chdir(ROOT)

with open(ROOT / "serve_site.log", "a", encoding="utf-8") as log:
    log.write("starting server on http://127.0.0.1:4173\n")
    log.flush()
    try:
        ThreadingHTTPServer(("127.0.0.1", 4173), SimpleHTTPRequestHandler).serve_forever()
    except Exception as exc:
        log.write(f"server error: {exc}\n")
        log.flush()
        sys.exit(1)
