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

## Deploy to Railway

Telecare has three deployable services: the API, patient frontend, and admin frontend. Deploy them as separate Railway services from this repository. Railway does not use the local `docker-compose.yml`; use a MongoDB service from Railway or an external MongoDB provider such as MongoDB Atlas.

### 1. Create a MongoDB database

Create a MongoDB database and copy its connection URI. The backend adds `/Telecare` to `MONGODB_URI`, so set the variable to the cluster URI without a database name or trailing path, for example:

```text
mongodb+srv://<username>:<password>@<cluster-host>
```

URL-encode any special characters in the username or password. Keep the URI private.

### 2. Deploy the API

1. In Railway, create a project and add a service from this GitHub repository.
2. In the service's **Settings**, set the **Root Directory** to `/` and the **Dockerfile Path** to `/docker/backend.Dockerfile`.
3. Add these service variables:

   | Variable | Value |
   | --- | --- |
   | `MONGODB_URI` | Your MongoDB cluster URI from step 1 |
   | `JWT_SECRET` | A long, random secret |
   | `ADMIN_EMAIL` | The admin sign-in email you want |
   | `ADMIN_PASSWORD` | A strong admin password |
   | `CLOUDINARY_NAME` | Your Cloudinary cloud name |
   | `CLOUDINARY_API_KEY` | Your Cloudinary API key |
   | `CLOUDINARY_API_SECRET` | Your Cloudinary API secret |

   The three Cloudinary variables are needed for image uploads. Do not commit credentials or put them in frontend variables.
4. Deploy the service and generate a public domain from **Settings → Networking**. Open the domain root; it should respond with `API Working`. Copy the public URL (for example, `https://your-api.up.railway.app`) for the frontend services. Do not add a trailing slash or `/api`.

The backend listens on Railway's injected `PORT` value, so do not hard-code a port in Railway variables.

### 3. Deploy the patient frontend

1. Add another service from the same GitHub repository.
2. Set its **Root Directory** to `/` and **Dockerfile Path** to `/docker/frontend.Dockerfile`.
3. Set the `VITE_BACKEND_URL` service variable to the public API URL from step 2.
4. Deploy, then generate a public domain under **Settings → Networking**.

`VITE_BACKEND_URL` is used when Vite builds the app. If you change it after a deployment, redeploy the service so the new value is included in the frontend.

### 4. Deploy the admin frontend

1. Add a third service from the same GitHub repository.
2. Set its **Root Directory** to `/` and **Dockerfile Path** to `/docker/admin.Dockerfile`.
3. Set `VITE_BACKEND_URL` to the same public API URL.
4. Deploy, then generate a public domain under **Settings → Networking**.

Open the patient frontend's `/Telecare/` path and the admin frontend's root URL. Sign in to the admin app with `ADMIN_EMAIL` and `ADMIN_PASSWORD`.

### Troubleshooting

- **API is unavailable:** Check the API service deployment logs and verify `MONGODB_URI` and the other backend variables are set.
- **Frontend cannot reach the API:** Check that `VITE_BACKEND_URL` is the API's public URL, without a trailing slash, and redeploy the frontend after changing it.
- **Image uploads fail:** Verify all three Cloudinary variables in the API service.
- **MongoDB connection fails:** Confirm the database is running and accepts connections from Railway. For MongoDB Atlas, configure its network access to allow the Railway service to connect; use a strong database user and password.

## Run without Docker

Install Node.js, then install dependencies and start each app in its directory:

- Root: `npm install`, then `npm run dev`
- Backend: `npm install`, configure `backend/.env`, then `npm run dev`
- Admin: `npm install`, then `npm run dev`

Set `VITE_BACKEND_URL` in the root and `admin/.env` files for the backend address.
