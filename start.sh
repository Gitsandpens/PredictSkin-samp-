#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
[ -d .venv ] || python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
[ -d frontend/node_modules ] || (cd frontend && npm install)
(cd backend && uvicorn main:app --port 8000) &
BACK=$!
trap "kill $BACK" EXIT
cd frontend && npm run dev
