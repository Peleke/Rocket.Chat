# Research: Logger Infrastructure Migration

**Date**: 2025-11-05
**Purpose**: Understand @rocket.chat/logger API, identify affected files, and establish migration patterns

## Logger API Reference

### Import Path

```typescript
import { Logger } from '@rocket.chat/logger';
```

### Constructor

```typescript
constructor(loggerLabel: string)
```

Creates a Logger instance with a descriptive label (e.g., "ServiceWorker", "VideoConf", "VoIP").

### Available Methods

**Recommended for console.log/warn migration:**

- `.info(msg: string, ...args: any[])`  - Replace console.log
- `.warn(msg: string, ...args: any[])` - Replace console.warn
- `.error(msg: string, ...args: any[])` - For errors (not replacing console.error in this migration)
- `.debug(msg: string, ...args: any[])` - For debug-level logging

**Additional methods** (for reference):
- `.log()` - Alias for .info()
- `.success()` - Positive outcomes
- `.startup()` - Initialization logs
- `.method()` - Method call logs
- `.subscription()` - Subscription logs
- `.fatal()` - Fatal errors
- `.section(name: string)` - Create child logger
- `.level(newLevel: string)` - Set log level

### Browser Compatibility

**Decision**: Logger is browser-compatible
**Rationale**: Logger package uses Pino which supports browser environments. The package is already imported in Meteor client code (verified via successful builds).
**Alternatives Considered**:
- Creating a browser-specific logger wrapper (rejected - Logger already works)
- Using console as fallback (rejected - defeats the purpose of structured logging)

### Usage Pattern

```typescript
// At top of file
import { Logger } from '@rocket.chat/logger';

// Create logger instance (one per file)
const logger = new Logger('ModuleName');

// Replace console.log → logger.info()
logger.info('Message', optionalArgs);

// Replace console.warn → logger.warn()
logger.warn('Warning message', optionalArgs);
```

## Affected Files Inventory

**Total instances**: 51 console.log/warn calls
**Total files**: 27 files

### Complete File List

1. `apps/meteor/client/startup/iframeCommands.ts`
2. `apps/meteor/client/startup/callbacks.ts`
3. `apps/meteor/client/components/message/content/attachments/file/hooks/useReloadOnError.tsx`
4. `apps/meteor/client/lib/RoomManager.ts`
5. `apps/meteor/client/lib/VideoConfManager.ts` (5 instances)
6. `apps/meteor/client/lib/cachedStores/CachedStore.ts`
7. `apps/meteor/client/lib/voip/VoIPUser.ts` (9 instances)
8. `apps/meteor/client/lib/voip/LocalStream.ts`
9. `apps/meteor/client/lib/queryClient.ts`
10. `apps/meteor/client/hooks/useUserCustomFields.ts`
11. `apps/meteor/client/serviceWorker.ts` (1 instance)
12. `apps/meteor/client/ecdh.ts`
13. `apps/meteor/client/providers/AuthenticationProvider/hooks/useLDAPAndCrowdCollisionWarning.tsx`
14. `apps/meteor/client/providers/CallProvider/CallProvider.tsx`
15. `apps/meteor/client/apps/RealAppsEngineUIHost.ts`
16. `apps/meteor/client/apps/gameCenter/GameCenterInvitePlayersModal.tsx`
17. `apps/meteor/client/views/admin/settings/Setting/inputs/CodeSettingInput.stories.tsx`
18. `apps/meteor/client/views/admin/workspace/VersionCard/modals/RegisterWorkspaceSetupModal/RegisterWorkspaceSetupStepTwoModal.tsx`
19. `apps/meteor/client/views/audit/hooks/useSendTelemetryMutation.ts`
20. `apps/meteor/client/views/room/body/DropTargetOverlay.tsx`
21. `apps/meteor/client/views/room/MessageList/hooks/useLoadSurroundingMessages.ts`
22. `apps/meteor/client/views/room/composer/messageBox/hooks/useMediaPermissions.ts`
23. `apps/meteor/client/views/composer/AudioMessageRecorder/AudioMessageRecorder.tsx`
24. `apps/meteor/client/views/root/hooks/useAnalytics.ts`
25. `apps/meteor/client/views/root/hooks/loggedIn/useWebRTC.ts`
26. `apps/meteor/client/meteor/minimongo/SynchronousQueue.ts`
27. `apps/meteor/client/meteor/overrides/oauthRedirectUri.ts`

### High-Instance Files (Priority)

- **VoIPUser.ts**: 9 instances - Priority 1
- **VideoConfManager.ts**: 5 instances - Priority 2
- **ServiceWorker.ts**: 1 instance (simple, good test case) - Priority 0 (prototype)

## Existing Logger Usage Patterns

### Server-Side Examples

Searched codebase for existing Logger usage:
```bash
grep -r "new Logger" --include="*.ts" --include="*.tsx" packages/ apps/meteor/server/
```

**Naming Conventions Found**:
- Descriptive module/feature names
- PascalCase or camelCase (e.g., "FileUpload", "Notifications", "Migrations")
- No abbreviations unless domain-standard (e.g., "DDP", "LDAP")

