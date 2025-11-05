# Rocket.Chat - Claude Code Project Guide

## Project Overview

**Rocket.Chat** is an open-source, secure, fully customizable communications platform for organizations with high standards of data protection. Built entirely in TypeScript, it serves tens of millions of users across 150+ countries including major organizations like Deutsche Bahn, the US Navy, and Credit Suisse.

### Key Capabilities
- Team collaboration with role-based access control
- Omnichannel engagement (WhatsApp, SMS, etc.)
- Self-hosted AI integration
- Extensible apps marketplace
- Federation support for decentralized communication

## Repository Structure

This is a **Yarn v4 monorepo** managed with **Turborepo** for optimized builds.

```
Rocket.Chat/
├── apps/
│   ├── meteor/           # Main application (Meteor.js)
│   └── uikit-playground/ # UIKit testing environment
├── packages/             # 50+ shared packages
├── ee/                   # Enterprise Edition
│   ├── apps/            # EE microservices
│   └── packages/        # EE packages
├── scripts/             # Build and utility scripts
└── package.json         # Monorepo root config
```

### Main Application: `apps/meteor/`

The core Rocket.Chat application built with Meteor.js:

```
apps/meteor/
├── app/          # Legacy feature modules
├── client/       # React-based client
│   ├── components/
│   ├── views/
│   ├── hooks/
│   └── contexts/
├── server/       # Server-side logic
│   ├── services/
│   ├── methods/
│   └── publications/
├── ee/           # Enterprise features
├── tests/        # E2E and unit tests
└── package.json
```

### Shared Packages (`packages/`)

**Core Types & Models**:
- `core-typings`, `model-typings`, `rest-typings`
- `models`, `mongo-adapter`, `core-services`

**UI Components**:
- `ui-kit`, `ui-contexts`, `ui-client`, `ui-composer`
- `ui-avatar`, `ui-video-conf`, `ui-voip`
- `fuselage-ui-kit`, `web-ui-registration`

**Communication**:
- `ddp-client`, `api-client`, `http-router`

**Utilities**:
- `logger`, `tools`, `i18n`, `random`, `sha256`, `base64`, `jwt`

**Apps & Extensions**:
- `apps-engine`, `apps`, `livechat`

**Infrastructure**:
- `instance-status`, `server-fetch`, `agenda`, `cron`

### Enterprise Edition (`ee/`)

**Microservices** (`ee/apps/`):
- account-service, authorization-service, presence-service
- ddp-streamer, queue-worker, stream-hub-service
- omnichannel-transcript

**EE Packages** (`ee/packages/`):
- license, federation-matrix, media-calls
- network-broker, omnichannel-services, ui-theming

## Tech Stack

### Core Technologies
- **Language**: TypeScript 5.9.3 (strict mode)
- **Runtime**: Node.js 22.16.0
- **Package Manager**: Yarn 4.10.3 (Berry with PnP)
- **Monorepo**: Turborepo 2.5.8
- **Framework**: Meteor.js

### Frontend
- **UI**: React with hooks (functional components)
- **Components**: Fuselage (internal UI library)
- **Development**: Storybook 8.6.14
- **E2E Testing**: Playwright 1.52.0
- **Unit Testing**: Jest + React Testing Library
- **Accessibility**: @axe-core/playwright

### Backend
- **Database**: MongoDB 6.10.0
- **Real-time**: DDP (Distributed Data Protocol)
- **Microservices**: Independent services (EE)
- **Job Scheduling**: Agenda, Cron

### Build & Quality
- **Build**: Turborepo with intelligent caching
- **Linting**: ESLint (custom config)
- **Formatting**: Prettier
- **CSS**: Stylelint
- **Coverage**: NYC (server), Jest (client)

## Development Setup

### Prerequisites
```bash
# Verify versions
node --version  # Should be 22.16.0
yarn --version  # Should be 4.10.3

# Install dependencies
yarn install
```

### Essential Commands

#### Development
```bash
yarn dev                    # Start development server
yarn dsv                    # Development with services view
cd apps/meteor && meteor    # Direct Meteor start
```

#### Building
```bash
yarn build                  # Build all packages (Turbo)
yarn build:services         # Build services only
yarn build:ci               # CI build
```

#### Testing
```bash
yarn testunit               # All unit tests
cd apps/meteor && yarn testapi      # API tests
cd apps/meteor && yarn test:e2e     # E2E tests (Playwright)
yarn test-storybook         # Storybook tests
```

#### Code Quality
```bash
yarn lint                   # Run all linters
cd apps/meteor && yarn eslint       # ESLint only
cd apps/meteor && yarn eslint:fix   # Auto-fix ESLint issues
cd apps/meteor && yarn stylelint    # CSS linting
cd apps/meteor && yarn typecheck    # TypeScript type checking
```

