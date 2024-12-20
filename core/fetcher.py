from datetime import datetime
from services.downloader import Downloader
import feedparser


class ArxivFetcher:
    def __init__(self, downloader: Downloader):
        self.downloader = downloader

    def fetch_rss_articles(self, url: str, subject: str):
        """
        Fetch and parse articles from an RSS feed URL.
        :param url: RSS feed URL.
        :param subject: Subject category (e.g., "cs").
        :return: List of article records.
        """
        rss_content = self.downloader.download_rss(url)
        feed = feedparser.parse(rss_content)

        articles = []
        for entry in feed.entries:
            published_date = datetime.strptime(
                entry.published, "%a, %d %b %Y %H:%M:%S %z"
            ).isoformat()
            articles.append(
                {
                    "ID": "arXiv" + entry.id.split("/")[-1][13:-2],
                    "Subject": subject,
                    "Title": entry.title,
                    "Authors": entry.author,
                    "PublicationDate": published_date,
                    "ArticleUrl": entry.link,
                    "DocumentUrl": entry.link.replace("abs", "pdf"),
                    "Summary": "",
                }
            )
        return articles
