create table public.patients (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  gender text null,
  blood_type text null,
  height_cm numeric null,
  weight_kg numeric null,
  emergency_contact jsonb null,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  date_of_birth text null,
  constraint patients_pkey primary key (id),
  constraint patients_patient_id_fkey foreign KEY (patient_id) references users (id)
) TABLESPACE pg_default;

create index IF not exists idx_patients_auth_user_id on public.patients using btree (patient_id) TABLESPACE pg_default;

create trigger trg_patients_updated_at BEFORE
update on patients for EACH row
execute FUNCTION set_updated_at ();

create table public.surgeries (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  operation_name text not null,
  operation_date date null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint surgeries_pkey primary key (id),
  constraint surgeries_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_surgeries_patient on public.surgeries using btree (patient_id) TABLESPACE pg_default;

create table public.users (
  id uuid not null default auth.uid (),
  created_at timestamp with time zone not null default now(),
  name text null,
  email text null,
  image text null,
  phone text null,
  role text null,
  constraint users_pkey primary key (id)
) TABLESPACE pg_default;

create table public.users (
  id uuid not null default auth.uid (),
  created_at timestamp with time zone not null default now(),
  name text null,
  email text null,
  image text null,
  phone text null,
  role text null,
  constraint users_pkey primary key (id)
) TABLESPACE pg_default;

create table public.medications (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  medication_name text not null,
  dosage text null,
  frequency text null,
  start_date date null,
  end_date date null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint medications_pkey primary key (id),
  constraint medications_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;

create table public.lab_tests (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  test_name text null,
  file_path text null,
  test_date date null,
  test_number text null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint lab_tests_pkey primary key (id),
  constraint lab_tests_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_lab_patient on public.lab_tests using btree (patient_id) TABLESPACE pg_default;

create table public.lab_tests (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  test_name text null,
  file_path text null,
  test_date date null,
  test_number text null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint lab_tests_pkey primary key (id),
  constraint lab_tests_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_lab_patient on public.lab_tests using btree (patient_id) TABLESPACE pg_default;



create table public.doctor_specialties (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text null,
  icon text null,
  is_active boolean null default true,
  created_at timestamp with time zone null default now(),
  constraint doctor_specialties_pkey primary key (id)
) TABLESPACE pg_default;


create table public.doctor_patients (
  id uuid not null default gen_random_uuid (),
  doctor_id uuid not null,
  patient_id uuid not null,
  created_at timestamp with time zone null default now(),
  constraint doctor_patients_pkey primary key (id),
  constraint doctor_patients_unique unique (doctor_id, patient_id),
  constraint doctor_patients_doctor_id_fkey foreign KEY (doctor_id) references doctors (id) on delete CASCADE,
  constraint doctor_patients_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;


create table public.chronic_conditions (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  name text not null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint chronic_conditions_pkey primary key (id),
  constraint chronic_conditions_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;

create index IF not exists idx_chronic_patient on public.chronic_conditions using btree (patient_id) TABLESPACE pg_default;


create table public.allergies (
  id uuid not null default gen_random_uuid (),
  patient_id uuid not null,
  allergy_name text not null,
  severity text null,
  notes text null,
  created_at timestamp with time zone null default now(),
  constraint allergies_pkey primary key (id),
  constraint allergies_patient_id_fkey foreign KEY (patient_id) references patients (id) on delete CASCADE
) TABLESPACE pg_default;



insert into storage.buckets (id, name, owner, created_at, updated_at, public)
values 
  ('lab-tests', 'Lab Tests', NULL, now(), now(), true),
  ('patient-photos', 'Patient Photos', NULL, now(), now(), true),
  ('medical-documents', 'Medical Documents', NULL, now(), now(), true),
  ('carelink-files', 'CareLink Files', NULL, now(), now(), true);



  