#### Storybook
```bash
yarn storybook              # Start Storybook on :6006
```

### Task Completion Checklist

**Before committing any changes:**

1. ✅ **Type check**: `yarn typecheck` - MUST pass
2. ✅ **Lint**: `yarn lint` - Fix with `eslint:fix`
3. ✅ **Test**: `yarn testunit` - All tests pass
4. ✅ **Build**: `yarn build` - Successful build
5. ✅ **Review**: No console.log, proper formatting

### Common Workflows

**New Feature**:
```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Implement feature with tests
# 3. Run quality checks
yarn typecheck && yarn lint && yarn testunit

# 4. Commit
git commit -m "feat: descriptive message"
```

**Bug Fix**:
```bash
# 1. Write failing test
# 2. Fix bug
# 3. Verify test passes
yarn testunit

# 4. Run full checks
yarn typecheck && yarn lint && yarn build
```

## Code Style & Conventions

### Prettier Configuration
- **Indentation**: Tabs (not spaces)
- **Line Width**: 140 characters
- **Quotes**: Single quotes (including JSX)
- **Semicolons**: Required
- **Trailing Commas**: All
- **Line Endings**: LF (Unix)

### TypeScript Standards
- **Strict Mode**: Enabled
- **No `any`**: Avoid unless absolutely necessary
- **Explicit Types**: Prefer explicit over inferred
- **Null Checks**: Strict null checking enabled
- **No Unused**: Locals and parameters checked

### File Naming
- TypeScript/JavaScript: `.ts`, `.tsx`, `.js`, `.jsx`
- Tests: `*.spec.ts`, `*.test.ts`
- Config: JSON or TypeScript

### Import Organization
1. External dependencies
2. Internal packages (workspace)
3. Local imports (relative paths)

### React Patterns
- **Functional components** with hooks (no class components)
- **TypeScript interfaces** for props
- **Named exports** preferred
- **Custom hooks** for reusable logic

Example:
```typescript
interface Props {
	userId: string;
	onUpdate: (data: UserData) => void;
}

export const UserProfile: FC<Props> = ({ userId, onUpdate }) => {
	const [user, setUser] = useState<User | null>(null);

	useEffect(() => {
		loadUser(userId).then(setUser);
	}, [userId]);

	return <div>{user?.name}</div>;
};
```

## Architecture Patterns

### Monorepo Pattern
- **Yarn Workspaces**: Shared dependencies
- **Workspace Protocol**: `workspace:` for internal deps
- **Turborepo**: Parallel builds with caching
- **Independent Packages**: Each can version separately

### Meteor Patterns
- **DDP**: Real-time data sync
- **Publications**: Server-side data control
- **Methods**: RPC with automatic error handling
- **Reactivity**: Automatic UI updates

### React Patterns
- **Hooks**: useState, useEffect, useContext, custom hooks
- **Context**: Global state management
- **Memoization**: useMemo, useCallback for performance
- **Code Splitting**: Lazy loading for routes

### Testing Patterns
```typescript
// Unit test structure
describe('Feature', () => {
	it('should behave correctly', () => {
		// Arrange
		const input = setupTest();

		// Act
		const result = performAction(input);

		// Assert
		expect(result).toBe(expected);
	});
});

// E2E test structure
test('user flow', async ({ page }) => {
	await page.goto('/');
	await page.click('[data-testid=button]');
	await expect(page).toHaveURL('/success');
});
```

## Key Technologies & Frameworks

### Meteor.js
- **DDP Protocol**: Real-time data synchronization
- **Isomorphic**: Code runs on client and server
- **Reactivity**: Built-in reactive data system

### Turborepo
- **Caching**: Intelligent build caching
- **Parallel Execution**: Run tasks concurrently
- **Dependencies**: Task dependency graph
- **Filters**: Build subsets of monorepo

### Microservices (EE)
- **Message Broker**: Service communication
- **Service Discovery**: Dynamic registration
- **Fault Isolation**: Independent service failures
- **Scalability**: Horizontal scaling

## Security & Best Practices

### Input Validation
```typescript
import { check } from 'meteor/check';

Meteor.methods({
	'sendMessage': function(text: string) {
		check(text, String);

		if (!this.userId) {
			throw new Meteor.Error('not-authorized');
		}

		// Process safely
	}
});
```

### Authentication & Authorization
- Always check `this.userId` in methods
- Use permission system for authorization
- Validate on server, never trust client

### XSS Prevention
- React's automatic escaping
- Server-side validation
- Sanitize user input

## Accessibility Standards

### Requirements
- **WCAG Compliance**: Tested with @axe-core/playwright
- **Semantic HTML**: Use proper elements
- **ARIA Labels**: Where semantic HTML isn't enough
- **Keyboard Navigation**: All interactive elements

