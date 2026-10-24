# Music Library — Microservices Application

A Java/Spring Boot music library with separate user, admin/song-management, notification, and Eureka discovery services.

## Services and ports

| Service | Default port | Purpose |
| --- | ---: | --- |
| UserService | 8080 | Registration, login, account and playlist APIs |
| AdminService | 8082 | Admin login and song management |
| NotificationService | 8085 | Internal notifications and optional email |
| EurekaServer | 8761 | Service discovery |

The services use Java 21 except NotificationService, which currently targets Java 17. Each service has its own Maven project.

## Requirements

- JDK versions listed above
- Maven
- MySQL 8+
- Git

## Configure local environment

1. Copy .env.example to .env.
2. Replace all placeholder passwords and keys with local values. Do not commit .env.
3. Generate a JWT signing key and an internal notification key locally:

        openssl rand -base64 32
        openssl rand -hex 32

   Use the first value for JWT_SECRET and the second for NOTIFICATION_API_KEY. Set the same JWT_SECRET in UserService and AdminService, and the same NOTIFICATION_API_KEY in AdminService and NotificationService.
4. Load the values into your current terminal before starting the services:

        set -a
        source .env
        set +a

   Spring Boot does not automatically load a plain .env file. In an IDE, configure the variables in the run configuration instead.

The default database URLs point to one local database, Music_Library, to match MusicLibrary.sql. Separate database URLs can be configured through the service-specific *_DATASOURCE_URL variables. Database credentials are required and must not be stored in source code.

## Database setup

Run MusicLibrary.sql against MySQL. It creates the database and the tables mapped by the JPA entities. Existing installations should back up their data before applying schema changes. Hibernate is configured with ddl-auto=update for development; use controlled migrations for production.

## Initial administrator account

Public admin registration is disabled. For a fresh database only, you can opt in to one-time bootstrap creation by setting:

- ADMIN_BOOTSTRAP_ENABLED=true
- ADMIN_BOOTSTRAP_USERNAME
- ADMIN_BOOTSTRAP_PASSWORD (at least 12 characters)
- ADMIN_BOOTSTRAP_NAME
- ADMIN_BOOTSTRAP_EMAIL

The bootstrap runs only when the admin table is empty and hashes the password with BCrypt. After the first administrator is created, set ADMIN_BOOTSTRAP_ENABLED=false and remove the bootstrap credentials from the runtime environment. Existing plaintext admin passwords are upgraded to BCrypt after a successful login.

## Build and run

From each service directory:

        mvn test
        mvn package

Start EurekaServer first, then start the other services. Configure the environment variables in the same terminal or IDE run configuration. The GitHub Actions workflow compiles and packages each service for pull requests; automated tests still need to be expanded.

## Security notes

- Never commit .env, passwords, JWT keys, mail credentials, or production configuration.
- Rotate any credentials that were previously committed. Removing a secret from the current file does not remove it from Git history.
- Notification endpoints require the X-Notification-Key header; the key is shared only between AdminService and NotificationService.
- Admin routes require an admin-role JWT. User account and playlist routes require authentication, and playlist operations are restricted to the owning user.
- Uploaded media is limited by size and accepted MIME types and stored under generated filenames. MIME type checks alone are not a substitute for malware scanning or content-signature validation in a public production deployment.
- Do not expose the application publicly until all CI checks and end-to-end authorization tests pass.

## CI

GitHub Actions builds each Maven service on pushes to main and security/** branches and on pull requests. Build success does not prove runtime configuration or authorization is correct; run the services locally and complete the tests before merging.

## Repository hygiene

The .gitignore excludes IDE metadata, build outputs, local environment files, uploads, and logs. Files already tracked by Git must be removed from the index separately; ignore rules alone do not untrack them.
