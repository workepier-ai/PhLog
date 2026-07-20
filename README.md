# 📱 PhLog — Phone Account Tracker

A single-file web app for tracking phone-number accounts. For every phone number you add, it
**auto-creates a disposable email inbox via [mail.tm](https://mail.tm)** (address + password),
stores everything in **Supabase**, and shows a grid where you tick off what each number has
been used for.

## How to use

Open `index.html` in a browser (or visit the GitHub Pages URL) and **sign in** with your
Supabase Auth login (`workepier@gmail.com` + your password). No build step, no server.
The session is remembered in the browser; the `⎋` button signs out.

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

The app connects with the project's **publishable key** (designed for client-side use) and
signs in through **Supabase Auth**. RLS policies only allow the owner's user account
(pinned by UUID in `0002_auth_lockdown.sql`) — the publishable key alone can read/write
nothing, so the key being visible in `config.js` is safe.

## Hosting on GitHub Pages

Safe to do now, because all data access requires your login:

1. Repo **Settings → General → Danger Zone → Change visibility → Public**
   (free GitHub Pages needs a public repo).
2. **Settings → Pages → Deploy from a branch → `main` / `(root)` → Save.**
3. Your tracker will be at `https://workepier-ai.github.io/PhLog/` after a minute or two.

To change your password: Supabase dashboard → Authentication → Users →
`workepier@gmail.com` → ⋯ → Update password (or send a recovery email).

## ⚠️ Security notes

- Data is protected by Supabase Auth + RLS pinned to your user UUID. Even if someone signs
  up their own user against the project, the policies still deny them. To grant another
  person access, add their UUID to the policies in a new migration.
- mail.tm inboxes are **disposable/public-grade email** — never use them for anything you
  care about. Inboxes and messages are auto-deleted by mail.tm after a period of inactivity.
- Email passwords are stored in plain text on purpose (the app needs them to log into
  mail.tm to show the inbox). They are throwaway credentials, not real secrets.

## Next steps (planned)

- Sign-up automation against your own test sites: pick an account → auto-fill forms with
  its phone/email → poll the inbox for the verification code → tick the field checkbox.
