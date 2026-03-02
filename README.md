# Promato — Documentation Index

| File | Description |
|------|-------------|
| 01-functional-analysis.md | Application overview, roles, functional domains, NFRs |
| 02-use-cases.md | Detailed use case descriptions (UC-01 to UC-09) |
| 03-user-stories.md | User stories by domain (US-001 to US-052) |
| 04-data-model.md | Full data model — entities, columns, relationships |
| 05-regeneration-prompt.md | AI prompt to regenerate the application from scratch |

## Architecture Summary

```
[Browser] → [Nginx :80] → [Angular SPA]
                       ↘ [Spring Boot :8080] → [PostgreSQL :5432]
```

### Dev environment
- Frontend: http://localhost:4200 (Angular dev server, hot reload)
- Backend: http://localhost:8080 (Spring Boot DevTools, hot reload)
- DB: localhost:5432

### Production
- App: http://localhost:8090 (Nginx serves Angular + proxies /api/ to Spring Boot)

## Quick Start

```bash
# Development
make start        # Start without rebuild
make dev-build    # Rebuild after pom.xml/package.json changes
make logs-dev     # View logs

# Production
make prod         # Build and start
make db-shell     # PostgreSQL shell
```

## Default credentials
- Username: `admin`
- Password: `Admin1234!`
