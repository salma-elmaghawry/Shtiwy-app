-- Updated Profiles schema: add phone, country, location (latitude/longitude), account_type enum default 'user'

-- =====================================================
-- EXTENSIONS
-- =====================================================

create extension if not exists "uuid-ossp";

-- =====================================================
-- ENUMS
-- =====================================================

-- account_type: default user; manager can be added later but not shown in UI
create type public.account_type as enum (
  'user',
  'manager',
  'admin'
);

create type public.user_role as enum (
  'user',
  'manager',
  'admin'
);

-- =====================================================
-- PROFILES
-- =====================================================

create table public.profiles (

  id uuid primary key
  references auth.users(id)
  on delete cascade,

  email text unique not null,

  full_name text,

  username text unique,

  avatar_url text,

  bio text,

  role public.user_role
  default 'user',

  account_type public.account_type
  default 'user',

  phone_number text,

  country text,

  latitude double precision,

  longitude double precision,

  address text,

  is_verified boolean
  default false,

  created_at timestamptz
  default now(),

  updated_at timestamptz
  default now()

);

-- =====================================================
-- UPDATED_AT FUNCTION
-- =====================================================

create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =====================================================
-- UPDATE TRIGGER
-- =====================================================

create trigger profiles_updated_at
before update
on public.profiles
for each row
execute procedure public.handle_updated_at();

-- =====================================================
-- AUTO CREATE PROFILE AFTER SIGNUP
-- =====================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin

  insert into public.profiles (
    id,
    email,
    full_name,
    avatar_url,
    role,
    account_type,
    phone_number,
    country,
    latitude,
    longitude,
    address
  )
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data->>'full_name',
      'New User'
    ),
    new.raw_user_meta_data->>'avatar_url',
    coalesce(
      (new.raw_user_meta_data->>'role')::public.user_role,
      'user'
    ),
    coalesce(
      (new.raw_user_meta_data->>'account_type')::public.account_type,
      'user'
    ),
    new.raw_user_meta_data->>'phone_number',
    new.raw_user_meta_data->>'country',
    case when (new.raw_user_meta_data->>'latitude') is not null then (new.raw_user_meta_data->>'latitude')::double precision else null end,
    case when (new.raw_user_meta_data->>'longitude') is not null then (new.raw_user_meta_data->>'longitude')::double precision else null end,
    new.raw_user_meta_data->>'address'
  );

  return new;

end;
$$;

create trigger on_auth_user_created
after insert
on auth.users
for each row
execute procedure public.handle_new_user();

-- =====================================================
-- ENABLE RLS
-- =====================================================

alter table public.profiles
enable row level security;

alter table public.interests
enable row level security;

alter table public.skills
enable row level security;

alter table public.profile_interests
enable row level security;

alter table public.profile_skills
enable row level security;

-- =====================================================
-- PROFILES POLICIES
-- =====================================================

create policy "Profiles are viewable by everyone"
on public.profiles
for select
using (true);

create policy "Users can insert own profile"
on public.profiles
for insert
with check (auth.uid() = id);

create policy "Users can update own profile"
on public.profiles
for update
using (auth.uid() = id);

-- =====================================================
-- (Other policies unchanged)
-- =====================================================

create policy "Anyone can view interests"
on public.interests
for select
using (true);

create policy "Anyone can view skills"
on public.skills
for select
using (true);

create policy "Users can view profile interests"
on public.profile_interests
for select
using (true);

create policy "Users can manage own interests"
on public.profile_interests
for all
using (auth.uid() = profile_id);

create policy "Users can view profile skills"
on public.profile_skills
for select
using (true);

create policy "Users can manage own skills"
on public.profile_skills
for all
using (auth.uid() = profile_id);

-- =====================================================
-- INDEXES
-- =====================================================

create index idx_profile_interests_profile
on public.profile_interests(profile_id);

create index idx_profile_skills_profile
on public.profile_skills(profile_id);

-- =====================================================
-- STORAGE BUCKETS
-- =====================================================

insert into storage.buckets (id, name, public)
values
('avatars', 'avatars', true);

-- =====================================================
-- SEED INTERESTS & SKILLS -- left as-is (unchanged)
-- =====================================================
