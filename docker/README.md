# Docker Setup Guide

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- Git

## Quick Start (Development)

### 1. Clone and Setup

```bash
git clone https://github.com/jason-kazee-tm/data-screener.git
cd data-screener
cp .env.docker .env
```

### 2. Build and Start Services

```bash
make build
make up
```

### 3. Initialize Database

```bash
make migrate
```

### 4. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **API Documentation**: http://localhost:5000/api/health

### 5. Check Logs

```bash
make logs
```

## Available Commands

See `make help` for all available commands.

### Common Commands

```bash
# Start services
make up

# Stop services
make down

# View logs
make logs
make logs-backend
make logs-frontend
make logs-db

# Database operations
make migrate          # Create tables
make seed             # Seed sample data

# Testing
make test             # Run all tests
make lint             # Run linters
make format           # Format code

# Development
make shell-backend    # Access backend shell
make shell-db         # Access database shell

# Clean up
make clean            # Remove all containers and volumes
```

## Production Deployment

### 1. Prepare Production Environment

```bash
cp .env.docker .env.production
# Edit .env.production with production values
```

### 2. Generate SSL Certificates

```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem
```

### 3. Start Production Stack

```bash
docker-compose -f docker-compose.prod.yml --env-file .env.production up -d
```

### 4. Verify Services

```bash
docker-compose -f docker-compose.prod.yml ps
```

## Service Configuration

### PostgreSQL
- **Port**: 5432
- **User**: data_screener
- **Database**: data_screener
- **Volume**: postgres_data (persistent)

### Backend API
- **Port**: 5000
- **Framework**: Flask
- **Language**: Python 3.11
- **Health Check**: /api/health

### Frontend
- **Port**: 3000
- **Framework**: React 18
- **Language**: TypeScript
- **Build**: Optimized production build

### Nginx (Production)
- **HTTP Port**: 80
- **HTTPS Port**: 443
- **Reverse Proxy**: Routes to backend and frontend
- **Features**: SSL, compression, caching, rate limiting

## Troubleshooting

### Database Connection Issues

```bash
# Check database logs
make logs-db

# Test connection
make shell-db
```

### Backend Errors

```bash
# View backend logs
make logs-backend

# Access backend shell
make shell-backend

# Check health
curl http://localhost:5000/api/health
```

### Frontend Issues

```bash
# View frontend logs
make logs-frontend

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

### Reset Everything

```bash
# Stop all services
make down

# Remove all volumes
docker volume prune

# Rebuild and start
make build
make up
```

## Volume Management

### Persistent Volumes

- **postgres_data**: PostgreSQL database files
- **uploads**: Invoice upload files

### View Volumes

```bash
docker volume ls
docker volume inspect data-screener_postgres_data
```

### Backup Database

```bash
docker-compose exec postgres pg_dump -U data_screener data_screener > backup.sql
```

### Restore Database

```bash
docker-compose exec -T postgres psql -U data_screener data_screener < backup.sql
```

## Performance Tuning

### Resource Limits

Edit `docker-compose.yml` to add resource limits:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### Optimize PostgreSQL

```sql
-- Connect to database
make shell-db

-- Check performance
SELECT name, setting FROM pg_settings WHERE name LIKE '%work_mem%';
SELECT name, setting FROM pg_settings WHERE name LIKE '%shared_buffers%';
```

## Security

### Production Checklist

- [ ] Change PostgreSQL password in .env
- [ ] Update API secret key
- [ ] Generate SSL certificates
- [ ] Configure firewall rules
- [ ] Enable container restart policies
- [ ] Set up log rotation
- [ ] Configure backups
- [ ] Review Nginx security headers
- [ ] Enable authentication on API
- [ ] Set rate limiting

## Monitoring

### Docker Stats

```bash
docker stats
```

### Container Logs

```bash
docker-compose logs --tail=100 -f backend
```

### Health Checks

```bash
curl -s http://localhost:5000/api/health | jq
curl -s http://localhost:3000
```

## Further Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Flask Deployment](https://flask.palletsprojects.com/deployment/)
- [React Deployment](https://create-react-app.dev/deployment/)