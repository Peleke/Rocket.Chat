# Data Model: Logger Infrastructure Migration

**Date**: 2025-11-05
**Purpose**: Define the structure and configuration of Logger instances for the migration

## Logger Instance Schema

### Entity: Logger Instance

Each file in the migration gets exactly ONE Logger instance with this conceptual structure:

```typescript
interface LoggerInstance {
  // Configuration
  name: string;              // Module-specific identifier
  file: string;              // Source file path (for traceability)

  // Usage metrics (for tracking migration progress)
  replacements: {
    console_log: number;     // Count of console.log → logger.info()
    console_warn: number;    // Count of console.warn → logger.warn()
    total: number;           // Total replacements in this file
  };

  // Logger API methods used
  methods: Set<'info' | 'warn' | 'error' | 'debug'>;
}
```

### Naming Strategy

Logger names follow these conventions:

#### Pattern 1: Feature-Based Names
For files implementing a specific feature or module:

| File | Logger Name | Rationale |
|------|-------------|-----------|
| `serviceWorker.ts` | `ServiceWorker` | Direct feature name |
| `VideoConfManager.ts` | `VideoConf` | Shortened but recognizable |
| `VoIPUser.ts` | `VoIP` | Domain-standard abbreviation |
| `RoomManager.ts` | `RoomManager` | Manager pattern clear |
| `queryClient.ts` | `QueryClient` | Direct feature name |

#### Pattern 2: Context-Based Names
For files in specific contexts (hooks, providers, views):

| File | Logger Name | Rationale |
|------|-------------|-----------|
| `useReloadOnError.tsx` | `useReloadOnError` | Hook name describes context |
| `CallProvider.tsx` | `CallProvider` | Provider name is descriptive |
| `useAnalytics.ts` | `useAnalytics` | Hook name describes purpose |
| `AudioMessageRecorder.tsx` | `AudioMessageRecorder` | Component name clear |

#### Pattern 3: Path-Based Names
For files where filename alone isn't distinctive:

| File | Logger Name | Rationale |
|------|-------------|-----------|
| `startup/iframeCommands.ts` | `IframeCommands` | Filename sufficient |
| `startup/callbacks.ts` | `StartupCallbacks` | Path adds context |
| `meteor/minimongo/SynchronousQueue.ts` | `SynchronousQueue` | Filename distinctive |
| `meteor/overrides/oauthRedirectUri.ts` | `OAuthRedirect` | Shortened meaningful name |

### Naming Rules

1. **PascalCase or camelCase**: Match JavaScript/TypeScript conventions
2. **Descriptive**: Name should indicate module purpose
3. **Concise**: Prefer short (1-2 words) but meaningful
4. **No abbreviations**: Unless domain-standard (VoIP, OAuth, LDAP)
5. **Unique**: No two loggers with same name (use path context if needed)

## Per-File Migration Plan

### Complete File Mapping

