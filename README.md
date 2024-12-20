# mariner

An AI-driven tool that provides personalized summaries and feeds of new research papers across a wide spectrum of disciplines, enhancing discovery and understanding in the academic landscape.

## Setup

Created the virtual environment and install dependencies

### Local setup

```sh
virtualenv -p python3.12 env
source env/bin/activate
pip install -r requirements.txt
```

Make sure you can execute the pipeline script

## Run

Start the services, including [Luigi scheduler](http://localhost:8082/)

```sh
docker compose up -d
```

Manually run the daily pipeline with `./daily_fetch.sh`. This is useful when the scheduler container wasn't running for some reason.

You can also kick off a test run of the pipeline:

```sh
PYTHONPATH=. luigi --module pipeline DailyFetch --local-scheduler
```

### Manual commands

Fetch new articles to a file (leave out `--output` option to print to standard out)

```sh
python mariner.py fetch --output output/articles.json
```
