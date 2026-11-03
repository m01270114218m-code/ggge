-- VOX ROYALE foundational schema (phase 1)
-- Apply to a new Supabase project. This migration intentionally excludes financial,
-- moderation, and RTC authorization flows until server-side functions are implemented.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'مستخدم جديد' check (char_length(display_name) between 1 and 40),
  avatar_path text,
  country_code char(2),
  bio text not null default '' check (char_length(bio) <= 240),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.rooms (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete restrict,
  room_number bigint generated always as identity unique,
  name text not null check (char_length(name) between 2 and 60),
  description text not null default '' check (char_length(description) <= 500),
  category text not null default 'social' check (char_length(category) between 2 and 32),
  visibility text not null default 'public' check (visibility in ('public', 'private')),
  seat_count smallint not null default 8 check (seat_count in (4, 6, 8, 9, 12, 16)),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.room_members (
  room_id uuid not null references public.rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (room_id, user_id)
);

create table if not exists public.room_seats (
  room_id uuid not null references public.rooms(id) on delete cascade,
  seat_number smallint not null check (seat_number between 1 and 16),
  occupant_id uuid references public.profiles(id) on delete set null,
  is_locked boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (room_id, seat_number),
  unique (room_id, occupant_id)
);

create index if not exists rooms_discovery_idx on public.rooms (is_active, category, created_at desc);
create index if not exists room_members_user_idx on public.room_members (user_id, joined_at desc);
create index if not exists room_seats_occupant_idx on public.room_seats (occupant_id) where occupant_id is not null;

alter table public.profiles enable row level security;
alter table public.rooms enable row level security;
alter table public.room_members enable row level security;
alter table public.room_seats enable row level security;

create policy "Profiles are viewable by authenticated users" on public.profiles
  for select to authenticated using (true);
create policy "Users create their own profile" on public.profiles
  for insert to authenticated with check (id = (select auth.uid()));
create policy "Users update their own profile" on public.profiles
  for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "Authenticated users discover public active rooms" on public.rooms
  for select to authenticated using (visibility = 'public' and is_active);
create policy "Owners create rooms for themselves" on public.rooms
  for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "Owners update their rooms" on public.rooms
  for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy "Owners delete their rooms" on public.rooms
  for delete to authenticated using (owner_id = (select auth.uid()));

create policy "Members can read membership of visible rooms" on public.room_members
  for select to authenticated using (
    exists (select 1 from public.rooms r where r.id = room_id and r.visibility = 'public' and r.is_active)
    or user_id = (select auth.uid())
  );
create policy "Users may add themselves to public rooms" on public.room_members
  for insert to authenticated with check (
    user_id = (select auth.uid()) and
    exists (select 1 from public.rooms r where r.id = room_id and r.visibility = 'public' and r.is_active)
  );
create policy "Users may leave rooms themselves" on public.room_members
  for delete to authenticated using (user_id = (select auth.uid()));

create policy "Seats visible for public active rooms" on public.room_seats
  for select to authenticated using (
    exists (select 1 from public.rooms r where r.id = room_id and r.visibility = 'public' and r.is_active)
  );
-- Deliberately no client-side insert/update/delete policies for seats: seat assignment
-- must be implemented via a validated server-side function to prevent impersonation.
