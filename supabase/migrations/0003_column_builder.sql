-- Column builder: per-column config + per-cell note/email/password.
-- Applied 2026-07-20.

-- Each check cell can carry a note plus the email/password actually used on that site.
alter table public.checks
  add column note text default '',
  add column cred_email text default '',
  add column cred_password text default '';

-- Each column decides which of those extras appear in its cells' dropdown.
alter table public.fields
  add column config jsonb not null default '{"note": true, "email": true, "password": true}'::jsonb;
