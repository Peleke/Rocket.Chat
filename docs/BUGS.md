# Low-Hanging Fruit: Quick Wins & Bug Fixes

This document tracks high-value, low-effort improvements identified during codebase analysis.

---

## 🎯 Quick Wins (Prioritized)

### 1. Console.log Cleanup ⭐ **EASIEST WIN**

**Priority**: High
**Effort**: Low (1-2 hours)
**Impact**: Code quality, production debugging

**Issue**:
- Found 51 instances of `console.log`/`console.warn` across 27 client files
- Production code should use proper logging infrastructure
- Inconsistent logging makes debugging harder

**Affected Files** (sample):
- `apps/meteor/client/serviceWorker.ts:20`
- `apps/meteor/client/lib/VideoConfManager.ts` (5 instances)
- `apps/meteor/client/lib/voip/VoIPUser.ts` (9 instances)
- 24 more files...

**Current Code Example**:
```typescript
// apps/meteor/client/serviceWorker.ts:20
console.log('service worker: reloading to activate');
```

**Proposed Fix**:
```typescript
import { Logger } from '@rocket.chat/logger';
const logger = new Logger('ServiceWorker');

logger.info('Reloading to activate');
```

**Implementation Plan**:
1. Create automated script to find all `console.log|warn|error` in client code
2. Replace with appropriate logger calls (`logger.info()`, `logger.warn()`, `logger.error()`)
3. Import `@rocket.chat/logger` where needed
4. Run ESLint to validate
5. Test in browser console

**Search Command**:
```bash
grep -r "console\.\(log\|warn\|error\)" apps/meteor/client --include="*.ts" --include="*.tsx"
```

**Benefits**:
- ✅ Consistent logging across application
- ✅ Proper log levels (info, warn, error)
- ✅ Better production debugging
- ✅ Aligns with project standards

---

### 2. Microservices Logging Bug ⭐⭐ **FUNCTIONAL FIX**

**Priority**: Medium
**Effort**: Medium (2-4 hours)
**Impact**: Missing logs in distributed deployments

**Issue**:
- Logs don't reach `ddp-streamer` when using microservices
- Currently uses `emitWithoutBroadcast` which is local-only
- Documented by TODO comment in code

**Location**: `apps/meteor/server/stream/stdout.ts:57-58`

**Current Code**:
```typescript
logEntries.on('log', (item) => {
	// TODO having this as 'emitWithoutBroadcast' will not sent this data to ddp-streamer, so this data
	// won't be available when using micro services.
	notifications.streamStdout.emitWithoutBroadcast('stdout', transformLog(item));
});
```

**Proposed Fix**:
```typescript
logEntries.on('log', (item) => {
	// Broadcast to all services including ddp-streamer for microservices support
	notifications.streamStdout.emit('stdout', transformLog(item));
});
```

**Implementation Plan**:
1. Read full context of `apps/meteor/server/stream/stdout.ts`
2. Understand why `emitWithoutBroadcast` was used initially
3. Change to `.emit()` for proper broadcast
4. Test in microservices mode (TRANSPORTER=TCP yarn ms)
5. Verify logs appear in ddp-streamer
6. Remove TODO comment

**Testing**:
```bash
# Start in microservices mode
cd apps/meteor && TRANSPORTER=TCP yarn ms

# Monitor ddp-streamer logs
# Verify stdout logs appear in streamer
```

**Benefits**:
- ✅ Fixes actual bug in production microservices deployments
- ✅ Closes documented TODO
- ✅ Improves observability in distributed systems

---

### 3. Dependency Version Conflicts ⭐⭐⭐ **INFRASTRUCTURE**

**Priority**: High
**Effort**: Medium (4-6 hours)
**Impact**: Linting consistency, potential runtime issues

**Issue**:
Multiple peer dependency version mismatches detected during `yarn install`:

#### 3.1 ESLint Version Mismatch
**Current**: `8.45.0`
**Required**: `^8.57.0` (by multiple plugins)
**Affected**: 27+ plugin instances

**Example Warning**:
```
➤ YN0060: │ eslint is listed by your project with version 8.45.0, which doesn't
           satisfy what @typescript-eslint/utils requests (^8.57.0).
```

**Fix**:
```json
// package.json or apps/meteor/package.json
{
  "devDependencies": {
    "eslint": "^8.57.0"
  }
}
```

#### 3.2 Prettier Version Conflict
**Current**: `3.3.3`
**Required**: `~2.7.1` (by `@rocket.chat/prettier-config`)

