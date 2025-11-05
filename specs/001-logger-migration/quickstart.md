# Developer Quickstart: Using Rocket.Chat Logger

**Purpose**: Quick reference for developers working with @rocket.chat/logger in client code
**Audience**: Rocket.Chat developers contributing to the logger migration or writing new code

## Quick Start (TL;DR)

```typescript
// 1. Import Logger
import { Logger } from '@rocket.chat/logger';

// 2. Create instance (one per file)
const logger = new Logger('YourModuleName');

// 3. Use instead of console
logger.info('Your message', optionalArgs);
logger.warn('Warning message', optionalArgs);
logger.error('Error message', optionalArgs);
```

## Common Replacements

### Replace console.log

**Before**:
```typescript
console.log('Service worker reloading');
console.log('User connected:', userId);
console.log('Processing items:', items);
```

**After**:
```typescript
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('ServiceWorker');

logger.info('Service worker reloading');
logger.info('User connected:', userId);
logger.info('Processing items:', items);
```

### Replace console.warn

**Before**:
```typescript
console.warn('Rate limit approaching');
console.warn('Deprecated method called:', methodName);
```

**After**:
```typescript
logger.warn('Rate limit approaching');
logger.warn('Deprecated method called:', methodName);
```

### Replace console.error (Optional)

**Note**: This migration focuses on console.log/warn, but console.error can also use Logger:

**Before**:
```typescript
console.error('Failed to load data:', error);
```

**After**:
```typescript
logger.error('Failed to load data:', error);
```

## Logger Methods

### Available Methods

| Method | Use Case | Example |
|--------|----------|---------|
| `.info()` | General information logs | `logger.info('User logged in', { userId })` |
| `.warn()` | Warnings and non-critical issues | `logger.warn('API rate limit approaching')` |
| `.error()` | Errors and exceptions | `logger.error('Failed to save', { error })` |
| `.debug()` | Detailed debugging information | `logger.debug('Request payload:', payload)` |
| `.success()` | Successful operations | `logger.success('Migration completed')` |
| `.fatal()` | Fatal errors | `logger.fatal(criticalError)` |

### Method Overloads

Logger methods accept multiple argument patterns:

```typescript
// String message
logger.info('Simple message');

// String message with arguments
logger.info('User %s logged in', userId);

// Object with additional context
logger.info({ userId, timestamp }, 'User logged in');

// Message with multiple arguments
logger.info('Processing', itemCount, 'items');
```

## Naming Your Logger

### Good Logger Names

✅ **Descriptive and concise**:
```typescript
const logger = new Logger('ServiceWorker');
const logger = new Logger('VideoConf');
const logger = new Logger('VoIP');
```

✅ **Match module purpose**:
```typescript
// In RoomManager.ts
const logger = new Logger('RoomManager');

// In useAnalytics.ts
const logger = new Logger('useAnalytics');
```

### Bad Logger Names

❌ **Too vague**:
```typescript
const logger = new Logger('Client');  // Which client module?
const logger = new Logger('Utils');   // Which utility?
```

❌ **Too verbose**:
```typescript
const logger = new Logger('VideoConferenceManagerClientSide');
```

❌ **Inconsistent with file**:
```typescript
// In VideoConfManager.ts
const logger = new Logger('Video');  // Incomplete/unclear
```

## File Structure

### Correct Import and Logger Placement

```typescript
// 1. External imports first
import { Meteor } from 'meteor/meteor';
import React, { useState } from 'react';

// 2. Rocket.Chat package imports
import { Logger } from '@rocket.chat/logger';

// 3. Local imports
import { someUtil } from './utils';

// 4. Logger instance (after imports, before code)
const logger = new Logger('ModuleName');

// 5. Rest of your code
export function MyComponent() {
  logger.info('Component rendering');
  return <div>Content</div>;
}
```

## Testing in Browser Console

### Viewing Logs

1. Open browser DevTools (F12)
2. Go to Console tab
3. Look for logs with format: `[LoggerName] message`

Example output:
```
[ServiceWorker] Reloading to activate
[VoIP] Call started with peer: user123
[VideoConf] Camera access granted
```

### Filtering Logs

**By logger name**:
```javascript
// In DevTools console
// Filter to show only VoIP logs
```

DevTools typically supports filtering by text, so search for `[VoIP]` to see only VoIP logs.

**By level**:
Use DevTools' built-in level filtering (Info, Warnings, Errors) to filter by severity.

## Common Issues & Solutions

### Issue: "Cannot find module '@rocket.chat/logger'"

**Cause**: Package not installed or build not up to date

**Solution**:
```bash
yarn install
yarn build
```

### Issue: "Property 'info' does not exist on type 'Logger'"

**Cause**: TypeScript can't find Logger type definitions

**Solution**:
1. Check import path: `import { Logger } from '@rocket.chat/logger';`
2. Run typecheck: `yarn typecheck`
3. Rebuild: `yarn build`

### Issue: ESLint error "logger is assigned a value but never used"

**Cause**: Logger imported but no log calls present (might have been removed)

**Solution**: Remove unused Logger import and instance

### Issue: Logs not appearing in browser console

**Cause**: Log level might be set too high (only showing warnings/errors)

**Solution**: Check Rocket.Chat settings for client logging level configuration

### Issue: "ReferenceError: logger is not defined"

**Cause**: Logger instance not created or typo in variable name

**Solution**: Ensure `const logger = new Logger('Name');` is present in file

## Pre-Commit Checklist

Before committing Logger migration changes:

- [ ] Import added: `import { Logger } from '@rocket.chat/logger';`
- [ ] Logger instance created: `const logger = new Logger('...');`
- [ ] All console.log replaced with logger.info()
- [ ] All console.warn replaced with logger.warn()
- [ ] No console.log/warn remain in file (verify with grep)
- [ ] File passes TypeScript check: `yarn typecheck`
- [ ] File passes linting: `yarn lint` or `eslint:fix`
- [ ] Tests still pass: `yarn testunit`
- [ ] Manual smoke test in browser confirms functionality works

## Migration Tips

### Batch Migration Workflow

1. **Pick a file** from the migration list
2. **Add import and logger** at top of file
3. **Find-and-replace**:
   - `console.log(` → `logger.info(`
   - `console.warn(` → `logger.warn(`
4. **Verify**: Run grep to confirm no console.log/warn remain
5. **Test**: Run typecheck, lint, and relevant tests
6. **Commit**: One file per commit or batch related files

### Handling Edge Cases

**Multiline console statements**:
```typescript
// Before
console.log(
  'Long message with',
  multipleArgs,
  'spanning lines'
);

// After
logger.info(
  'Long message with',
  multipleArgs,
  'spanning lines'
);
```

**Conditional logging**:
```typescript
// Before
if (DEBUG) console.log('Debug info');

// After
if (DEBUG) logger.debug('Debug info');
```

**Template literals**:
```typescript
// Before
console.log(`User ${userId} logged in at ${timestamp}`);

// After
logger.info(`User ${userId} logged in at ${timestamp}`);
// Or better:
logger.info('User %s logged in at %s', userId, timestamp);
```

## Resources

- **Logger source code**: `packages/logger/src/index.ts`
- **Migration plan**: `specs/001-logger-migration/plan.md`
- **Data model**: `specs/001-logger-migration/data-model.md`
- **Research doc**: `specs/001-logger-migration/research.md`

## Questions?

If you encounter issues not covered here:
1. Check the research doc for technical details
2. Review existing Logger usage in server code
3. Consult with the team or maintainers

---

**Last Updated**: 2025-11-05
**Related Feature**: Logger Infrastructure Migration (001-logger-migration)
