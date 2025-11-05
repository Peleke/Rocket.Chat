# Implementation Plan: Logger Infrastructure Migration

**Branch**: `001-logger-migration` | **Date**: 2025-11-05 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-logger-migration/spec.md`
**User Constraint**: "application should run as it does currently with all 51 instances replaced; all tests must remain passing"

## Summary

Replace 51 instances of console.log/console.warn across 27 client files with proper @rocket.chat/logger infrastructure. This is a code quality improvement with zero functional changes—the application behaves identically, but logs are now structured, filterable, and aligned with Rocket.Chat standards.

**Technical Approach**: Systematic find-and-replace with Logger imports added per file. Each module gets a named Logger instance. Existing tests validate no behavioral changes occurred.

## Technical Context

**Language/Version**: TypeScript 5.9.3 (strict mode)
**Primary Dependencies**: @rocket.chat/logger (existing), Meteor.js, React
**Storage**: N/A (logging infrastructure only)
**Testing**: Jest (unit tests), Playwright (E2E), existing test suite must remain at 100% pass rate
**Target Platform**: Browser (client-side code in apps/meteor/client)
**Project Type**: Monorepo (Yarn 4 + Turborepo) - modifying existing files only, no new structure
**Performance Goals**: Minimal overhead (< 1ms per log call), no user-perceptible impact
**Constraints**:
- Zero functional changes (user constraint: "application should run as it does currently")
- 100% test pass rate maintained (user constraint: "all tests must remain passing")
- TypeScript strict mode compliance
- ESLint/Prettier compliance (tabs, 140 chars, single quotes)
**Scale/Scope**: 51 call sites across 27 files (precisely scoped, low complexity)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Principle I: Upstream Standards Compliance ✅

- **TypeScript Strict Mode**: Using existing @rocket.chat/logger types, no `any` needed
- **Code Style**: Will maintain tabs, 140 chars, single quotes via automated tools
- **Prettier/ESLint**: Changes will pass linting before commit
- **Testing**: Existing tests validate no functional changes
- **Architecture**: Following existing pattern (Logger already used server-side)

**Status**: PASS - Using established Rocket.Chat Logger infrastructure exactly as intended

### Principle II: Quality-First Development ✅

- **Type Safety**: @rocket.chat/logger has full TypeScript definitions
- **Lint Compliance**: ESLint will be run and auto-fixed if needed
- **Test Coverage**: Existing tests cover affected code paths, must maintain 100% pass
- **Build Verification**: yarn build must succeed before merge

**Status**: PASS - All quality gates will be validated before completion

### Principle III: Minimal Scope & Evidence-Based Changes ✅

- **MVP First**: This IS the MVP - pure refactoring, no feature additions
- **No Speculation**: Scope precisely defined (51 instances, 27 files from grep search)
- **Evidence-Based**: All claims verifiable (file list from grep, test results, build output)
- **Scope Discipline**: Explicitly excluding console.error, server-side, infrastructure changes

**Status**: PASS - Textbook minimal scope, zero feature creep

### Principle IV: Systematic Testing & Validation ✅

Pre-commit checklist will verify:
1. ✅ yarn typecheck (zero errors)
2. ✅ yarn lint (zero errors, eslint:fix used)
3. ✅ yarn testunit (100% pass rate)
4. ✅ yarn build (successful)
5. ✅ Manual smoke test (service worker, video conf, VoIP functional)

**Status**: PASS - Full validation workflow defined

### Principle V: Documentation & Traceability ✅

- **Commit Messages**: Will follow conventional commits (refactor: replace console.log with Logger)
- **Implementation Docs**: This plan + research.md document decisions
- **SpecKit Artifacts**: Complete spec/plan/tasks chain
- **Code Comments**: Logger instance names document module context

**Status**: PASS - Full traceability maintained

**OVERALL GATE**: ✅ PASS - All 5 principles satisfied, no violations requiring justification

## Project Structure

### Documentation (this feature)

```text
specs/001-logger-migration/
├── spec.md              # Feature specification (completed)
├── plan.md              # This file (/speckit.plan output)
├── research.md          # Phase 0: Logger API usage patterns
├── data-model.md        # Phase 1: Logger instance schema
├── quickstart.md        # Phase 1: Developer guide for Logger usage
├── contracts/           # Phase 1: N/A (no API contracts for logging)
├── checklists/
│   └── requirements.md  # Spec quality validation (completed)
└── tasks.md             # Phase 2: /speckit.tasks output (NOT YET CREATED)
```

### Source Code (repository root)

**Existing Monorepo Structure** (no changes to layout):

```text
apps/meteor/client/
├── serviceWorker.ts                    # 1 instance to replace
├── lib/
│   ├── VideoConfManager.ts             # 5 instances to replace
│   └── voip/VoIPUser.ts                # 9 instances to replace
├── views/                              # Multiple files affected
├── components/                         # Multiple files affected
└── [22 additional files...]            # Remaining affected files

