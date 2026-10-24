# Music Library — Microservices Application

A Java/Spring-based music library project with separate services for user accounts and playlists, administration and song management, service discovery, and notifications.

## Services

- **UserService** — user registration/login and playlist APIs
- **AdminService** — administration and song management
- **NotificationService** — notifications
- **EurekaServer** — service discovery

## Technology

- Java and Spring Boot
- Spring Security and JWT
- MySQL
- Spring Cloud Netflix Eureka
- Maven
- Dockerfiles are provided for selected services

## Before running

**Never commit real passwords, JWT keys, mail credentials, or production environment files.** Configure the required environment variables in your IDE, shell, or deployment platform.

### Required environment variables

| Variable | Used by | Purpose |
| --- | --- | --- |
| `SPRING_DATASOURCE_PASSWORD` | UserService, AdminService, NotificationService | MySQL password |
| `JWT_SECRET` | UserService, AdminService | Shared signing key for JWTs; use a cryptographically random key of at least 32 bytes |
| `SPRING_DATASOURCE_URL` | All database-backed services (optional override) | JDBC connection URL |
| `SPRING_DATASOURCE_USERNAME` | Database-backed services if configured by the app | MySQL username |
| `MAIL_PASSWORD` | NotificationService, if email is configured | Mail account/app password |

Set the variables through your operating system or deployment provider's secret settings. Do not paste real values into this README or source files.

Example for macOS/Linux (replace the placeholders locally; do not commit them):

```bash
export SPRING_DATASOURCE_PASSWORD='your-local-mysql-password'
export JWT_SECRET='replace-with-a-random-secret-at-least-32-bytes-long'
```

For a random JWT key, you can generate one locally with:

```bash
openssl rand -base64 32
```

Set the **same JWT_SECRET** for UserService and AdminService if both services must validate tokens signed with the same key. Rotating the key invalidates existing tokens; configure the new value in every deployment before restarting the services.

### Database setup

Create the databases expected by the service configuration, or set `SPRING_DATASOURCE_URL` to the database URL for each service. Check `MusicLibrary.sql` and the individual `application.properties` files before importing schema/data: the SQL script and service defaults may use different database names.

### Running and testing

1. Install the JDK version required by the service's Maven/Docker configuration and MySQL.
2. Configure the required environment variables.
3. Import the project into your IDE as Maven projects, or build each service from its directory with `./mvnw test` if a Maven wrapper is present, otherwise `mvn test`.
4. Start Eureka and the dependent services using their configured ports and service-discovery settings.
5. Verify authentication, role restrictions, playlist ownership, and upload/notification access before exposing the application publicly.

Do not deploy this project publicly until the security review is complete. In particular, review admin registration, password hashing, endpoint authorization, upload validation, and notification endpoints.

## Repository hygiene

IDE workspace metadata, build outputs, local environment files, and logs are excluded by `.gitignore`. This does not remove files that were already committed; previously tracked workspace files must be untracked separately.
