# nodulo.link

Landing page for **nodulo** — snap-together electronic UI blocks that self-discover and let AI wire your controls to your equipment and home devices.

## Stack
- Static `index.html` with a full-screen video hero
- Cloudflare Pages hosting
- Preorder email capture → Pages Function (`functions/api/subscribe.js`) → D1 database `nodulo-emails`

## Deploy
Auto-deploys to Cloudflare Pages on every push to `main` via GitHub Actions
(`.github/workflows/deploy.yml`). Requires repo secrets:
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

Manual deploy:
```
npx wrangler pages deploy . --project-name=nodulo-link
```

## Read the preorder list
```
npx wrangler d1 execute nodulo-emails --remote \
  --command "SELECT email, created_at FROM subscribers ORDER BY created_at DESC"
```
