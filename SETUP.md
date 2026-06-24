# Meccha Hub — Setup Guide

Two parts: the **frontend** (GitLab Pages, free) and the **token server** (Railway, free tier).

---

## Part 1 — Supabase (real-time sync)

1. Go to https://supabase.com → New project (free tier)
2. Go to **Database → SQL Editor → New query**
3. Paste the contents of `supabase-setup.sql` and hit Run
4. Go to **Project Settings → API**
5. Copy:
   - **Project URL** → this is your `SUPABASE_URL`
   - **anon public** key → this is your `SUPABASE_ANON`

---

## Part 2 — LiveKit (voice)

1. Go to https://livekit.io → Sign up → New project (free tier, 100 concurrent users)
2. From your project dashboard, copy:
   - **WebSocket URL** (starts with `wss://`) → this is your `LIVEKIT_URL`
   - **API Key** → `LIVEKIT_API_KEY`
   - **API Secret** → `LIVEKIT_API_SECRET`

---

## Part 3 — Deploy the token server (Railway)

The token server is a tiny Node.js app that hands out LiveKit tokens.
LiveKit needs this because you can't put your API secret in the browser.

1. Go to https://railway.app → New Project → Deploy from GitHub repo
   - Or: New Project → Empty project → Add service → GitHub repo
2. Point it at a repo containing `server.js` and `package.json`
3. Add environment variables in Railway dashboard:
   ```
   LIVEKIT_API_KEY=your_key_here
   LIVEKIT_API_SECRET=your_secret_here
   PORT=3000
   ```
4. Deploy — Railway gives you a URL like `https://meccha-hub-server.up.railway.app`
5. That URL is your `LIVEKIT_API` value

---

## Part 4 — Fill in your keys

Open `public/index.html` and find the CONFIG block near the top:

```js
const SUPABASE_URL   = 'YOUR_SUPABASE_URL';        // from Supabase project settings
const SUPABASE_ANON  = 'YOUR_SUPABASE_ANON_KEY';   // from Supabase project settings
const LIVEKIT_URL    = 'YOUR_LIVEKIT_WS_URL';       // wss://your-project.livekit.cloud
const LIVEKIT_API    = 'YOUR_LIVEKIT_SERVER_URL';   // your Railway URL
```

Replace all four values.

---

## Part 5 — Deploy frontend to GitLab Pages

1. Create a new GitLab repo
2. Push this whole folder to it
3. GitLab will auto-detect `.gitlab-ci.yml` and deploy
4. After ~2 min, your site is live at:
   `https://your-username.gitlab.io/your-repo-name`

Share that URL with your friends. Done.

---

## How it works

- **Host** opens the app, clicks "Create room" — everyone else clicks "Join"
- Host sees the **Host tab** where they assign who's seeker each round
- When host assigns someone as seeker, that player's hider chat and spots tab **lock instantly** across all devices
- **Voice channels**: tap "Hiders", "Everyone", or "Seeker" in the voice bar to join — seeker physically cannot join the Hiders voice channel
- **Spots**: hiders upload/paste screenshots — seeker can't see this tab at all
- **Mic button** in the top bar mutes/unmutes you in whatever voice channel you're in
- All of this syncs in real time via Supabase + LiveKit

---

## Free tier limits

| Service | Free limit | More than enough? |
|---------|-----------|-------------------|
| Supabase | 500MB DB, 2GB bandwidth | Yes, massively |
| LiveKit | 100 concurrent users | Yes |
| Railway | $5 credit/mo (~500hrs) | Yes for occasional gaming |
| GitLab Pages | Unlimited | Yes |
