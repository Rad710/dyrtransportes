#!/bin/bash


# flask --app ./backend_flask/src/app.py run --host 0.0.0.0 --port 8080 --debug
# pnpm --prefix ./frontend_react/ run dev

# /home/rolando/anaconda3/envs/dyrtransportes_flask/bin/python backend_flask/src/app.py

# Script to build the React frontend and run the Flask backend

# Exit on any error
set -e

echo "Cleaning previous build..."
rm -rf ./backend_flask/src/static/assets/ 2>/dev/null || true
rm ./backend_flask/src/static/index.html 2>/dev/null || true

rm -rf ./frontend_react/node_modules/ 2>/dev/null || true
rm -rf ./frontend_react/dist/ 2>/dev/null || true


echo "Installing frontend dependencies..."
pnpm --prefix ./frontend_react/ install --frozen-lockfile

echo "Building frontend..."
pnpm --prefix ./frontend_react/ run build:dev

echo "Copying frontend build to backend static directory..."
mkdir -p ./backend_flask/src/static/
cp -r ./frontend_react/dist/* ./backend_flask/src/static/

echo "Changing to backend directory..."
cd ./backend_flask

echo "Running database migrations..."
alembic -c src/migrations/alembic.ini upgrade head

echo "Starting Flask server..."
flask --app src/app.py run --host 0.0.0.0 --port 8080 --debug