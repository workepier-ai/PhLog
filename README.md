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
- **＋ Field / column builder** — add a custom column (usually a site, e.g. `Twitter`).
  Click any column header (`⚙`) to open the builder: rename it, delete it, and choose which
  extras appear in that column's cells — **Note**, **Email used on this site**, and
  **Password used on this site**.
- **Reorder columns** — drag any column header (grab the `⠿` handle) left/right to change
  its position; the new order is saved.
- **Site links** — in the column builder, set a **Site link** URL for a column. The header
  then shows a `🔗` and **clicking it opens the site in a new tab** (the `⚙` still opens the
  builder). Each cell in that column also gets an **↗ button** that, in one click, **copies
  that account's email to the clipboard and opens the site in a new tab** — handy for pasting
  the email straight into a signup form.
- **Cell dropdown (`▾`)** — under each checkbox is a dropdown holding that account's details
  for that specific site:
  - a free-text **note**,
  - the **email used** (⤵ quick-fills the account's mail.tm address),
  - the **password used** — this **auto-fills to the account's main password** (the Password
    column value) the first time you open the cell, so every phone/email listed already has a
    password. ⤵ resets it to the account password, ⚄ generates a fresh random one just for
    that site, ⧉ copies.

  The `▾` turns green when a cell has anything stored. Everything saves automatically.
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
