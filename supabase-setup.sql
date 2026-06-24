-- Run this in your Supabase SQL editor (Database → SQL Editor → New query)

-- Members table (presence)
create table if not exists members (
  id text primary key,
  name text not null,
  role text not null default 'hider',
  room text not null default 'meccha-main',
  online boolean default true,
  updated_at timestamptz default now()
);

-- Messages table
create table if not exists messages (
  id bigserial primary key,
  room text not null,
  channel text not null,  -- 'hider' | 'all'
  sender text not null,
  sender_id text not null,
  text text not null,
  created_at timestamptz default now()
);

-- Game state table (phase, roles — host pushes updates here)
create table if not exists gamestate (
  room text primary key,
  phase text default 'hide',
  roles jsonb default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Spots table (base64 images — hiders only)
create table if not exists spots (
  id bigserial primary key,
  room text not null,
  sender text not null,
  sender_id text not null,
  data_url text not null,
  created_at timestamptz default now()
);

-- Enable realtime on all tables
alter publication supabase_realtime add table members;
alter publication supabase_realtime add table messages;
alter publication supabase_realtime add table gamestate;
alter publication supabase_realtime add table spots;

-- RLS: allow all reads and writes (it's a private game between friends)
alter table members enable row level security;
alter table messages enable row level security;
alter table gamestate enable row level security;
alter table spots enable row level security;

create policy "allow all" on members for all using (true) with check (true);
create policy "allow all" on messages for all using (true) with check (true);
create policy "allow all" on gamestate for all using (true) with check (true);
create policy "allow all" on spots for all using (true) with check (true);