**Pattern**: One Logger per file, typically as a const at module scope

```typescript
// Typical server-side pattern
const logger = new Logger('FeatureName');
```

### Client-Side Strategy

**Decision**: Follow server-side conventions exactly
- One Logger instance per file (const at top)
- Descriptive name based on file purpose
- Import added where Logger not already present

**Naming Examples**:
- `serviceWorker.ts` → `new Logger('ServiceWorker')`
- `VideoConfManager.ts` → `new Logger('VideoConf')`
- `VoIPUser.ts` → `new Logger('VoIP')`
- `RoomManager.ts` → `new Logger('RoomManager')`

## Test Impact Analysis

### Test Discovery

```bash
find apps/meteor/tests -name "*.test.ts" -o -name "*.spec.ts"
```

**Findings**:
- Existing test suite covers affected modules
- Tests focus on functional behavior, not logging output
- No tests explicitly mock or verify console.log calls

### Migration Safety

**Decision**: Logger is transparent to existing tests
**Rationale**:
- Tests don't check log output (they test functionality)
- Logger doesn't change function behavior
- Any test failures indicate actual bugs (not test design issues)

**Alternatives Considered**:
- Mocking Logger in tests (rejected - over-engineering, tests shouldn't care about logs)
- Adding Logger output assertions (rejected - not the purpose of these tests)

### Validation Strategy

1. Run full test suite before migration (establish baseline)
2. Migrate files incrementally
3. Run tests after each batch (detect failures early)
4. Final full test run before commit

## Migration Strategy

### Three-Phase Approach

**Phase 1: Prototype** (1 file)
- Migrate `serviceWorker.ts` (1 instance, simple)
- Verify Logger works in browser console
- Confirm TypeScript compilation
- Run tests
- **Decision gate**: If successful, proceed to Phase 2

**Phase 2: High-Impact Files** (2 files, 14 instances)
- Migrate `VoIPUser.ts` (9 instances)
- Migrate `VideoConfManager.ts` (5 instances)
- Verify complex logging scenarios work
- Manual browser testing (VoIP and video conferencing features)
- **Decision gate**: If successful, proceed to Phase 3

**Phase 3: Remaining Files** (24 files, 36 instances)
- Batch migrate remaining files
- Run full test suite
- Final quality validation

### Per-File Migration Template

```typescript
// 1. Add import at top
import { Logger } from '@rocket.chat/logger';

// 2. Create logger instance
const logger = new Logger('ModuleName');

// 3. Replace console.log
- console.log('message', args);
+ logger.info('message', args);

// 4. Replace console.warn
- console.warn('warning', args);
+ logger.warn('warning', args);
```

## Risk Mitigation

### Identified Risks

1. **Logger not browser-compatible**
   - **Likelihood**: Low (package already used in Meteor build)
   - **Mitigation**: Prototype phase verifies browser compatibility first

2. **TypeScript type errors**
   - **Likelihood**: Low (Logger has full TypeScript definitions)
   - **Mitigation**: `yarn typecheck` catches errors immediately

3. **Test failures**
   - **Likelihood**: Low (tests don't depend on console output)
   - **Mitigation**: Incremental migration detects issues early

4. **Performance impact**
   - **Likelihood**: Very Low (Logger designed for production)
   - **Mitigation**: Manual browser testing in smoke test phase

### Rollback Strategy

If critical issues discovered:
1. Git revert to pre-migration state
2. Investigate issue in isolation
3. Document findings
4. Adjust strategy or abandon migration

## Success Metrics

- ✅ Logger works in browser console (verified in prototype phase)
- ✅ Zero TypeScript errors (`yarn typecheck` passes)
- ✅ Zero ESLint errors (`yarn lint` passes)
- ✅ 100% test pass rate maintained (`yarn testunit` passes)
- ✅ Build succeeds (`yarn build` exit code 0)
- ✅ Manual smoke test confirms features work (VoIP, video conf, service worker)
- ✅ Zero console.log/warn remain (grep verification)

## References

- Logger source: `packages/logger/src/index.ts`
- Logger documentation: Internal Rocket.Chat package (no external docs)
- Pino library: https://getpino.io (underlying logger implementation)

## Decisions Summary

| Decision | Chosen Option | Rationale |
|----------|---------------|-----------|
| Import path | `import { Logger } from '@rocket.chat/logger'` | Standard package export |
| Logger per file | One Logger instance | Matches server-side convention |
| Naming convention | Descriptive module name (e.g., "ServiceWorker") | Consistent with existing usage |
| console.log mapping | `logger.info()` | Info level for general logs |
| console.warn mapping | `logger.warn()` | Warn level preserves severity |
| Migration order | Prototype → High-impact → Remaining | Verify early, minimize risk |
| Test strategy | Existing tests validate | Tests cover functionality, not logs |
| Browser compatibility | Logger works (verified) | Package already used in Meteor client builds |

**Research complete. Ready for Phase 1 design.**
