# Promato — Documentation Index

| File | Description |
|------|-------------|
| doc/analysis/roles.md | Roles definition and access matrix |
| doc/analysis/data-model.md | Full data model — entities, columns, relationships |
| doc/analysis/use-cases/UC-XX-*.md | One file per use case |
| doc/analysis/user-stories/US-XXX-*.md | One file per user story |
| doc/analysis/prompts/project instructions.md | AI prompt to regenerate the application from scratch |
| doc/analysis/prompts/UC-XX-*-prompt.md | AI prompt per use case |

## Architecture Summary

```
[Browser] → [Nginx :80] → [Angular SPA]
                       ↘ [Spring Boot :8080] → [PostgreSQL :5432]
```

### Dev environment
- Frontend: http://localhost:4300 (Angular dev server, hot reload)
- Backend:  http://localhost:8080 (Spring Boot DevTools, hot reload)
- DB:       localhost:5432

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
