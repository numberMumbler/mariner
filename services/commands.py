import json
from core.fetcher import ArxivFetcher
from pathlib import Path
from services.config import load_sources
from services.downloader import Downloader


def fetch_articles(output_path):
    """
    Fetch articles from all sources defined in sources.json.
    :param output_path: Path to the output file where articles will be saved.
    """
    sources = load_sources()

    fetcher = ArxivFetcher(Downloader())
    articles = []
    for source in sources:
        articles += fetcher.fetch_rss_articles(source["url"], source["subject"])

    if output_path is None:
        print(f"{articles}")
    else:
        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)
        with output_file.open("w") as f:
            json.dump(articles, f, indent=2)
