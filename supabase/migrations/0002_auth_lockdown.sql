-- Lock the tracker down to the owner's Supabase Auth user.
-- Applied 2026-07-20. Replaces the permissive anon policies from 0001.
--
-- The owner user (workepier@gmail.com) was created via the Auth signup API and
-- email-confirmed directly. If you ever recreate the user, update the UUID below.

drop policy "anon full access accounts" on public.accounts;
drop policy "anon full access fields" on public.fields;
drop policy "anon full access checks" on public.checks;

create policy "owner full access accounts" on public.accounts
  for all to authenticated
  using ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid)
  with check ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid);
create policy "owner full access fields" on public.fields
  for all to authenticated
  using ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid)
  with check ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid);
create policy "owner full access checks" on public.checks
  for all to authenticated
  using ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid)
  with check ((select auth.uid()) = 'e929fc64-3d33-4687-b14c-98dd6ad66fa2'::uuid);
