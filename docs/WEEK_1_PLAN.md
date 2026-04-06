# Week 1 plan — Phase 0 (your time: ~7.5 h/week)

**Your cadence:** weekend **2 h** + daily **30 min** × 7 = **2 + 3.5 = 5.5 h** (weekdays only 5 × 30 min = **2.5 h** + weekend **2 h** = **4.5 h** if you skip weekend days).  
**Planning number:** **~5–8 h/week** of your time for reviews, accounts, and device testing; implementation is automated in-repo where possible.

## Day-by-day (suggested)


| Day                | Your tasks (~30–60 min)                                                                                                                                                                                      | Outcome                                         |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------- |
| **Day 1**          | Create `backend_api/.env` from `.env.example`. Paste Atlas `MONGODB_URI`. Set a long random `JWT_SECRET` (save in a password manager).                                                                       | API starts locally with `npm start`.            |
| **Day 2**          | On a physical phone: PC firewall allows port **3000**; repo default LAN IP is `**192.168.68.54`** (buyer + vendor apps). Change again if your PC IP changes, or use `--dart-define`.                         | Buyer app loads home / sign-in against your PC. |
| **Day 3**          | In **Railway**: new service from your **GitHub** repo, set env vars `MONGODB_URI`, `JWT_SECRET` (Railway sets `PORT` automatically).                                                                         | Open `https://YOUR-HOST/hello` → `Hello World!` |
| **Day 4**          | In Atlas → **Network Access**: ensure **cloud** can reach DB (`0.0.0.0/0` for staging is common; tighten later). **Rotate DB user password** if it ever lived in git history; update `.env` + host env vars. | Staging API connects to MongoDB from the cloud. |
| **Day 5**          | Run buyer app: `flutter run --dart-define=API_BASE_URL=https://your-staging-api` (replace URL). Repeat sign-in + browse products.                                                                            | End-to-end against staging.                     |
| **Weekend (+2 h)** | Optional: deploy follow-up; note failures. Optional: `app_web` with same `dart-define` against staging.                                                                                                      | Confidence checklist below all checked.         |


## MongoDB Atlas — step by step (what to do now)

Think of Atlas as **the database in the cloud**. Your Node API does not host MongoDB; it **connects** to Atlas using a **connection string** (a long URL with username and password). You are **not** creating a new database product—you are wiring **two places** (your PC + Railway) to the **same** Atlas cluster you already used in the course.

### Step 1 — Open MongoDB Atlas

1. Go to [https://cloud.mongodb.com](https://cloud.mongodb.com) and sign in (same account you used for the Udemy project).
2. Pick your **Project** (e.g. the one that has **Cluster0** or similar).

### Step 2 — Let the internet reach your cluster (required for Railway)

Railway’s servers are **not** in your home. Atlas blocks unknown IPs by default.

1. In Atlas, open **Network Access** (left sidebar).
2. Click **Add IP Address**.
3. For staging, choose **Allow access from anywhere** (this adds `**0.0.0.0/0`**). Confirm.
4. Wait until the status shows **Active** (usually under a minute).

*(Later, for production, you can restrict this; for Week 1 staging this is normal.)*

### Step 3 — Database user and password

1. Open **Database Access** (left sidebar).
2. You should see a **database user** (e.g. the one from the course).
  - If you **ever** committed the old connection string to GitHub, **rotate the password**: edit the user → **Edit Password** → save, and use the new password in the URI below.
3. Note the **username** exactly as shown.

### Step 4 — Copy the connection string

1. Open **Database** (or **Clusters**) → your cluster → **Connect**.
2. Choose **Drivers** (or “Connect your application”).
3. Copy the **connection string**. It looks like:
  `mongodb+srv://USERNAME:PASSWORD@cluster0.xxxxx.mongodb.net/...`
4. Replace `<password>` with your **real** database user password (if the template still has a placeholder).
5. Keep `**mongodb+srv://`** and the rest as Atlas gives you (options like `retryWrites=true` are fine).

That full string is your `**MONGODB_URI**`.

### Step 5 — Use it in two places (same string)


| Where                   | What to do                                                                                                                                               |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Your PC (local API)** | Create `backend_api/.env`, set `MONGODB_URI=paste-the-full-string-here` (no quotes needed unless the password has special characters—if issues, ask me). |
| **Railway**             | Project → your **backend service** → **Variables** → add `MONGODB_URI` with the **same** value.                                                          |


Also set `**JWT_SECRET`** in both places to the **same** long random string (e.g. 32+ characters). It is **not** your Mongo password; it is only for signing login tokens.

### Step 6 — Quick check

- **Local:** `cd backend_api` → `npm start` → console should show **Mongodb connected**.
- **Railway:** deploy → check logs for the same; hit `**/hello`** on your Railway URL.

If Atlas says **connection refused** or **timeout**, usually **Network Access** is wrong or the password in the URI does not match **Database Access**.

---

## MongoDB & secrets (summary)


| Piece               | Approach                                                                                                                    |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **MongoDB**         | Stays on **MongoDB Atlas**. Same cluster; paste URI into `backend_api/.env` and Railway **Variables**.                      |
| **JWT**             | `JWT_SECRET` in `.env` and Railway. Changing it logs everyone out until they sign in again.                                 |
| **Flutter API URL** | Staging: `--dart-define=API_BASE_URL=...`. Local: default `http://192.168.68.54:3000` (buyer/vendor); web uses `localhost`. |
| **Cloudinary**      | Still in Dart this week; optional hardening later.                                                                          |


## Confidence checklist (definition of “Week 1 done”)

- `cd backend_api && npm start` works with **only** `.env` (no secrets in source).
- Staging HTTPS URL set on host; Atlas allows connections from the internet (or from that provider).
- Buyer app on a **real phone** talks to staging: **sign-in** + **home data** (e.g. banners or products).
- You have **rotated** the Atlas DB password if the old URI was ever committed to git.

## Commands reference

**Backend (local)**

```powershell
cd D:\Startup\dev\backend_api
copy .env.example .env
# Edit .env: MONGODB_URI, JWT_SECRET
npm install
npm start
```

**Buyer app → staging API**

```powershell
cd D:\Startup\dev\app\fashigon_mobile_app
flutter run --dart-define=API_BASE_URL=https://YOUR-STAGING-API.example.com
```

**Admin web → staging**

```powershell
cd D:\Startup\dev\app_web
flutter run -d chrome --dart-define=API_BASE_URL=https://YOUR-STAGING-API.example.com
```

---

*Engineering notes for this week are in git history / `docs/FASHIGON.md`.*