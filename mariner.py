import argparse
from services.commands import fetch_articles


def main():
    parser = argparse.ArgumentParser(
        description="Mariner CLI for academic article processing."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Fetch command
    fetch_parser = subparsers.add_parser("fetch", help="Fetch new articles")
    fetch_parser.add_argument(
        "--output", required=False, help="Path to the output file"
    )

    args = parser.parse_args()

    # Handle commands
    if args.command == "fetch":
        fetch_articles(args.output)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
