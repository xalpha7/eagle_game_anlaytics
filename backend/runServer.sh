#!/usr/bin/env bash

echo "Starting backend..."

cd "$(dirname "$0")"

echo "Current Directory:"
pwd

echo "Using local venv directly..."

PYTHON="./gamevenv/bin/python"

echo "Python:"
$PYTHON --version

echo "Uvicorn:"
$PYTHON -m pip show uvicorn

echo "Starting server..."

$PYTHON app.py