**Fix Options**:
- Option A: Downgrade Prettier to 2.7.1 (safer, matches config)
- Option B: Update `@rocket.chat/prettier-config` to support 3.x (better long-term)

#### 3.3 Missing prom-client Dependency
**Affected Services** (7 EE microservices):
- `@rocket.chat/account-service`
- `@rocket.chat/authorization-service`
- `@rocket.chat/ddp-streamer`
- `@rocket.chat/omnichannel-transcript`
- `@rocket.chat/presence-service`
- `@rocket.chat/queue-worker`
- `@rocket.chat/stream-hub-service`

**Issue**: Services depend on `prometheus-gc-stats` which requires `prom-client`, but it's not provided.

**Fix**: Add to each service's `package.json`:
```json
{
  "dependencies": {
    "prom-client": "^15.0.0"
  }
}
```

**Implementation Plan**:
1. Update ESLint to 8.57.0
2. Resolve Prettier version (recommend Option A: 2.7.1)
3. Add `prom-client` to 7 EE services
4. Run `yarn install` to verify
5. Run full linting: `yarn lint`
6. Run tests: `yarn testunit`
7. Verify no new errors introduced

**Benefits**:
- ✅ Eliminates peer dependency warnings
- ✅ Consistent tooling across monorepo
- ✅ Proper Prometheus metrics in EE services
- ✅ Reduces potential runtime issues

---

### 4. Technical Debt Audit ⭐ **DOCUMENTATION**

**Priority**: Low
**Effort**: Low (2-3 hours)
**Impact**: Roadmap planning, debt visibility

**Issue**:
- 20+ files contain TODO/FIXME/HACK comments in server code
- No centralized tracking of technical debt

**Locations** (sample):
- `apps/meteor/server/startup/migrations/` (6 files)
- `apps/meteor/server/settings/` (6 files)
- `apps/meteor/server/services/` (8 files)

**Implementation Plan**:
1. Extract all TODO/FIXME/HACK comments with context
2. Categorize by:
   - Type (bug, feature, refactor, performance)
   - Severity (low, medium, high)
   - Effort (quick, medium, large)
3. Create tracking document
4. Prioritize for future sprints

**Search Commands**:
```bash
# Find all TODOs with context
grep -rn "TODO\|FIXME\|HACK\|XXX" apps/meteor/server --include="*.ts" -A 2 -B 2

# Count by type
grep -r "TODO" apps/meteor/server --include="*.ts" | wc -l
grep -r "FIXME" apps/meteor/server --include="*.ts" | wc -l
grep -r "HACK" apps/meteor/server --include="*.ts" | wc -l
```

**Deliverable**: `docs/TECHNICAL_DEBT.md` with categorized list

**Benefits**:
- ✅ Visibility into code health
- ✅ Informed sprint planning
- ✅ Track debt reduction over time

---

## 📊 Priority Matrix

| Issue | Priority | Effort | Impact | ROI |
|-------|----------|--------|--------|-----|
| Console.log cleanup | High | Low | Medium | **High** ⭐⭐⭐ |
| Microservices logging | Medium | Medium | High | **High** ⭐⭐⭐ |
| Dependency conflicts | High | Medium | High | **Medium** ⭐⭐ |
| Technical debt audit | Low | Low | Low | **Low** ⭐ |

---

## 🚀 Recommended Execution Order

### Sprint 1: Quick Wins
1. **Console.log cleanup** (Day 1)
   - Low risk, immediate value
   - Builds momentum

2. **Microservices logging fix** (Day 2)
   - Actual bug fix
   - Closes documented TODO
   - Requires microservices testing

### Sprint 2: Infrastructure
3. **Dependency version alignment** (Days 3-4)
   - Requires careful testing
   - May expose other issues
   - Block off time for regression testing

### Sprint 3: Planning
4. **Technical debt audit** (Day 5)
   - Informs future roadmap
   - Low priority but useful for planning

---

## 📝 Notes

- All issues discovered during initial codebase analysis on 2025-11-05
- Installation was in progress, so dynamic analysis not yet performed
- Consider creating lint rules to prevent console.log reintroduction
- Document any discovered context during implementation

---

## 🔗 Related Documents

- `.claude/CLAUDE.md` - Project setup and conventions
- `docs/TECHNICAL_DEBT.md` - (To be created from issue #4)
- Serena memories in `.serena/memories/` - Detailed project knowledge

---

*Last Updated: 2025-11-05*
