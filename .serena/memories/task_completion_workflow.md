# Task Completion Workflow

## Standard Workflow: When Completing Any Task

### 1. Code Changes Complete ✅

After implementing your changes, verify the code:

```bash
# Verify syntax and imports are correct
# (TypeScript will catch basic errors during development)
```

### 2. Type Checking 🔍

**CRITICAL**: Always run type checking before proceeding.

```bash
# From project root
yarn typecheck

# OR from meteor app
cd apps/meteor && yarn typecheck
```

**What it checks**:
- Type errors
- Type mismatches
- Missing type definitions
- Interface violations

**Fix any errors** before moving to next step.

### 3. Linting 🧹

Run linters to ensure code quality and style compliance.

```bash
# From project root (runs all linters)
yarn lint

# OR from meteor app
cd apps/meteor && yarn lint
```

This runs:
- **ESLint**: JavaScript/TypeScript linting
- **Stylelint**: CSS linting

**Auto-fix when possible**:
```bash
cd apps/meteor && yarn eslint:fix
cd apps/meteor && yarn stylelint:fix
```

### 4. Testing 🧪

Run appropriate tests based on what you changed.

#### For All Changes
```bash
# Unit tests (comprehensive)
yarn testunit
```

#### For API Changes
```bash
cd apps/meteor && yarn testapi
```

#### For UI Changes
```bash
# If you modified UI components
cd apps/meteor && yarn test:e2e

# Storybook tests
yarn test-storybook
```

#### Coverage Check (Optional)
```bash
cd apps/meteor && yarn coverage
```

**All tests should pass** ✅ before proceeding.

### 5. Build Verification 🏗️

Ensure the project builds successfully.

```bash
# Build all packages
yarn build

# OR build specific workspace
yarn workspace @rocket.chat/meteor build
```

**Build must succeed** without errors.

### 6. Code Review Checklist 📋

Before considering the task complete:

- [ ] Type checking passes (`yarn typecheck`)
- [ ] Linting passes (`yarn lint`)
- [ ] All relevant tests pass
- [ ] Build succeeds (`yarn build`)
- [ ] Code follows project conventions (tabs, 140 char width, etc.)
- [ ] No `console.log` or debugging code left behind
- [ ] Comments are clear and up-to-date
- [ ] New files have proper headers/imports
- [ ] Accessibility considerations (if UI changes)
- [ ] No new TypeScript `any` types (use proper typing)

### 7. Git Workflow 📝

#### Check Status
```bash
git status
git diff
```

#### Stage Changes
```bash
# Stage specific files
git add <files>

# OR stage all changes
git add .
```

#### Commit
```bash
git commit -m "feat: descriptive commit message

- Detail about what was changed
- Why it was changed
- Any breaking changes noted"
```

#### Push (if on feature branch)
```bash
git push origin <branch-name>
```

## Task-Specific Workflows

### New Feature Implementation

1. Create feature branch
2. Implement feature
3. Add tests for new functionality
4. Update documentation
5. Run full workflow above
6. Create PR

### Bug Fix

1. Write failing test that reproduces bug
2. Fix the bug
3. Verify test now passes
4. Run full workflow above
5. Document fix in commit message

### Refactoring

1. Ensure tests exist for current behavior
2. Perform refactoring
3. Verify all tests still pass
4. Run performance checks if applicable
5. Run full workflow above

### Adding New Package

1. Create package structure
2. Add `package.json` with workspace protocol
3. Add TypeScript config extending base
4. Add ESLint config
5. Write package code with tests
6. Build package: `yarn build`
7. Verify in dependent packages
8. Run full workflow

### UI Component Changes

1. Implement component changes
2. Update Storybook stories
3. Run `yarn storybook` and verify visually
4. Run accessibility tests: `yarn test:e2e` (includes axe)
5. Test responsive behavior
6. Run full workflow above

### Database Model Changes

1. Create migration if needed: `yarn migration:add`
2. Update model typings
3. Update dependent code
4. Write tests for new model behavior
5. Test migration on clean database
6. Run full workflow above

## Quality Gates

### Minimum Requirements

**Never commit code that**:
- ❌ Fails type checking
- ❌ Fails linting
- ❌ Fails existing tests
- ❌ Breaks the build
- ❌ Introduces TypeScript `any` without justification
- ❌ Removes tests without replacing them
- ❌ Has console.log or debugging code

**Always ensure**:
- ✅ Type checking passes
- ✅ Linting passes (auto-fix first)
- ✅ Tests pass
- ✅ Build succeeds
- ✅ Code is formatted (Prettier)
- ✅ Documentation is updated
- ✅ Accessibility is considered

### Performance Checks

For performance-critical changes:
```bash
# Run with profiling
NODE_OPTIONS="--prof" yarn dev

# Check bundle size impact
yarn build && du -sh apps/meteor/dist
```

### Accessibility Checks

For UI changes:
```bash
# Playwright tests include axe accessibility checks
cd apps/meteor && yarn test:e2e
```

## Pre-Commit Automation

Rocket.Chat may have pre-commit hooks that automatically:
- Format code with Prettier
- Run linters
- Check types

**If hooks fail**: Fix the issues, don't bypass hooks.

## Continuous Integration

After pushing, CI will run:
1. Type checking
2. Linting
3. Unit tests
4. E2E tests
5. Build verification
6. Code coverage

**Monitor CI** and fix any failures immediately.

## Emergency Fixes

For critical production issues:
1. Create hotfix branch from main/master
2. Minimal fix only
3. Add regression test
4. Fast-track review
5. Still run full workflow (no shortcuts)

## Documentation Updates

When task involves user-facing changes:
- Update relevant documentation
- Add JSDoc comments to public APIs
- Update README if needed
- Add examples where helpful

## Review Preparation

Before requesting review:
1. Self-review your changes
2. Verify all checklist items
3. Write clear PR description
4. Link related issues
5. Add screenshots for UI changes
6. Note any breaking changes

## Common Issues & Solutions

### Type Errors
```bash
# Check specific file
yarn workspace @rocket.chat/meteor exec tsc --noEmit path/to/file.ts
```

### Lint Errors
```bash
# Auto-fix most issues
cd apps/meteor && yarn eslint:fix
```

### Test Failures
```bash
# Run specific test
cd apps/meteor && yarn testunit-watch --grep "test name"
```

### Build Failures
```bash
# Clean and rebuild
rm -rf node_modules/.cache
yarn build --force
```

### Memory Issues
```bash
# Increase memory
NODE_OPTIONS="--max-old-space-size=8192" yarn build
```
