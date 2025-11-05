# Code Style and Conventions

## Formatting Standards

### Prettier Configuration
- **Indentation**: Tabs (not spaces)
- **Line Width**: 140 characters
- **Quotes**: 
  - Single quotes for strings
  - JSX: Single quotes (`jsxSingleQuote: true`)
- **Semicolons**: Required (`semi: true`)
- **Trailing Commas**: All (`trailingComma: "all"`)
- **Arrow Functions**: Always use parentheses (`arrowParens: "always"`)
- **Bracket Spacing**: Yes (`bracketSpacing: true`)
- **Line Endings**: LF (Unix-style)
- **Quote Props**: Consistent (`quoteProps: "consistent"`)

### EditorConfig
- **Charset**: UTF-8
- **End of Line**: LF
- **Trim Trailing Whitespace**: Yes
- **Insert Final Newline**: Yes
- **JavaScript/HTML/CSS**: Tab indentation
- **i18n JSON files**: 2 spaces
- **Markdown**: Don't trim trailing whitespace

## TypeScript Standards

### Compiler Options
- **Strict Mode**: Enabled across the board
- **No Implicit Any**: Required
- **Strict Null Checks**: Enforced
- **No Unused Locals**: Enforced
- **No Unused Parameters**: Enforced
- **Force Consistent Casing**: Required for file names
- **Skip Lib Check**: Enabled for performance
- **Module Resolution**: Node
- **Resolve JSON Module**: Enabled

### Type Safety
- Prefer explicit types over `any`
- Use strict null checks
- Define interfaces for all public APIs
- Use type guards where appropriate

## File Organization

### Naming Conventions
- **TypeScript/JavaScript**: `.ts`, `.tsx`, `.js`, `.jsx` extensions
- **Test Files**: 
  - Unit tests: `*.spec.ts`, `*.test.ts`
  - Located alongside source or in `tests/` directories
- **Configuration**: JSON for configs, TypeScript for build configs

### Directory Structure Conventions
- **Apps**: Main applications go in `apps/`
- **Packages**: Shared libraries in `packages/`
- **Enterprise**: EE features in `ee/apps/` and `ee/packages/`
- **Tests**: Can be co-located or in `tests/` directory
- **Public**: Static assets in `public/`
- **Private**: Server-only assets in `private/`

## Code Organization

### Import Order (ESLint enforced)
1. External dependencies
2. Internal packages (workspace dependencies)
3. Local imports (relative paths)

### Component Structure (React)
- Use functional components with hooks
- TypeScript interfaces for props
- Export components as named exports
- Co-locate styles when applicable

## Linting Rules

### ESLint
- **Config Package**: `@rocket.chat/eslint-config`
- **Extensions**: `.js`, `.jsx`, `.ts`, `.tsx`
- **Cache**: Enabled for performance
- **Max Memory**: 8192MB for large codebase

### Stylelint
- **Target**: `app/**/*.css`, `client/**/*.css`
- **Auto-fix**: Available via `stylelint:fix`

## Testing Conventions

### Test Structure
- **Unit Tests**: 
  - Server: Mocha + Chai
  - Client: Jest + React Testing Library
- **API Tests**: Mocha with specific config
- **E2E Tests**: Playwright
- **Definition Tests**: Separate mocha config

### Test Naming
- Describe blocks: Feature or component name
- It blocks: Clear behavior description
- Use "should" for behavior assertions

### Coverage
- NYC for server-side coverage
- Jest coverage for client-side
- LCOV reports generated

## Git Conventions

### Branch Strategy
- **Main Branch**: `develop`
- **Release Branches**: Version-based
- **Feature Branches**: Descriptive names

### Commit Messages
- Clear, descriptive messages
- Reference issues when applicable
- Follow conventional commits where possible

## Documentation

### Code Comments
- JSDoc for public APIs
- Inline comments for complex logic only
- Keep comments up-to-date with code changes

### README Files
- Each package should have a README
- Document public APIs and usage examples
- Include setup instructions where needed

## Accessibility

### Standards
- **WCAG Compliance**: Tested with Axe
- **Keyboard Navigation**: Required for all interactive elements
- **ARIA Labels**: Use appropriately
- **Screen Reader**: Test compatibility

## Performance Considerations

### Build Performance
- Incremental builds via Turbo cache
- Dependency-based build ordering
- Parallel execution where possible

### Runtime Performance
- Lazy loading for large components
- Code splitting for optimal bundle sizes
- Memoization for expensive computations
