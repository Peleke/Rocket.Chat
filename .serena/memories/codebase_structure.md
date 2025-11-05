# Rocket.Chat Codebase Structure

## Root Directory Layout

```
Rocket.Chat/
├── apps/                      # Main applications
├── packages/                  # Shared packages (50+)
├── ee/                       # Enterprise Edition
│   ├── apps/                 # EE-specific applications
│   └── packages/             # EE-specific packages
├── scripts/                  # Build and utility scripts
├── development/              # Development configurations
├── .github/                  # GitHub Actions & workflows
├── .devcontainer/           # VS Code dev container config
├── .gitpod/                 # Gitpod cloud IDE config
├── .houston/                # Houston tooling
├── .changeset/              # Changeset versioning
├── package.json             # Root monorepo config
├── turbo.json               # Turborepo configuration
└── yarn.lock                # Dependency lock file
```

## Apps Directory (`apps/`)

### Main Application: Meteor (`apps/meteor/`)
The core Rocket.Chat application built with Meteor.js.

```
apps/meteor/
├── app/                     # Legacy Meteor application code
│   ├── api/                 # API definitions
│   ├── authentication/      # Auth logic
│   ├── authorization/       # Permission system
│   ├── channels/           # Channel management
│   ├── file-upload/        # File handling
│   ├── livechat/           # Omnichannel/Livechat
│   ├── utils/              # Shared utilities
│   └── ...                 # Many more feature modules
│
├── client/                  # Client-side code
│   ├── components/         # React components
│   ├── contexts/           # React contexts
│   ├── hooks/              # React hooks
│   ├── lib/                # Client utilities
│   ├── views/              # Page-level views
│   └── startup/            # Client initialization
│
├── server/                  # Server-side code
│   ├── startup/            # Server initialization
│   ├── services/           # Business logic services
│   ├── methods/            # Meteor methods
│   ├── publications/       # Data publications
│   ├── lib/                # Server utilities
│   └── models/             # (Legacy) Data models
│
├── imports/                 # Meteor imports directory
│   ├── client/             # Client-specific imports
│   ├── server/             # Server-specific imports
│   └── ...
│
├── ee/                      # Enterprise features in Meteor
│   └── server/
│       └── services/       # EE microservices
│
├── lib/                     # Isomorphic code (client+server)
├── packages/               # Local Meteor packages
├── public/                 # Static assets
├── private/                # Server-only assets
├── tests/                  # Test files
│   ├── e2e/               # Playwright E2E tests
│   ├── unit/              # Unit tests
│   └── ...
│
├── .storybook/            # Storybook configuration
├── package.json           # Meteor app dependencies
├── tsconfig.json          # TypeScript configuration
├── jest.config.ts         # Jest configuration
├── playwright.config.ts   # Playwright configuration
└── .eslintrc.json        # ESLint configuration
```

### UIKit Playground (`apps/uikit-playground/`)
Testing/development environment for UIKit components.

## Packages Directory (`packages/`)

### Core Type Definitions
- **core-typings**: Core TypeScript types and interfaces
- **model-typings**: Database model type definitions
- **rest-typings**: REST API type definitions

### Data & Models
- **models**: Database models and queries
- **mongo-adapter**: MongoDB adapter layer
- **core-services**: Core business logic services

### UI Components & Frameworks
- **ui-kit**: Base UI Kit components
- **ui-contexts**: React context providers
- **ui-client**: Client-side UI utilities
- **ui-composer**: Message composer component
- **ui-avatar**: Avatar components
- **ui-video-conf**: Video conferencing UI
- **ui-voip**: VoIP call UI
- **fuselage-ui-kit**: Fuselage integration with UIKit
- **web-ui-registration**: Registration UI components

### Communication & APIs
- **ddp-client**: DDP (Distributed Data Protocol) client
- **api-client**: REST API client
- **rest-typings**: REST API type definitions
- **http-router**: HTTP routing utilities

### Utilities
- **logger**: Logging infrastructure
- **tools**: General utilities
- **i18n**: Internationalization
- **random**: Random value generation
- **sha256**: SHA-256 hashing
- **base64**: Base64 encoding/decoding
- **jwt**: JSON Web Token utilities
- **password-policies**: Password validation
- **tracing**: Distributed tracing

