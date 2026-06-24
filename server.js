// server.js — LiveKit token server
// Deploy this to Railway, Render, or Fly.io
// Then set LIVEKIT_API in index.html to this server's URL

import { AccessToken } from 'livekit-server-sdk';
import express from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

const LK_API_KEY    = process.env.LIVEKIT_API_KEY;    // from LiveKit dashboard
const LK_API_SECRET = process.env.LIVEKIT_API_SECRET; // from LiveKit dashboard

// GET /token?room=meccha-main-hiders&identity=alex
app.get('/token', async (req, res) => {
  const { room, identity } = req.query;
  if (!room || !identity) return res.status(400).json({ error: 'room and identity required' });

  // Enforce channel access rules
  // Room names are like "meccha-main-hiders", "meccha-main-seeker", "meccha-main-all"
  // The client sends the correct room — server just validates it's a known channel
  const validChannels = ['hiders', 'seeker', 'all'];
  const channel = room.split('-').pop();
  if (!validChannels.includes(channel)) {
    return res.status(403).json({ error: 'Invalid channel' });
  }

  const at = new AccessToken(LK_API_KEY, LK_API_SECRET, {
    identity,
    ttl: '2h',
  });
  at.addGrant({ roomJoin: true, room, canPublish: true, canSubscribe: true });

  res.json({ token: await at.toJwt() });
});

app.get('/health', (_, res) => res.json({ ok: true }));

app.listen(process.env.PORT || 3000, () => {
  console.log('LiveKit token server running on port', process.env.PORT || 3000);
});
