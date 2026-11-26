# Telecare

## Run locally with Docker

Requirements: Docker Desktop (or Docker Engine with the Compose plugin).

1. Copy the backend environment template and edit its JWT secret and admin credentials. Cloudinary credentials are optional, but image uploads require them.

   ```powershell
   if (-not (Test-Path backend\.env)) { Copy-Item backend\.env.example backend\.env }
   notepad backend\.env
   ```

2. From the project root, start the services:

   ```powershell
   docker compose up --build
   ```

3. Open the patient app at [http://localhost:8080/Telecare/](http://localhost:8080/Telecare/) and the admin app at [http://localhost:8081/](http://localhost:8081/). The API is at `http://localhost:4000`.

Compose starts MongoDB locally and persists its data in the `telecare-mongo-data` volume. The backend connects to that container automatically; the existing `MONGODB_URI` in `backend/.env` is overridden for the Compose network. Frontend API URLs are baked into the image at build time and default to `http://localhost:4000`; set `VITE_BACKEND_URL` in the root `.env` before building to change it.

Stop the services with `docker compose down`. To rebuild after changing frontend environment settings, run `docker compose build --no-cache frontend admin` and then `docker compose up`.

## Run without Docker

Install Node.js, then install dependencies and start each app in its directory:

- Root: `npm install`, then `npm run dev`
- Backend: `npm install`, configure `backend/.env`, then `npm run dev`
- Admin: `npm install`, then `npm run dev`

Set `VITE_BACKEND_URL` in the root and `admin/.env` files for the backend address.
