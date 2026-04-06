# Fashigon backend API

## Setup

1. Copy `.env.example` to `.env` in this folder.
2. Set `MONGODB_URI` (MongoDB Atlas connection string) and `JWT_SECRET` (long random string).
3. Install and run:

```bash
npm install
npm start
```

The server reads `PORT` from the environment (default `3000`).

## Environment variables


| Variable      | Required | Description                           |
| ------------- | -------- | ------------------------------------- |
| `MONGODB_URI` | Yes      | Atlas connection string               |
| `JWT_SECRET`  | Yes      | Secret for signing and verifying JWTs |
| `PORT`        | No       | Listen port (default 3000)            |


