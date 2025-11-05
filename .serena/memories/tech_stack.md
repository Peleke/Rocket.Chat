# Rocket.Chat Tech Stack

## Core Technologies

### Language & Runtime
- **Primary Language**: TypeScript
- **Node.js Version**: 22.16.0 (managed via Volta)
- **Package Manager**: Yarn 4.10.3 (Yarn Berry with PnP)

### Build System
- **Monorepo Tool**: Turborepo 2.5.8
- **Build Tasks**: Defined in `turbo.json`
- **Workspace Structure**: Yarn workspaces

### Main Framework
- **Primary App**: Meteor.js (in `apps/meteor/`)
- **Module System**: CommonJS (type: "commonjs")
- **Babel**: For transpilation and React support

## Frontend Technologies

### UI Framework
- **React**: Component-based UI
- **Fuselage**: Rocket.Chat's UI component library
- **Storybook**: Component development and testing (v8.6.14)

### Styling
- **CSS**: Standard CSS with PostCSS
- **Stylelint**: CSS linting

### UI Testing
- **Playwright**: E2E browser testing (v1.52.0)
- **Testing Library**: React testing (@testing-library/react v16.3.0)
- **Axe**: Accessibility testing (@axe-core/playwright)

## Backend Technologies

### Data Layer
- **Database**: MongoDB 6.10.0
- **DDP**: Meteor's data protocol for real-time sync

### Services Architecture
- **Microservices**: Multiple services in `ee/apps/` (Enterprise Edition)
  - Account Service
  - Authorization Service  
  - DDP Streamer
  - Presence Service
  - Queue Worker
  - Stream Hub Service
  - Omnichannel Transcript

## Testing Infrastructure

### Test Runners
- **Mocha**: Server-side unit tests
- **Jest**: Client-side unit tests (with custom presets)
- **NYC**: Code coverage reporting
- **Playwright**: E2E testing

### Test Types
- Unit tests (client & server)
- API tests
- E2E tests
- Storybook interaction tests
- Definition tests

## Development Tools

### Code Quality
- **ESLint**: JavaScript/TypeScript linting (custom config in `@rocket.chat/eslint-config`)
- **Prettier**: Code formatting
  - Print width: 140
  - Single quotes, tabs for indentation
  - Trailing commas: all
- **Stylelint**: CSS linting
- **TypeScript**: Strict mode enabled

### TypeScript Configuration
- **Compiler**: TypeScript 5.9.3
- **Target**: ES5
- **Module**: CommonJS
- **Strict Mode**: Enabled
  - `noImplicitAny`: true
  - `strictNullChecks`: true
  - `noUnusedLocals`: true
  - `noUnusedParameters`: true

## Package Architecture

### Shared Packages (50+ packages in `packages/`)
- **Core**: `core-typings`, `core-services`
- **Models**: `models`, `model-typings`, `mongo-adapter`
- **UI**: `ui-kit`, `ui-contexts`, `ui-client`, `ui-composer`, `ui-avatar`, `ui-video-conf`, `ui-voip`
- **Utilities**: `logger`, `tools`, `i18n`, `random`, `sha256`, `base64`, `jwt`
- **Communication**: `ddp-client`, `rest-typings`, `api-client`
- **Apps**: `apps-engine`, `apps`
- **Services**: `instance-status`, `server-fetch`, `http-router`

### Enterprise Edition (`ee/`)
- **Packages**: License, federation, media calls, omnichannel services, network broker
- **Apps**: Microservices for enterprise features

## Deployment & Infrastructure

### Containerization
- **Docker**: Primary deployment method
- **Docker Compose**: Local development (`docker-compose-local.yml`, `docker-compose-ci.yml`)

### Cloud & Orchestration
- **Kubernetes**: Supported deployment
- **Podman**: Alternative to Docker
- **Launchpad**: Quick Kubernetes setup

## Additional Technologies

### Communication
- **WebRTC**: Video/audio conferencing
- **Federation**: Matrix protocol support (in `ee/packages/federation-matrix`)
- **Omnichannel**: WhatsApp, SMS integrations

### Development Environment Support
- **Gitpod**: Cloud development environment (`.gitpod/`)
- **DevContainer**: VS Code remote containers (`.devcontainer/`)
- **Houston**: Custom tooling (`.houston/`)
