import json
from pathlib import Path

SOURCES_FILE = "sources.json"


def load_sources():
    sources_file = get_path_to_file(SOURCES_FILE)
    if not sources_file.exists():
        raise FileNotFoundError(f"Sources file not found: {sources_file}")
    with sources_file.open() as f:
        return json.load(f).get("sources", [])


def get_path_to_file(relative_path) -> Path:
    return Path(__file__).parent.parent / relative_path
