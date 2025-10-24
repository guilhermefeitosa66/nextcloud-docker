# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nextcloud Docker deployment configured with MariaDB and Redis. The setup uses Docker Compose to orchestrate three services in a containerized environment.

## Architecture

### Container Services

The application uses a three-tier architecture:

1. **app** (nextcloud:latest): The Nextcloud application server
   - Exposed on port 8080 → 80
   - Mounts local directory to `/var/www/html` for persistent Nextcloud data
   - Connected to both MariaDB and Redis

2. **db** (mariadb:10.11): Database server
   - Configured with transaction isolation and binary logging for replication support
   - Uses named volume `db_data` for persistence
   - Internal network access only

3. **redis** (redis:alpine): In-memory cache
   - Used for file locking and session management
   - Internal network access only

### Network

All services communicate via the `nextcloud-network` bridge network. Only the app container is exposed to the host system.

### Data Persistence

- **Nextcloud data**: Bound mount to local filesystem at `/home/guilherme/Insync/guilhermefeitosa66@gmail.com/OneDrive/nextcloud`
- **Database data**: Docker named volume `db_data`

## Common Commands

### Starting and Stopping

```bash
# Start all services
docker-compose up -d

# Stop services (keeps data)
docker-compose down

# Stop and remove all data (DESTRUCTIVE)
docker-compose down -v

# Restart services
docker-compose restart
```

### Monitoring and Debugging

```bash
# View logs (all services)
docker-compose logs -f

# View logs for specific service
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f redis

# Execute command in app container
docker-compose exec app <command>

# Fix permissions if needed
docker-compose exec app chown -R www-data:www-data /var/www/html
```

### Updating

```bash
# Pull latest images and restart
docker-compose pull
docker-compose up -d
```

### Backup

```bash
# Backup Nextcloud data
docker run --rm -v nextcloud_nextcloud_data:/data -v $(pwd):/backup ubuntu tar czf /backup/nextcloud-backup.tar.gz /data

# Backup database
docker run --rm -v nextcloud_db_data:/data -v $(pwd):/backup ubuntu tar czf /backup/db-backup.tar.gz /data
```

## Configuration

### Environment Variables

Configuration is managed through `.env` file:

- `MYSQL_ROOT_PASSWORD`: MariaDB root password
- `MYSQL_PASSWORD`: Nextcloud database user password
- `NEXTCLOUD_ADMIN_USER`: Initial admin username
- `NEXTCLOUD_ADMIN_PASSWORD`: Initial admin password
- `NEXTCLOUD_TRUSTED_DOMAINS`: Space-separated list of trusted domains

### Accessing the Application

After starting services, access Nextcloud at: `http://localhost:8080`

Login with credentials defined in `.env` file.

## Important Notes

- The Nextcloud data directory is mounted to a local Insync/OneDrive synchronized folder, which means Nextcloud files are automatically backed up to OneDrive
- If port 8080 is in use, edit the port mapping in `docker-compose.yml` (e.g., `"8081:80"`)
- Never commit `.env` file with real credentials to version control
- Database uses `READ-COMMITTED` isolation level and binary logging configured for potential replication
