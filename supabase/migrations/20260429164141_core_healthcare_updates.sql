-- Core healthcare updates (phase 1)
-- Covers: doctor ratings, disease classification, doctor-patient lifecycle,
-- chat/prescriptions support, emergency records CRUD foundation, location/distance helpers.

begin;

-- 1) Doctor ratings -----------------------------------------------------------
create table if not exists public.doctor_reviews (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  patient_id uuid not null references public.patients(id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  review_text text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (doctor_id, patient_id)
);

create index if not exists idx_doctor_reviews_doctor on public.doctor_reviews(doctor_id);
create index if not exists idx_doctor_reviews_patient on public.doctor_reviews(patient_id);

create or replace view public.doctor_avg_rating as
select
  doctor_id,
  round(avg(rating)::numeric, 2) as avg_rating,
  count(*)::int as total_reviews
from public.doctor_reviews
group by doctor_id;

-- 2) Diseases classification --------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'disease_type') then
    create type public.disease_type as enum ('chronic', 'normal');
  end if;
end $$;

create table if not exists public.diseases (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.patients(id) on delete cascade,
  disease_name text not null,
  disease_type public.disease_type not null default 'normal',
  notes text,
  diagnosed_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_diseases_patient on public.diseases(patient_id);
create index if not exists idx_diseases_type on public.diseases(disease_type);

-- 3) Doctor-patient relationship + chat/prescriptions ------------------------
alter table if exists public.doctor_patients
  add column if not exists start_date date not null default current_date,
  add column if not exists end_date date,
  add column if not exists connection_status text not null default 'active',
  add column if not exists last_message_at timestamptz;

create table if not exists public.doctor_patient_chats (
  id uuid primary key default gen_random_uuid(),
  doctor_patient_id uuid not null references public.doctor_patients(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid not null references public.doctor_patient_chats(id) on delete cascade,
  sender_user_id uuid not null references public.users(id) on delete cascade,
  message_text text,
  attachment_path text,
  created_at timestamptz not null default now(),
  check (coalesce(nullif(trim(message_text), ''), attachment_path) is not null)
);

create index if not exists idx_chat_messages_chat on public.chat_messages(chat_id, created_at desc);

create table if not exists public.prescriptions (
  id uuid primary key default gen_random_uuid(),
  doctor_patient_id uuid not null references public.doctor_patients(id) on delete cascade,
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  patient_id uuid not null references public.patients(id) on delete cascade,
  image_path text not null,
  notes text,
  prescribed_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists idx_prescriptions_dp on public.prescriptions(doctor_patient_id);

insert into storage.buckets (id, name, public)
select 'prescriptions', 'prescriptions', false
where not exists (select 1 from storage.buckets where id = 'prescriptions');

-- 4) Emergency records CRUD foundation ---------------------------------------
create table if not exists public.patient_emergencies (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.patients(id) on delete cascade,
  contact_name text not null,
  contact_phone text not null,
  relation text,
  is_primary boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_patient_emergencies_patient on public.patient_emergencies(patient_id);

-- 5) Surgery review structure (quantity + type) ------------------------------
create table if not exists public.surgery_reviews (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.patients(id) on delete cascade,
  surgery_type text not null,
  surgery_count int not null check (surgery_count >= 0),
  reviewed_by_doctor_id uuid references public.doctors(id) on delete set null,
  reviewed_at timestamptz not null default now(),
  notes text
);

create index if not exists idx_surgery_reviews_patient on public.surgery_reviews(patient_id);

-- 6) Doctor profile location + distance helpers ------------------------------
alter table if exists public.doctors
  add column if not exists governorate text,
  add column if not exists center text,
  add column if not exists latitude double precision,
  add column if not exists longitude double precision;

create table if not exists public.governorates (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.centers (
  id uuid primary key default gen_random_uuid(),
  governorate_id uuid not null references public.governorates(id) on delete cascade,
  name text not null,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now(),
  unique(governorate_id, name)
);

create or replace function public.calculate_center_distance_km(
  lat1 double precision,
  lon1 double precision,
  lat2 double precision,
  lon2 double precision
)
returns double precision
language sql
immutable
as $$
  select 6371 * acos(
    cos(radians(lat1)) * cos(radians(lat2)) * cos(radians(lon2) - radians(lon1))
    + sin(radians(lat1)) * sin(radians(lat2))
  );
$$;

-- 7) Connection error fix helper ---------------------------------------------
create or replace function public.connect_doctor_patient(
  p_doctor_id uuid,
  p_patient_id uuid
)
returns public.doctor_patients
language plpgsql
security definer
as $$
declare
  v_row public.doctor_patients;
begin
  insert into public.doctor_patients (doctor_id, patient_id, start_date, connection_status)
  values (p_doctor_id, p_patient_id, current_date, 'active')
  on conflict (doctor_id, patient_id)
  do update set
    end_date = null,
    connection_status = 'active'
  returning * into v_row;

  return v_row;
end;
$$;

commit;