| # | File | Logger Name | console.log | console.warn | Total |
|---|------|-------------|-------------|--------------|-------|
| 1 | `startup/iframeCommands.ts` | `IframeCommands` | TBD | TBD | TBD |
| 2 | `startup/callbacks.ts` | `StartupCallbacks` | TBD | TBD | TBD |
| 3 | `components/message/content/attachments/file/hooks/useReloadOnError.tsx` | `useReloadOnError` | TBD | TBD | TBD |
| 4 | `lib/RoomManager.ts` | `RoomManager` | TBD | TBD | TBD |
| 5 | `lib/VideoConfManager.ts` | `VideoConf` | 5 | 0 | 5 |
| 6 | `lib/cachedStores/CachedStore.ts` | `CachedStore` | TBD | TBD | TBD |
| 7 | `lib/voip/VoIPUser.ts` | `VoIP` | 9 | 0 | 9 |
| 8 | `lib/voip/LocalStream.ts` | `VoIPLocalStream` | TBD | TBD | TBD |
| 9 | `lib/queryClient.ts` | `QueryClient` | TBD | TBD | TBD |
| 10 | `hooks/useUserCustomFields.ts` | `useUserCustomFields` | TBD | TBD | TBD |
| 11 | `serviceWorker.ts` | `ServiceWorker` | 1 | 0 | 1 |
| 12 | `ecdh.ts` | `ECDH` | TBD | TBD | TBD |
| 13 | `providers/AuthenticationProvider/hooks/useLDAPAndCrowdCollisionWarning.tsx` | `useLDAPAndCrowdCollisionWarning` | TBD | TBD | TBD |
| 14 | `providers/CallProvider/CallProvider.tsx` | `CallProvider` | TBD | TBD | TBD |
| 15 | `apps/RealAppsEngineUIHost.ts` | `RealAppsEngineUIHost` | TBD | TBD | TBD |
| 16 | `apps/gameCenter/GameCenterInvitePlayersModal.tsx` | `GameCenterInvitePlayersModal` | TBD | TBD | TBD |
| 17 | `views/admin/settings/Setting/inputs/CodeSettingInput.stories.tsx` | `CodeSettingInput` | TBD | TBD | TBD |
| 18 | `views/admin/workspace/VersionCard/modals/RegisterWorkspaceSetupModal/RegisterWorkspaceSetupStepTwoModal.tsx` | `RegisterWorkspaceSetup` | TBD | TBD | TBD |
| 19 | `views/audit/hooks/useSendTelemetryMutation.ts` | `useSendTelemetryMutation` | TBD | TBD | TBD |
| 20 | `views/room/body/DropTargetOverlay.tsx` | `DropTargetOverlay` | TBD | TBD | TBD |
| 21 | `views/room/MessageList/hooks/useLoadSurroundingMessages.ts` | `useLoadSurroundingMessages` | TBD | TBD | TBD |
| 22 | `views/room/composer/messageBox/hooks/useMediaPermissions.ts` | `useMediaPermissions` | TBD | TBD | TBD |
| 23 | `views/composer/AudioMessageRecorder/AudioMessageRecorder.tsx` | `AudioMessageRecorder` | TBD | TBD | TBD |
| 24 | `views/root/hooks/useAnalytics.ts` | `useAnalytics` | TBD | TBD | TBD |
| 25 | `views/root/hooks/loggedIn/useWebRTC.ts` | `useWebRTC` | TBD | TBD | TBD |
| 26 | `meteor/minimongo/SynchronousQueue.ts` | `SynchronousQueue` | TBD | TBD | TBD |
| 27 | `meteor/overrides/oauthRedirectUri.ts` | `OAuthRedirect` | TBD | TBD | TBD |

**Total**: 51 replacements across 27 files

**Note**: TBD (To Be Determined) counts will be filled during task execution by examining each file's console usage.

## Implementation Pattern

### Standard Replacement Template

```typescript
// Before migration
console.log('User connected', userId);
console.warn('Rate limit approaching', { limit, current });

// After migration
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('ModuleName');

logger.info('User connected', userId);
logger.warn('Rate limit approaching', { limit, current });
```

### Import Placement

- Add import at top of file (after existing imports)
- Group with other Rocket.Chat package imports if present
- Alphabetize with other imports per project conventions

### Logger Instance Placement

- Declare immediately after imports, before other code
- Use `const` (immutable reference)
- Place at module scope (not inside functions/classes)

```typescript
// Correct placement
import { Meteor } from 'meteor/meteor';
import { Logger } from '@rocket.chat/logger';
import { someUtil } from './utils';

const logger = new Logger('ModuleName');

export function myFunction() {
  logger.info('Function called');
}
```

## Validation Rules

### Per-File Validation

After migrating each file, verify:

1. ✅ Logger import present: `import { Logger } from '@rocket.chat/logger';`
2. ✅ Logger instance created: `const logger = new Logger('...');`
3. ✅ All console.log replaced with logger.info()
4. ✅ All console.warn replaced with logger.warn()
5. ✅ No console.log/warn remain in file
6. ✅ TypeScript compiles: `yarn typecheck` passes
7. ✅ ESLint passes: `yarn lint` or `eslint:fix`

### Global Validation

After all files migrated, verify:

1. ✅ Zero console.log/warn in apps/meteor/client: `grep -r "console\.\(log\|warn\)" apps/meteor/client`
2. ✅ All 27 files have Logger imports
3. ✅ All 51 instances accounted for
4. ✅ Full test suite passes: `yarn testunit`
5. ✅ Build succeeds: `yarn build`

## Traceability

Each Logger instance provides traceability:

- **Logger name** → Identifies which module generated the log
- **Browser console** → Logs appear with logger name prefix
- **Filtering** → Can filter by logger name in browser DevTools
- **Source file** → Logger name maps back to source file via this document

Example browser console output:
```
[ServiceWorker] Reloading to activate
[VoIP] Call started
[VideoConf] Camera access granted
```

## Next Steps

1. ✅ Data model defined (this document)
2. ⏳ Create quickstart.md with developer guide
3. ⏳ Generate tasks.md via `/speckit.tasks`
4. ⏳ Execute migration via `/speckit.implement`

**Data model complete and ready for task generation.**
