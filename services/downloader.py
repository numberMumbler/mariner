import requests
import io


class Downloader:
    @staticmethod
    def download_rss(url: str) -> str:
        """
        Download an RSS feed and return its content as a string.
        """
        response = requests.get(url)
        response.raise_for_status()
        return response.text

    @staticmethod
    def download_pdf(url: str) -> io.BytesIO:
        """
        Download a PDF and return its content as a BytesIO object.
        """
        response = requests.get(url, stream=True)
        response.raise_for_status()
        return io.BytesIO(response.content)
