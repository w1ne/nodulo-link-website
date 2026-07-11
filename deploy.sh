#!/usr/bin/env bash
# One-shot deploy for nodulo.link -> Cloudflare Pages + D1 email store.
# Run:  bash ~/Projects/nodulo-link/deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

echo "==> 1/6  Login (a browser window opens — click Authorize; no time pressure here)"
npx wrangler login

echo "==> 2/6  Create Pages project (ok if it already exists)"
npx wrangler pages project create nodulo-link --production-branch=main 2>/dev/null || true

echo "==> 3/6  Create D1 database (ok if it already exists)"
npx wrangler d1 create nodulo-emails 2>/dev/null || true

echo "==> 4/6  Write database_id into wrangler.toml"
DB_ID=$(npx wrangler d1 list --json | python3 -c "import sys,json;d=json.load(sys.stdin);print(next(x['uuid'] for x in d if x['name']=='nodulo-emails'))")
python3 - "$DB_ID" <<'PY'
import sys,re
db=sys.argv[1]; p="wrangler.toml"
s=open(p).read()
s=re.sub(r'database_id = ".*"', f'database_id = "{db}"', s)
open(p,"w").write(s)
print("    database_id =", db)
PY

echo "==> 5/6  Create subscribers table on the remote D1"
npx wrangler d1 execute nodulo-emails --remote --file=schema.sql

echo "==> 6/6  Deploy the site"
npx wrangler pages deploy . --project-name=nodulo-link --commit-dirty=true

echo
echo "DONE. Your site is live at the *.pages.dev URL printed above."
echo "Last step (dashboard, ~4 clicks): Workers & Pages -> nodulo-link -> Custom domains"
echo "  -> 'Set up a domain' -> nodulo.link  (and add www if you want it)."
