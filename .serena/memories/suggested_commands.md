# Rocket.Chat Development Commands

## Essential Development Commands

### Initial Setup
```bash
# Install dependencies (from project root)
yarn install

# Verify Node/Yarn versions
node --version  # Should be 22.16.0
yarn --version  # Should be 4.10.3
```

### Development Server
```bash
# Start development server (main Meteor app)
yarn dev

# Start with debugging
yarn debug

# Start with break on first line
yarn debug-brk

# Development server (from meteor app directly)
cd apps/meteor && meteor

# Development with excluded legacy browsers
yarn dev  # Already excludes web.browser.legacy, web.cordova
```

### Building

```bash
# Build all packages (uses Turbo)
yarn build

# Build only services
yarn build:services

# Build for CI environment
yarn build:ci

# Build specific package/app
yarn workspace <package-name> build
```

### Testing

#### Unit Tests
```bash
# Run all unit tests
yarn testunit

# From meteor app (runs client + server + definition tests)
cd apps/meteor && yarn testunit

# Server-side unit tests only
cd apps/meteor && yarn .testunit:server

# Client-side unit tests only (Jest)
cd apps/meteor && yarn .testunit:client

# Definition tests only
cd apps/meteor && yarn .testunit:definition

# Watch mode for development
cd apps/meteor && yarn testunit-watch
```

#### API Tests
```bash
# Run API tests
cd apps/meteor && yarn testapi
```

#### E2E Tests
```bash
# Run Playwright E2E tests
cd apps/meteor && yarn test:e2e

# Run federation E2E tests
cd apps/meteor && yarn test:e2e:federation

# Run E2E tests with coverage
cd apps/meteor && yarn test:e2e:nyc
```

#### Storybook Tests
```bash
# Run Storybook interaction tests
yarn test-storybook
```

#### Coverage
```bash
# Generate coverage report
cd apps/meteor && yarn coverage
```

### Linting & Formatting

```bash
# Run all linters (root level)
yarn lint

# ESLint (JavaScript/TypeScript)
cd apps/meteor && yarn eslint

# ESLint with auto-fix
cd apps/meteor && yarn eslint:fix

# Stylelint (CSS)
cd apps/meteor && yarn stylelint

# Stylelint with auto-fix
cd apps/meteor && yarn stylelint:fix

# Type checking
cd apps/meteor && yarn typecheck
```

### Storybook

```bash
# Start Storybook development server
yarn storybook
# Runs on http://localhost:6006
```

### Docker

```bash
# Start with Docker Compose (local)
docker-compose -f docker-compose-local.yml up

# Start with Docker Compose (from meteor app)
cd apps/meteor && yarn docker:start

# CI Docker Compose
docker-compose -f docker-compose-ci.yml up
```

### Monorepo Management

```bash
# Run command in specific workspace
yarn workspace @rocket.chat/meteor <command>

# Run command in all workspaces
yarn workspaces foreach <command>

# List all workspaces
yarn workspaces list

# Build with Turbo (parallel, cached)
turbo run build

# Run dev in parallel
turbo run dev --parallel
```

### Version Management

```bash
# Check version
cd apps/meteor && yarn version

# Set version
cd apps/meteor && yarn set-version

# Release
cd apps/meteor && yarn release
```

### Utility Scripts

```bash
# Fuselage development helper
yarn fuselage
./fuselage.sh

# FOSSify (remove enterprise code)
yarn fossify

# Add migration (from meteor app)
cd apps/meteor && yarn migration:add

# High Availability: Start main instance
cd apps/meteor && yarn ha

# High Availability: Add instance
cd apps/meteor && yarn ha:add

# Microservices mode
cd apps/meteor && yarn ms
```

### Development Modes

```bash
# Standard development
yarn dev

# Development with services view
yarn dsv

# Object dev mode (test mode)
cd apps/meteor && yarn obj:dev

# Microservices with TCP transporter
cd apps/meteor && TRANSPORTER=TCP yarn ms
```

## Common Task Workflows

### After Making Code Changes
```bash
# 1. Check types
yarn typecheck  # or: cd apps/meteor && yarn typecheck

# 2. Run linters
yarn lint       # or: cd apps/meteor && yarn lint

# 3. Fix auto-fixable issues
cd apps/meteor && yarn eslint:fix && yarn stylelint:fix

# 4. Run relevant tests
yarn testunit   # or specific test suites
```

### Before Committing
```bash
# 1. Ensure code is formatted
# (Prettier should run automatically via pre-commit hooks)

# 2. Type check passes
yarn typecheck

# 3. Linting passes
yarn lint

# 4. Tests pass
yarn testunit

# 5. Build succeeds
yarn build
```

### Adding a New Package
```bash
# Create package directory structure
mkdir -p packages/<package-name>/src

# Add package.json with workspace protocol
# Then install dependencies
yarn install
```

### Debugging

```bash
# Debug with Chrome DevTools
cd apps/meteor && meteor run --inspect

# Debug with break at startup
cd apps/meteor && meteor run --inspect-brk

# Debug tests
cd apps/meteor && yarn testunit-watch
# Then attach debugger to Node process
```

## System Commands (Linux)

### File Operations
```bash
# List files
ls -la

# Find files
find . -name "*.ts" -type f

# Search in files
grep -r "pattern" .

# Change directory
cd path/to/directory
```

### Git Operations
```bash
# Status
git status

# Stage changes
git add <files>

# Commit
git commit -m "message"

# Push
git push origin <branch>

# Pull latest
git pull origin develop

# Create branch
git checkout -b feature/branch-name
```

### Process Management
```bash
# Find processes
ps aux | grep node

# Kill process
kill -9 <PID>

# Check port usage
lsof -i :3000
```

## Environment Variables

### Important Variables
```bash
# Meteor settings
METEOR_SETTINGS='{"key": "value"}'

# Disable optimistic caching (for builds)
METEOR_DISABLE_OPTIMISTIC_CACHING=1

# Node options for memory
NODE_OPTIONS="--max-old-space-size=8192"

# Transporter for microservices
TRANSPORTER=TCP

# Test mode
TEST_MODE=true

# Babel environment
BABEL_ENV=production
```

## Performance Tips

### Faster Builds
```bash
# Use Turbo's cache effectively
turbo run build --cache-dir=.turbo

# Build only changed packages
turbo run build --filter=[HEAD^1]
```

### Faster Development
```bash
# Use DSV (development services view)
yarn dsv

# Parallel dev mode
turbo run dev --parallel --env-mode=loose
```

### Memory Management
```bash
# Increase Node memory for large operations
NODE_OPTIONS="--max-old-space-size=8192" yarn lint
NODE_OPTIONS="--max-old-space-size=8192" yarn typecheck
```