Example:
```typescript
<button aria-label="Close dialog">
	<Icon name="close" aria-hidden="true" />
</button>
```

## Performance Optimization

### React Performance
```typescript
// Memoization
const data = useMemo(() => expensiveComputation(input), [input]);
const callback = useCallback(() => doSomething(id), [id]);

// Code splitting
const AdminPanel = lazy(() => import('./AdminPanel'));
```

### Build Performance
- Turborepo caching reduces build times
- Incremental builds
- Parallel task execution

## Internationalization (i18n)

```typescript
import { useTranslation } from '@rocket.chat/i18n';

function Component() {
	const { t } = useTranslation();
	return <h1>{t('Welcome_message')}</h1>;
}
```

Translation files in `packages/i18n/` as JSON.

## Logging

```typescript
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('ServiceName');

logger.info('Operation completed', { userId, duration });
logger.warn('Unusual activity', { details });
logger.error('Operation failed', { error });
```

## Database (MongoDB)

### Model Usage
```typescript
import { Users, Messages } from '@rocket.chat/models';

// Query
const user = await Users.findOneById(userId);

// Insert
await Messages.insertOne({
	text: 'Hello',
	userId,
	roomId,
	createdAt: new Date()
});

// Update
await Users.updateOne(
	{ _id: userId },
	{ $set: { status: 'online' } }
);
```

## Common Issues & Solutions

### Type Errors
```bash
yarn typecheck                    # Check all
yarn workspace @rocket.chat/meteor exec tsc --noEmit path/to/file.ts
```

### Lint Errors
```bash
cd apps/meteor && yarn eslint:fix  # Auto-fix
```

### Build Failures
```bash
rm -rf node_modules/.cache
yarn build --force
```

### Memory Issues
```bash
NODE_OPTIONS="--max-old-space-size=8192" yarn build
NODE_OPTIONS="--max-old-space-size=8192" yarn lint
```

## Git Workflow

### Branch Strategy
- **Main Branch**: `develop`
- **Feature Branches**: `feature/description`
- **Hotfix Branches**: `hotfix/description`

### Commit Messages
```
feat: add user presence tracking
fix: resolve memory leak in message cache
refactor: simplify authentication logic
docs: update API documentation
test: add E2E tests for login flow
```

## CI/CD Pipeline

After pushing, CI runs:
1. Type checking
2. Linting (ESLint, Stylelint)
3. Unit tests
4. E2E tests
5. Build verification
6. Code coverage

**Monitor CI** - fix failures immediately.

## Docker Development

```bash
# Local development
docker-compose -f docker-compose-local.yml up

# CI environment
docker-compose -f docker-compose-ci.yml up
```

## Resources

### Documentation
- **User Docs**: https://docs.rocket.chat/docs/rocketchat
- **Admin Guide**: https://docs.rocket.chat/docs/administrators-guide
- **Developer Docs**: https://developer.rocket.chat/docs/rocketchat-developer
- **API Docs**: https://developer.rocket.chat/apidocs

### Community
- **Community Server**: https://open.rocket.chat
- **GitHub**: https://github.com/RocketChat/Rocket.Chat
- **Issues**: https://github.com/RocketChat/Rocket.Chat/issues

## Quick Reference

### Must-Run Before Commit
```bash
yarn typecheck  # Type checking
yarn lint       # Linting
yarn testunit   # Tests
yarn build      # Build verification
```

### Development Cycle
```bash
yarn dev        # Start dev server
# Make changes
yarn typecheck && yarn lint && yarn testunit
git commit -m "feat: description"
```

### Package Management
```bash
yarn workspace @rocket.chat/<package> <command>
yarn workspaces foreach <command>
turbo run build --filter=<package>...
```

## Important Notes

- **Never commit** code that fails type checking
- **Always run** linters and auto-fix before committing
- **Write tests** for all new features
- **No `any` types** without justification
- **Tab indentation**, not spaces
- **140 character** line width
- **Functional components** with hooks, not classes
- **Accessibility** is required, not optional
- **Security** checks in all methods

---

## Working with Claude Code

### Serena MCP Integration
This project is configured with **Serena MCP** for intelligent code navigation and memory management.

**Key Features**:
- Semantic code understanding
- Symbol-based navigation and editing
- Project memory persistence
- LSP integration for multi-language support

**Common Operations**:
```bash
# Session management
/sc:load    # Load project context
/sc:save    # Save session state

# Code exploration
# Use Serena's symbol tools for efficient navigation
```

### Best Practices for Claude Code
1. Use **symbol-based navigation** over full file reads
2. Leverage **project memory** for context
3. Run **quality checks** before completing tasks
4. Keep **todos updated** for complex tasks
5. Follow **task completion workflow** strictly

---

*Last Updated: 2025-11-05*
*Project Version: 7.13.0-develop*
