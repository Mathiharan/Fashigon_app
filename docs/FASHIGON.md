# Fashigon — product vision & engineering north star

## What we are building

**Fashigon** is a hyperlocal marketplace for a city: **local retailers** (the shops hurt by malls and large platforms) get discovery and orders, and customers get **fast delivery** (30–60 minutes), similar in *expectation* to quick-commerce apps—but powered by **real neighborhood stores**, starting with **Vellore**.

**Positioning (one line):**  
*Flipkart-scale selection is not the goal on day one; “nearby, today, in an hour” is.*

## Why this can work

- **Demand:** People already pay for speed and convenience; combining that with “support local” is emotionally and economically compelling when execution is honest.
- **Supply:** Small retailers need channels beyond foot traffic; a single city focus lets you onboard and debug operations without pretending to be national.
- **Wedge:** Win on **latency + locality** for categories where immediacy matters (daily needs, last-minute, trust in local quality)—not on beating Flipkart on price or infinite SKU on v1.

## Hard truths (so we plan around them)

- **Logistics:** The app is only half the product; *who picks, packs, and rides* in Vellore must be designed early (in-house riders, store self-delivery, or a partner). Without this, “30–60 min” stays a slogan.
- **Catalog & quality:** Local inventory changes often; photos, stock, and pricing need a simple vendor workflow (your vendor app is the right direction).
- **Trust & habit:** First orders matter more than feature count—reliable ETAs, clear shop names, and refunds when something fails.

## Current codebase (baseline)

- **Backend:** Node/Express + MongoDB Atlas (`backend_api/`).
- **Clients:** Buyer Flutter app, Vendor Flutter app, Admin Flutter Web (see repo layout).
- **Gaps to close before “real city pilot”:** production-grade config (secrets, env-based API URLs), auth on sensitive admin/vendor flows, deployment story, and operational basics (delivery model).

## Deployment — you are not blocked by “US Heroku”

Heroku was one option from a course; it is **not** required.

Reasonable alternatives (pick one with your constraints: cost, India billing, minimal ops):

| Option | Notes |
|--------|--------|
| **Render** | Free/low tiers, straightforward Node deploy, env vars for secrets. |
| **Railway** | Simple DX, usage-based billing; good for APIs. |
| **Fly.io** | Global regions; slightly more setup. |
| **DigitalOcean App Platform / Droplet** | Predictable pricing; Droplet = you manage PM2/nginx. |
| **AWS/GCP** | More control, more setup (good once you have traction). |

**Rule:** MongoDB Atlas stays the DB; the API only needs a public HTTPS URL and environment variables—no US-specific account type is required for that pattern.

## Week 1 execution plan

See **[WEEK_1_PLAN.md](./WEEK_1_PLAN.md)** for day-by-day tasks, MongoDB/Atlas notes, and the “done” checklist (aligned to ~5–8 h/week founder time).

## Phased roadmap (realistic for a busy founder + AI-assisted dev)

### Phase 0 — “Safe to show” (1–2 focused weeks, evenings)

- Move secrets out of code: `MONGODB_URI`, `JWT_SECRET`, Cloudinary keys → environment only.
- Single **staging** API URL; Flutter apps read base URL from build flavor or const file per environment.
- Deploy API to one non-Heroku host; verify buyer login + one product flow end-to-end on a real phone.

### Phase 1 — “Vellore alpha”

- Vendor onboarding checklist (1–3 real shops): categories, images, hours, delivery radius.
- Order flow: placed → acknowledged → out for delivery → delivered (even if status updates are manual at first).
- Admin: protect or temporarily restrict dashboard (auth or IP allowlist).

### Phase 2 — “30–60 min promise”

- Define **delivery SLA** per zone; show honest ETAs in app.
- Rider assignment or store fulfillment rules; basic support contact.

### Phase 3 — Scale within the city

- Search, reliability, analytics, payouts, disputes—only after repeat orders exist.

## How we work (CEO + senior dev + AI)

- **You (CEO):** Vision, shop relationships, Vellore ops, legal/compliance when needed, prioritization (“this week we ship X”).
- **Engineering (this repo):** Architecture, security hygiene, deployment, tickets broken into small PR-sized steps.
- **Cadence:** Short weekly goal (one shippable increment) beats heroic multi-month bursts.

## Reference

- Detailed technical map: `Fashigon_MD1.txt` (external copy) or historical Udemy-derived notes—treat this file as the **product + delivery** companion to those docs.

---

*Last updated: 2026-04-04*
