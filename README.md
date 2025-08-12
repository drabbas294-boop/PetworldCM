# PetworldCM

Clinic Management System

## Deployment scripts

Two helper scripts are provided under the `scripts/` directory:

- `deploy.sh` – installs dependencies, builds the React client, runs database migrations, and restarts the Node server via PM2.
- `backup_db.sh` – creates a timestamped MySQL dump for the application database.

Adjust environment variables inside each script to match your environment before execution.
