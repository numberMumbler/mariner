from datetime import datetime
import luigi
from pipeline.fetch_articles import FetchArticles


class DailyFetch(luigi.Task):
    date = luigi.DateParameter(default=datetime.today())

    def requires(self):
        return FetchArticles(date=self.date)

    def output(self):
        return luigi.LocalTarget(
            f"output/pipeline_status_{self.date.strftime('%Y-%m-%d')}.txt"
        )

    def run(self):
        with self.output().open("w") as f:
            f.write("completed")
