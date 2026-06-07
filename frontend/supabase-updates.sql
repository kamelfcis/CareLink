-- Additional RLS policies for medications, allergies, and vaccinations
-- Run this after the main supabase.sql file

-- Enable RLS on new tables
alter table public.medications enable row level security;
alter table public.allergies enable row level security;
alter table public.vaccinations enable row level security;

-- RLS policies for medications
create policy "medications_owner_policy" on public.medications
  for all
  using ( auth.uid() = (select auth_user_id from public.patients where patients.id = medications.patient_id) )
  with check ( auth.uid() = (select auth_user_id from public.patients where patients.id = medications.patient_id) );

-- RLS policies for allergies
create policy "allergies_owner_policy" on public.allergies
  for all
  using ( auth.uid() = (select auth_user_id from public.patients where patients.id = allergies.patient_id) )
  with check ( auth.uid() = (select auth_user_id from public.patients where patients.id = allergies.patient_id) );

-- RLS policies for vaccinations
create policy "vaccinations_owner_policy" on public.vaccinations
  for all
  using ( auth.uid() = (select auth_user_id from public.patients where patients.id = vaccinations.patient_id) )
  with check ( auth.uid() = (select auth_user_id from public.patients where patients.id = vaccinations.patient_id) );

-- Grant permissions
grant select on public.medications to authenticated;
grant select on public.allergies to authenticated;
grant select on public.vaccinations to authenticated;

-- Public profile RPC (schema: patients + users). See ../FIX_PUBLIC_PROFILE.sql for full file.
-- URL /patient/:uuid accepts patients.id OR patients.patient_id (auth user id).
create or replace function public.get_public_profile(p_public_uuid uuid)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'patient', jsonb_strip_nulls(jsonb_build_object(
        'id', p.id,
        'full_name', coalesce(u.name, ''),
        'dob', p.date_of_birth,
        'gender', p.gender,
        'blood_type', p.blood_type,
        'height_cm', p.height_cm,
        'weight_kg', p.weight_kg,
        'emergency_contact', p.emergency_contact
    )),
    'chronic_conditions', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', c.id, 'name', c.name, 'notes', c.notes,
        'created_at', to_char(c.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.chronic_conditions c
      where c.patient_id = p.id
    ),
    'surgeries', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', s.id, 'operation_name', s.operation_name,
        'operation_date', to_char(s.operation_date, 'YYYY-MM-DD'),
        'notes', s.notes,
        'created_at', to_char(s.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.surgeries s
      where s.patient_id = p.id
    ),
    'lab_tests', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', l.id, 'test_name', l.test_name, 'file_path', l.file_path,
        'test_date', to_char(l.test_date, 'YYYY-MM-DD'),
        'test_number', l.test_number, 'notes', l.notes,
        'created_at', to_char(l.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.lab_tests l
      where l.patient_id = p.id
    ),
    'medications', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', m.id, 'medication_name', m.medication_name,
        'dosage', m.dosage, 'frequency', m.frequency,
        'start_date', to_char(m.start_date, 'YYYY-MM-DD'),
        'end_date', to_char(m.end_date, 'YYYY-MM-DD'),
        'notes', m.notes,
        'created_at', to_char(m.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.medications m
      where m.patient_id = p.id
    ),
    'allergies', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', a.id, 'allergy_name', a.allergy_name,
        'severity', a.severity, 'notes', a.notes,
        'created_at', to_char(a.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.allergies a
      where a.patient_id = p.id
    ),
    'vaccinations', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', v.id, 'vaccine_name', v.vaccine_name,
        'dose_number', v.dose_number,
        'vaccination_date', to_char(v.vaccination_date, 'YYYY-MM-DD'),
        'notes', v.notes,
        'created_at', to_char(v.created_at, 'YYYY-MM-DD"T"HH24:MI:SSZ')
      )), '[]'::jsonb)
      from public.vaccinations v
      where v.patient_id = p.id
    )
  )
  from public.patients p
  left join public.users u on u.id = p.patient_id
  where p.id = p_public_uuid
     or p.patient_id = p_public_uuid
$$;

grant execute on function public.get_public_profile(uuid) to anon;
grant execute on function public.get_public_profile(uuid) to authenticated;


