# 📱 PhLog — Phone Account Tracker

A single-file web app for tracking phone-number accounts. For every phone number you add, it
**auto-creates a disposable email inbox via [mail.tm](https://mail.tm)** (address + password),
stores everything in **Supabase**, and shows a grid where you tick off what each number has
been used for.

## How to use

Just open `index.html` in a browser — no build step, no server needed. This repo is
**private**, so `config.js` (Supabase URL + publishable key) ships right alongside it and
everything works out of the box.

- **＋ Add Account** — enter a phone number (that's the account's name). A mail.tm email
  address is created automatically and saved next to it, along with a generated password
  (or type your own).
- **＋ Field** — add a custom column (e.g. `Google`, `Facebook`, `Verified`). Each account
  gets a checkbox under every column so you can track what the number has been used for.
  Click a column header to rename it, `✕` to delete it.
- **📬** — opens that account's live mail.tm inbox right in the page (great for grabbing
  verification codes/links during sign-up testing).
- **⧉** — copy email / password to clipboard. Click the dots to reveal a password.
- **Notes** — free-text per account, saved on change.

## mail.tm — do I need an API key?

**No.** mail.tm's API is free and open — no key, no signup. Accounts are created with a
plain `GET https://api.mail.tm/domains` → `POST /accounts` call, and inboxes are read with
a JWT from `POST /token`. The app does all of this for you. (Rate limit: 8 requests/sec.)

## Backend (Supabase)

Project: `phone-account-tracker` (`lpnvlofzqzfqeaumcxxz`, ap-southeast-2, free tier).
Schema lives in [`supabase/migrations/0001_init.sql`](supabase/migrations/0001_init.sql):

| table      | purpose                                               |
|------------|-------------------------------------------------------|
| `accounts` | one row per phone number + its mail.tm email/password |
| `fields`   | your custom column headers                            |
| `checks`   | one checkbox state per (account × field)              |

The app connects with the project's **publishable key** (designed for client-side use).
RLS is enabled with permissive policies for the anon role.

## ⚠️ Security notes

- **Keep this repo private.** Anyone with `config.js` (URL + publishable key) can read/write
  the tracker data, because RLS is intentionally open for the anon role. If you ever need
  real protection, add Supabase Auth and switch the RLS policies from `anon` to
  `authenticated`. (`config.example.js` shows the keyless template if you ever split the
  config back out.)
- mail.tm inboxes are **disposable/public-grade email** — never use them for anything you
  care about. Inboxes and messages are auto-deleted by mail.tm after a period of inactivity.
- Email passwords are stored in plain text on purpose (the app needs them to log into
  mail.tm to show the inbox). They are throwaway credentials, not real secrets.

## Next steps (planned)

- Sign-up automation against your own test sites: pick an account → auto-fill forms with
  its phone/email → poll the inbox for the verification code → tick the field checkbox.
