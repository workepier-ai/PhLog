# 💰 PayCalc — shift pay calculator

A **completely separate, single-file app** that lives inside this repo at `pay/index.html`.
It shares nothing with the phone tracker — no Supabase, no login, no network calls. Open it
and it works; everything is saved in the browser (`localStorage`).

Open `pay/index.html`, or on GitHub Pages: `https://workepier-ai.github.io/PhLog/pay/`

## Entering shifts

One box per day of the pay period. Type it the way you say it:

| You type | It reads |
|---|---|
| `9-5` | 9:00pm → 5:00am (8h) |
| `6pm-2am` | 6:00pm → 2:00am |
| `1800-0230` | 6:00pm → 2:30am |
| `9am-5` | 9:00am → 5:00pm |
| `9:30pm - 5:15` | 9:30pm → 5:15am |
| `10am-2pm, 8pm-1am` | two shifts that day |

- **PM is assumed** for plain numbers, because you work nights (toggle in ⚙ Rates).
- The end time **rolls into the next morning automatically** — you never type a date.
- The shift is filed under the day it **starts**, even when it finishes at 5am the next day.
- `brk` = unpaid break in minutes, taken off pro-rata. `PH` marks a public holiday.
- Separators `-`, `–`, `to`, `till`, `until` all work.

## How the pay is calculated

Base rate × the multiplier for the day the shift started, plus per-hour shift penalties:

| | Rate | Default |
|---|---|---|
| Base | | **$32.28** |
| Mon–Fri | 125% | $40.35 |
| Saturday | 150% | $48.42 |
| Sunday | 175% | $56.49 |
| Public holiday | 225% | $72.63 |
| Afternoon penalty | 6:00pm – midnight | **+$3.04/h** |
| Evening/night penalty | midnight – 6:00am | **+$4.55/h** |

Weekend and public-holiday hours get the higher multiplier **instead of** the shift
penalties (that's how the real payslip works — the penalty hours there, 16.00 + 14.04,
add up to exactly the 30.04 weekday hours). There's a switch in ⚙ Rates if that ever changes.

Every rate, penalty, time window and rule is editable in **⚙ Rates**, and the panel shows
the resulting hourly rates so you can eyeball them against a payslip.

### Tax and super

- **Tax** — PAYG withholding estimate, ATO Schedule 1 **scale 2** (tax-free threshold
  claimed, no HELP/HECS), FY2026-27 rates. Calibrated against the 26 Jul 2026 payslip:
  $2,709.46 gross fortnightly → **$504** withheld, exactly. You can switch to a flat %,
  a fixed amount, or none.
- **Super** — 12% of gross ($2,709.46 → $325.14, matching the payslip).

### Verified against the payslip

Feeding a fortnight of night shifts shaped like the real roster into the calculator
reproduces the payslip line for line:

| Line | PayCalc | Payslip |
|---|---|---|
| Ordinary Hours @ 125% | 30.03h × 40.35 = 1,211.85 | 30.04h × 40.35 = 1,212.1x |
| Ordinary Hours @ 150% | 12.22h × 48.42 = 591.53 | 12.22h × 48.42 = 591.6x |
| Ordinary Hours @ 175% | 14.03h × 56.49 = 792.74 | 14.04h × 56.49 = 793.1x |
| Evening Shift Penalty | 14.03h × 4.55 = 63.85 | 14.04h × 4.55 = 63.8x |
| Afternoon Shift Penalty | 16.00h × 3.04 = 48.64 | 16.00h × 3.04 = 48.6x |
| Income tax | 504.00 | 504.00 |
| Superannuation | 325.03 | 325.14 |

(The few cents of difference are only because the test roster used whole minutes rather
than the real clock-in times.)

## The rest of the screen

- **‹ / ›** move between pay periods; **Today** jumps back to the current one. The cycle
  length (weekly / fortnightly / 4-weekly) and the Monday a period starts on are in ⚙ Rates.
- Each day shows the parsed times, hours, which rate band they fell in, penalty hours and
  the day's pay. Each week shows its own subtotal.
- The right-hand card is a **payslip-shaped summary** for the whole period —
  gross, tax, net, super — with **⧉ Copy summary** to paste it somewhere.
- **⤓ Export / ⤒ Import** in ⚙ Rates back everything up to a JSON file. Data lives in this
  browser only, so export before clearing site data.