### Apps & Extensions
- **apps-engine**: Apps-Engine framework for extensibility
- **apps**: App integration logic
- **livechat**: Livechat/Omnichannel widget

### Infrastructure
- **instance-status**: Service instance status
- **server-fetch**: Server-side fetch utilities
- **server-cloud-communication**: Cloud service communication
- **agenda**: Job scheduling
- **cron**: Cron job management

### Communication Protocols
- **media-signaling**: WebRTC signaling
- **freeswitch**: FreeSWITCH integration
- **cas-validate**: CAS authentication

### Development Tools
- **eslint-config**: Shared ESLint configuration
- **tsconfig**: Shared TypeScript configs
- **jest-presets**: Jest testing presets
- **storybook-config**: Storybook configuration
- **mock-providers**: Testing mock providers
- **peggy-loader**: PEG.js parser loader

### Release Management
- **release-action**: GitHub release actions
- **release-changelog**: Changelog generation

### Other
- **desktop-api**: Desktop app API
- **favicon**: Favicon generation
- **gazzodown**: Markdown renderer
- **message-parser**: Message parsing
- **message-types**: Message type definitions
- **patch-injection**: Runtime patching
- **log-format**: Log formatting
- **omni-core**: Omnichannel core logic
- **account-utils**: Account utilities
- **node-poplib**: POP3 client

## Enterprise Edition (`ee/`)

### EE Applications (`ee/apps/`)
Microservices for enterprise features:
- **account-service**: Account management service
- **authorization-service**: Advanced authorization
- **ddp-streamer**: DDP streaming service
- **presence-service**: User presence tracking
- **queue-worker**: Background job processing
- **stream-hub-service**: Real-time streaming hub
- **omnichannel-transcript**: Chat transcripts

### EE Packages (`ee/packages/`)
Enterprise-only features:
- **license**: License management
- **federation-matrix**: Matrix federation protocol
- **media-calls**: Advanced media calling
- **network-broker**: Network broker for scaling
- **omni-core-ee**: Enterprise omnichannel
- **omnichannel-services**: Advanced omnichannel
- **pdf-worker**: PDF generation service
- **presence**: Advanced presence features
- **ui-theming**: Theme customization

## Key Configuration Files

### Monorepo Configuration
- **package.json**: Yarn workspaces definition, scripts
- **turbo.json**: Turborepo build configuration
- **yarn.lock**: Dependency lock file
- **.yarnrc.yml**: Yarn configuration
- **.npmrc**: NPM configuration

### Code Quality
- **.prettierrc**: Prettier formatting rules
- **.editorconfig**: Editor configuration
- **Each package has**: `.eslintrc.json`, `tsconfig.json`

### Docker & Deployment
- **docker-compose-local.yml**: Local development
- **docker-compose-ci.yml**: CI environment
- **Dockerfile**: Various Dockerfiles in apps

### CI/CD
- **.github/workflows/**: GitHub Actions
- **.houston/**: Houston tooling config
- **codecov.yml**: Code coverage config

### Development Environments
- **.devcontainer/**: VS Code dev containers
- **.gitpod/**: Gitpod configuration
- **.vscode/**: VS Code settings

## Architecture Patterns

### Monorepo Structure
- **Yarn Workspaces**: Package management
- **Turborepo**: Build orchestration with caching
- **Independent Versioning**: Each package can version independently

### Meteor App Structure
- **app/**: Feature-based modules (legacy)
- **client/**: Modern React-based client
- **server/**: Server-side logic
- **imports/**: Meteor's import system
- **packages/**: Local Meteor packages

### Microservices (EE)
- Independent services in `ee/apps/`
- Communication via message broker
- Scalable architecture for enterprise

### Shared Code
- **packages/**: Shared across all apps
- **TypeScript**: Type-safe shared interfaces
- **Workspace Protocol**: `workspace:` dependencies

## Module Organization Philosophy

### Feature-Based (Legacy in app/)
Each feature has its own directory with:
- Client code
- Server code  
- Shared utilities
- Tests

### Layer-Based (Modern in client/server/)
Organized by technical layer:
- Components
- Views
- Services
- Models
- Utilities

### Package-Based (packages/)
Self-contained packages with:
- Clear single responsibility
- Independent testing
- Reusable across apps
- Documented public APIs
