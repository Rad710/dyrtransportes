pnpm --prefix ./frontend_react/ install --frozen-lockfile

rm -r ./frontend_react/dist/
pnpm --prefix ./frontend_react/ run build

cp -r ./frontend_react/dist/* ./backend_flask/src/static/

flask --app ./backend_flask/src/app.py run --host 0.0.0.0 --port 8080