packages/
└── logger/                             # Existing @rocket.chat/logger package (NO CHANGES)
```

**Structure Decision**: No new directories or files created. This is an in-place refactoring of existing client code. The @rocket.chat/logger package already exists and is used server-side. We're extending its usage to client code.

## Complexity Tracking

> **No complexity violations** - This plan adheres to all constitution principles without exceptions.

## Phase 0: Research & Investigation

**Objective**: Understand @rocket.chat/logger API and identify all affected files

### Research Tasks

1. **Logger API Documentation**
   - Read @rocket.chat/logger package source to understand:
     - Constructor signature: `new Logger(name: string)`
     - Available methods: `.info()`, `.warn()`, `.error()`, `.debug()`
     - Import path: `import { Logger } from '@rocket.chat/logger';`
     - Browser compatibility and initialization

2. **Affected Files Inventory**
   - Run grep to generate complete list of 27 affected files:
     ```bash
     grep -r "console\.\(log\|warn\)" apps/meteor/client --include="*.ts" --include="*.tsx" -l
     ```
   - Document each file with instance count for task estimation

3. **Existing Logger Usage Patterns**
   - Search for existing Logger usage in codebase:
     ```bash
     grep -r "new Logger" --include="*.ts" --include="*.tsx"
     ```
   - Document naming conventions (e.g., "ServiceWorker", "VideoConf", "VoIP")
   - Understand server-side patterns to replicate on client-side

4. **Test Impact Analysis**
   - Identify tests covering affected files:
     ```bash
     find apps/meteor/tests -name "*.test.ts" -o -name "*.spec.ts"
     ```
   - Verify no tests explicitly check for console.log output
   - Confirm Logger doesn't break existing mocking/testing patterns

**Deliverable**: `research.md` with Logger API reference, complete file list, usage patterns, and test strategy

## Phase 1: Design & Data Model

**Prerequisites**: research.md complete

### 1. Data Model

**Entity**: Logger Instance (per-file configuration)

```typescript
// Conceptual model (not implementation)
interface LoggerInstance {
  name: string;              // Module name (e.g., "ServiceWorker", "VideoConf")
  file: string;              // Source file path for traceability
  instanceCount: number;     // Number of console.log calls replaced
  methods: {
    info: number;            // Count of .info() calls
    warn: number;            // Count of .warn() calls
    error: number;           // Count of .error() calls
  };
}
```

**Rationale**: Each file gets ONE Logger instance with a descriptive name. All console.log/warn in that file are replaced with logger.info()/logger.warn().

**Deliverable**: `data-model.md` documenting Logger instance schema and per-file naming strategy

### 2. API Contracts

**N/A** - This feature has no external API contracts. Logger is an internal infrastructure concern with no public interface changes.

### 3. Developer Quickstart

**Deliverable**: `quickstart.md` with:
- How to import and create a Logger instance
- Mapping console.log → logger.info(), console.warn → logger.warn()
- Example before/after code snippets
- Testing guidance (how to verify logs in browser console)
- Troubleshooting common issues (missing imports, type errors)

### 4. Agent Context Update

Run `.specify/scripts/bash/update-agent-context.sh claude` to update `.claude/CLAUDE.md` with:
- Logger migration in progress (tracked via this spec)
- Reminder: Use @rocket.chat/logger for all new client code
- No new technologies added (Logger already exists)

## Phase 2: Task Generation (NOT EXECUTED BY THIS COMMAND)

**Note**: Task generation happens via `/speckit.tasks` command after planning is complete.

**Expected Task Structure**:
- **Task 1**: Research Logger API and generate file inventory (Phase 0 execution)
- **Task 2-28**: Replace console.log/warn in each of the 27 affected files (one task per file)
- **Task 29**: Run full quality validation (typecheck, lint, tests, build)
- **Task 30**: Manual smoke test and documentation update

## Post-Design Constitution Re-Check

*Re-evaluating principles after Phase 1 design completion:*

### Principle I: Upstream Standards Compliance ✅
- Logger usage follows existing server-side patterns
- No deviations from TypeScript/ESLint/Prettier conventions

### Principle II: Quality-First Development ✅
- Design maintains type safety (Logger has full TypeScript support)
- No quality gate violations introduced

### Principle III: Minimal Scope & Evidence-Based Changes ✅
- Design remains minimal (one Logger per file, direct console replacement)
- No scope creep detected

### Principle IV: Systematic Testing & Validation ✅
- Existing tests cover validation
- Manual smoke test plan defined

### Principle V: Documentation & Traceability ✅
- Complete documentation chain: spec → plan → research → data-model → quickstart → tasks
- Commit message strategy defined

**FINAL GATE**: ✅ PASS - Design maintains all principle compliance

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Logger unavailable in browser | Low | High | Verify Logger works client-side in research phase |
| Type errors in strict mode | Low | Medium | Logger has TypeScript definitions, will be caught by typecheck |
| Test failures from logging changes | Low | Medium | Existing tests don't mock console, Logger should be transparent |
| Performance degradation | Very Low | Low | Logger designed for production, minimal overhead |
| Missing Logger imports | Medium | Low | ESLint will catch undefined Logger, easy fix |

**Highest Risk**: Verifying Logger works in browser environment (server package might not be browser-compatible). **Mitigation**: Research phase will test Logger in browser console before bulk replacement.

## Success Criteria Validation

Mapping spec success criteria to plan:

- **SC-001**: All 51 instances replaced → Phase 2 tasks ensure complete coverage
- **SC-002**: Zero console.log remain → Grep verification task in Phase 2
- **SC-003**: Typecheck passes → Quality validation task (Task 29)
- **SC-004**: Lint passes → Quality validation task (Task 29)
- **SC-005**: 100% test pass rate → Quality validation task (Task 29)
- **SC-006**: Build succeeds → Quality validation task (Task 29)
- **SC-007**: Manual smoke test → Smoke test task (Task 30)
- **SC-008**: Proper logger formatting → Browser console verification in smoke test

**All success criteria have clear validation tasks in the plan.**

## Next Steps

1. ✅ Planning complete (this document)
2. ⏳ Execute Phase 0: Run research tasks to generate `research.md`
3. ⏳ Execute Phase 1: Generate `data-model.md` and `quickstart.md`
4. ⏳ Update agent context via update-agent-context.sh
5. ⏳ Run `/speckit.tasks` to generate task breakdown
6. ⏳ Run `/speckit.implement` to execute tasks with validation

**Planning Status**: ✅ Complete and ready for task generation
