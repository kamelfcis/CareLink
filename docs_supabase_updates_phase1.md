# Supabase Updates (Phase 1)

Migration file: `supabase/migrations/20260429164141_core_healthcare_updates.sql`

## What this migration adds

1. `doctor_reviews` + `doctor_avg_rating` view (doctor rating system).
2. `diseases` table with `disease_type` enum (`chronic` / `normal`).
3. `doctor_patients` lifecycle columns: `start_date`, optional `end_date`, status, `last_message_at`.
4. Chat history tables: `doctor_patient_chats`, `chat_messages`.
5. Prescription image table: `prescriptions` + private storage bucket `prescriptions`.
6. Emergency CRUD foundation table: `patient_emergencies`.
7. Surgery review table: `surgery_reviews` (`surgery_type` + `surgery_count`).
8. Doctor profile location fields (`governorate`, `center`, `latitude`, `longitude`) + reference tables (`governorates`, `centers`) and a distance SQL function `calculate_center_distance_km`.
9. RPC helper `connect_doctor_patient` to remove duplicate-connection errors with idempotent insert/update behavior.

## App code updated in this batch

- Doctor signup now captures governorate + center and stores them in `doctors`.
- Patient-doctor connect logic now uses `connect_doctor_patient` RPC and has fallback insert.
- Patient profile emergency section has a direct call button (`tel:`) for emergency trigger.

## Next recommended batches

- Wire doctor search UI to `SearchFilterService` fields (location + ordering by rating + name).
- Add surgery review UI using `surgery_reviews`.
- Migrate existing `chronic_conditions` into `diseases` and adapt screens.
- Move emergency contact read/write from `patients.emergency_contact` JSON to `patient_emergencies` table.
- Add RLS policies for new tables and storage buckets.
