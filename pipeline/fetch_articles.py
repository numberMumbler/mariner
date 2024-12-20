import luigi
from datetime import datetime
from services.commands import fetch_articles


class FetchArticles(luigi.Task):
    date = luigi.DateParameter(default=datetime.today())

    def output(self):
        output_file = f"output/articles_{self.date.strftime('%Y-%m-%d')}.json"
        return luigi.LocalTarget(output_file)

    def run(self):
        fetch_articles(self.output().path)
