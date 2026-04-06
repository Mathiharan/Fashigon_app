# MATHI - Week 1 Status

## Day 1 - Completed

Date: 2026-04-06
Owner: MATHI

### Completed
- Backend local environment setup finalized using `backend_api/.env` (local only, not committed).
- Backend runs via `npm start`.
- MongoDB Atlas connectivity verified (`Mongodb connected`).
- API secret handling already moved to environment variables (`MONGODB_URI`, `JWT_SECRET`).
- Local API base URL defaults aligned for apps to `192.168.68.54` (buyer + vendor).

### Notes for Sriram
- Do NOT commit `backend_api/.env`.
- Create local env from template:
  - `cd backend_api`
  - `copy .env.example .env`
  - Fill `MONGODB_URI` and `JWT_SECRET`
  - `npm install && npm start`
- For staging on Railway, set the same env vars in Railway Variables.

### Next
- Day 2: Real-device buyer app test against local API (phone + LAN).
