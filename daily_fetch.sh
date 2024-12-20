#!/bin/bash

# Save the current working directory
ORIGINAL_DIR="$(pwd)"

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script's directory
cd "$SCRIPT_DIR" || exit 1

# Activate the virtual environment
source env/bin/activate

# Set PYTHONPATH to the project root (script's directory)
export PYTHONPATH="$SCRIPT_DIR"

# Run the Luigi pipeline
luigi --module pipeline DailyFetch --scheduler-host localhost  >> "$SCRIPT_DIR/logs/pipeline_$(date +'%Y-%m-%d').log" 2>&1

# Restore the original working directory
cd "$ORIGINAL_DIR" || exit 1
