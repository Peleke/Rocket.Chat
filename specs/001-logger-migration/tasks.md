# Tasks: Logger Infrastructure Migration

**Input**: Design documents from `/specs/001-logger-migration/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: No dedicated test tasks - existing test suite validates no behavioral changes occurred

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Monorepo structure**: `apps/meteor/client/`, `packages/logger/`
- All tasks modify existing files - no new directories created
- Paths shown below are relative to repository root

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify Logger infrastructure and establish baseline

- [ ] T001 Verify @rocket.chat/logger is available and importable in client code
- [ ] T002 [P] Run baseline test suite to establish 100% pass rate (`yarn testunit`)
- [ ] T003 [P] Run baseline typecheck to verify clean state (`yarn typecheck`)
- [ ] T004 [P] Run baseline lint to verify clean state (`yarn lint`)
- [ ] T005 [P] Run baseline build to verify success (`yarn build`)

**Checkpoint**: Baseline established - migration can begin

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Prototype phase - verify Logger works in browser before bulk migration

**⚠️ CRITICAL**: This phase MUST complete successfully before proceeding to user stories

- [ ] T006 Migrate prototype file: `apps/meteor/client/serviceWorker.ts` (1 instance)
  - Add Logger import
  - Create logger instance with name "ServiceWorker"
  - Replace console.log with logger.info()
- [ ] T007 Test prototype in browser console
  - Start development server: `cd apps/meteor && meteor`
  - Open browser DevTools
  - Verify Logger output appears with format: `[ServiceWorker] message`
  - Confirm log is filterable and formatted correctly
- [ ] T008 Run quality validation on prototype
  - `yarn typecheck` - verify zero TypeScript errors
  - `yarn lint` - verify zero linting errors
  - `yarn testunit` - verify 100% test pass rate maintained
  - `yarn build` - verify successful build

**Decision Gate**: If prototype succeeds → proceed to user stories. If fails → investigate and fix before continuing.

**Checkpoint**: Logger verified browser-compatible - bulk migration approved

---

## Phase 3: User Story 1 - Consistent Debug Logging for Developers (Priority: P1) 🎯 MVP

**Goal**: Developers can use structured, filterable logs instead of scattered console.log calls

**Independent Test**: Browse to affected features in browser, verify all logs appear with Logger format (`[ModuleName] message`), confirm logs are filterable by module name

### High-Impact Files (14 instances)

- [ ] T009 [P] [US1] Migrate `apps/meteor/client/lib/voip/VoIPUser.ts` (9 instances)
  - Import Logger
  - Create logger: `new Logger('VoIP')`
  - Replace 9 console.log calls with logger.info()
- [ ] T010 [P] [US1] Migrate `apps/meteor/client/lib/VideoConfManager.ts` (5 instances)
  - Import Logger
  - Create logger: `new Logger('VideoConf')`
  - Replace 5 console.log calls with logger.info()
- [ ] T011 [US1] Validate high-impact files
  - Manual browser test: VoIP functionality (make test call)
  - Manual browser test: Video conferencing (start video call)
  - Verify logs appear in console with proper formatting
  - `yarn typecheck && yarn lint && yarn testunit`

### Remaining Client Files (Batch 1: Core Infrastructure - 8 files)

- [ ] T012 [P] [US1] Migrate `apps/meteor/client/lib/RoomManager.ts`
- [ ] T013 [P] [US1] Migrate `apps/meteor/client/lib/cachedStores/CachedStore.ts`
- [ ] T014 [P] [US1] Migrate `apps/meteor/client/lib/voip/LocalStream.ts` (create logger: `new Logger('VoIPLocalStream')`)
- [ ] T015 [P] [US1] Migrate `apps/meteor/client/lib/queryClient.ts` (create logger: `new Logger('QueryClient')`)
- [ ] T016 [P] [US1] Migrate `apps/meteor/client/ecdh.ts` (create logger: `new Logger('ECDH')`)
- [ ] T017 [P] [US1] Migrate `apps/meteor/client/startup/iframeCommands.ts` (create logger: `new Logger('IframeCommands')`)
- [ ] T018 [P] [US1] Migrate `apps/meteor/client/startup/callbacks.ts` (create logger: `new Logger('StartupCallbacks')`)
- [ ] T019 [P] [US1] Migrate `apps/meteor/client/meteor/minimongo/SynchronousQueue.ts` (create logger: `new Logger('SynchronousQueue')`)
- [ ] T020 [US1] Validate core infrastructure batch
  - `yarn typecheck && yarn lint`
  - `yarn testunit` (verify 100% pass rate)

### Remaining Client Files (Batch 2: Hooks - 5 files)

- [ ] T021 [P] [US1] Migrate `apps/meteor/client/hooks/useUserCustomFields.ts` (create logger: `new Logger('useUserCustomFields')`)
- [ ] T022 [P] [US1] Migrate `apps/meteor/client/views/room/MessageList/hooks/useLoadSurroundingMessages.ts` (create logger: `new Logger('useLoadSurroundingMessages')`)
- [ ] T023 [P] [US1] Migrate `apps/meteor/client/views/room/composer/messageBox/hooks/useMediaPermissions.ts` (create logger: `new Logger('useMediaPermissions')`)
- [ ] T024 [P] [US1] Migrate `apps/meteor/client/views/root/hooks/useAnalytics.ts` (create logger: `new Logger('useAnalytics')`)
- [ ] T025 [P] [US1] Migrate `apps/meteor/client/views/root/hooks/loggedIn/useWebRTC.ts` (create logger: `new Logger('useWebRTC')`)
- [ ] T026 [US1] Validate hooks batch
  - `yarn typecheck && yarn lint`
  - `yarn testunit`

### Remaining Client Files (Batch 3: Providers & Components - 6 files)

- [ ] T027 [P] [US1] Migrate `apps/meteor/client/providers/AuthenticationProvider/hooks/useLDAPAndCrowdCollisionWarning.tsx` (create logger: `new Logger('useLDAPAndCrowdCollisionWarning')`)
- [ ] T028 [P] [US1] Migrate `apps/meteor/client/providers/CallProvider/CallProvider.tsx` (create logger: `new Logger('CallProvider')`)
- [ ] T029 [P] [US1] Migrate `apps/meteor/client/components/message/content/attachments/file/hooks/useReloadOnError.tsx` (create logger: `new Logger('useReloadOnError')`)
- [ ] T030 [P] [US1] Migrate `apps/meteor/client/views/room/body/DropTargetOverlay.tsx` (create logger: `new Logger('DropTargetOverlay')`)
- [ ] T031 [P] [US1] Migrate `apps/meteor/client/views/composer/AudioMessageRecorder/AudioMessageRecorder.tsx` (create logger: `new Logger('AudioMessageRecorder')`)
- [ ] T032 [P] [US1] Migrate `apps/meteor/client/views/audit/hooks/useSendTelemetryMutation.ts` (create logger: `new Logger('useSendTelemetryMutation')`)
- [ ] T033 [US1] Validate providers & components batch
  - `yarn typecheck && yarn lint`
  - `yarn testunit`

### Remaining Client Files (Batch 4: Apps & Admin - 5 files)

- [ ] T034 [P] [US1] Migrate `apps/meteor/client/apps/RealAppsEngineUIHost.ts` (create logger: `new Logger('RealAppsEngineUIHost')`)
- [ ] T035 [P] [US1] Migrate `apps/meteor/client/apps/gameCenter/GameCenterInvitePlayersModal.tsx` (create logger: `new Logger('GameCenterInvitePlayersModal')`)
- [ ] T036 [P] [US1] Migrate `apps/meteor/client/views/admin/settings/Setting/inputs/CodeSettingInput.stories.tsx` (create logger: `new Logger('CodeSettingInput')`)
- [ ] T037 [P] [US1] Migrate `apps/meteor/client/views/admin/workspace/VersionCard/modals/RegisterWorkspaceSetupModal/RegisterWorkspaceSetupStepTwoModal.tsx` (create logger: `new Logger('RegisterWorkspaceSetup')`)
- [ ] T038 [P] [US1] Migrate `apps/meteor/client/meteor/overrides/oauthRedirectUri.ts` (create logger: `new Logger('OAuthRedirect')`)
- [ ] T039 [US1] Validate apps & admin batch
  - `yarn typecheck && yarn lint`
  - `yarn testunit`

### US1 Final Validation

- [ ] T040 [US1] Verify zero console.log/warn remain in client code
  - Run: `grep -r "console\.\(log\|warn\)" apps/meteor/client --include="*.ts" --include="*.tsx"`
  - Expected: No matches found
- [ ] T041 [US1] Run full quality validation
  - `yarn typecheck` - zero TypeScript errors
  - `yarn lint` - zero linting errors (run `eslint:fix` if needed)
  - `yarn testunit` - 100% test pass rate
  - `yarn build` - successful build (exit code 0)
- [ ] T042 [US1] Manual smoke test
  - Service worker: Force refresh, verify reload message in console
  - VoIP: Make test call, verify VoIP logs appear
  - Video conferencing: Start video call, verify VideoConf logs appear
  - Verify all logs show Logger format: `[ModuleName] message`

**US1 Success Criteria**: ✅ All 51 console.log/warn replaced, tests passing, features working, logs properly formatted

---

## Phase 4: User Story 2 - Production Log Management (Priority: P2)

**Goal**: System administrators can control client logging levels and filter by module for production troubleshooting

**Independent Test**: Configure logger levels via Rocket.Chat admin settings (if available), verify log output changes accordingly in browser console

**Note**: This story focuses on verifying existing Logger configuration capabilities work with client-side usage

- [ ] T043 [US2] Document Logger level configuration for client code
  - Verify how to configure client-side logger levels (if configurable)
  - Document in quickstart.md or create separate admin guide
  - Test changing log levels and verifying output in browser
- [ ] T044 [US2] Verify production logging behavior
  - Test Logger in production-like environment (minified build)
  - Confirm Logger output is appropriate for production (not overly verbose)
  - Verify performance overhead is minimal (< 1ms per call)
  - Document findings in research.md or create production-logging.md

**US2 Success Criteria**: ✅ Logger configuration documented, production behavior verified acceptable

---

## Phase 5: User Story 3 - Log Aggregation and Analysis (Priority: P3)

**Goal**: DevOps engineers can aggregate, parse, and analyze client logs using monitoring tools

**Independent Test**: Capture client logs and verify they can be parsed by log aggregation tools (structured format validation)

**Note**: This story focuses on verifying Logger output format supports aggregation, not setting up infrastructure

- [ ] T045 [US3] Document Logger output format for aggregation
  - Capture sample Logger output from browser console
  - Document JSON structure or format schema
  - Provide examples for parsing with common tools (Splunk, ELK, CloudWatch)
  - Add to quickstart.md or create log-aggregation.md guide
- [ ] T046 [US3] Verify Logger metadata completeness
  - Confirm logs include: logger name, timestamp, severity level, message
  - Test with objects and nested data to verify serialization
  - Document any limitations or special cases
  - Update quickstart.md with findings

**US3 Success Criteria**: ✅ Log format documented, aggregation feasibility confirmed, examples provided

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup and documentation

- [ ] T047 Update project documentation
  - Add Logger usage guidelines to `.claude/CLAUDE.md` (reminder: use Logger for all new client code)
  - Update `docs/BUGS.md` to mark console.log cleanup as complete
  - Update `docs/WALKTHROUGH.md` with final implementation section
- [ ] T048 Create ESLint rule to prevent console.log reintroduction (optional)
  - If time permits, add ESLint rule to flag console.log in client code
  - Configure to allow console.error (intentional error handling)
  - Document rule in `.eslintrc` with rationale
- [ ] T049 Final verification
  - Run complete test suite one more time: `yarn testunit`
  - Run complete build: `yarn build`
  - Smoke test all affected features in browser
  - Verify no console.log/warn remain: `grep -r "console\.\(log\|warn\)" apps/meteor/client`

**Checkpoint**: Feature complete and validated

---

## Dependencies

### Story Dependencies

```
Phase 1 (Setup)
  ↓
Phase 2 (Foundational - Prototype)
  ↓
Phase 3 (US1 - P1) 🎯 MVP ← Can deliver independently
  ↓ (optional)
Phase 4 (US2 - P2) ← Depends on US1 completion
  ↓ (optional)
Phase 5 (US3 - P3) ← Depends on US1 completion
  ↓
Phase 6 (Polish)
```

**Independent Stories**: US2 and US3 can run in parallel after US1 completes
**MVP Scope**: Phase 1 + Phase 2 + Phase 3 (US1 only) = Complete logger migration

### Task Dependencies Within Stories

**US1 (Phase 3)**:
- T006-T008 (Prototype) MUST complete first → blocks all other US1 tasks
- T009-T010 (High-impact) can run in parallel
- T012-T019 (Batch 1) can run in parallel after prototype
- T021-T025 (Batch 2) can run in parallel after prototype
- T027-T032 (Batch 3) can run in parallel after prototype
- T034-T038 (Batch 4) can run in parallel after prototype
- Validation tasks (T011, T020, T026, T033, T039) are batch checkpoints
- Final validation (T040-T042) requires all migrations complete

**US2 (Phase 4)**: T043-T044 can run in parallel

**US3 (Phase 5)**: T045-T046 can run in parallel

**Phase 6 (Polish)**: T047-T049 mostly sequential

---

## Parallel Execution Examples

### Maximum Parallelization (After Prototype Complete)

Once T006-T008 (prototype) completes successfully, these tasks can ALL run in parallel:

**Batch 1** (8 tasks): T012, T013, T014, T015, T016, T017, T018, T019
**Batch 2** (5 tasks): T021, T022, T023, T024, T025
**Batch 3** (6 tasks): T027, T028, T029, T030, T031, T032
**Batch 4** (5 tasks): T034, T035, T036, T037, T038

Plus high-impact files (2 tasks): T009, T010

**Total parallelizable**: 26 file migrations can run simultaneously (all modify different files)

### Recommended Batching Strategy

For practical execution, group into batches with validation checkpoints:

1. **Prototype** (Sequential): T006 → T007 → T008
2. **High-Impact** (Parallel): T009 || T010 → T011 (validation)
3. **Core Infrastructure** (Parallel): T012-T019 → T020 (validation)
4. **Hooks** (Parallel): T021-T025 → T026 (validation)
5. **Providers & Components** (Parallel): T027-T032 → T033 (validation)
6. **Apps & Admin** (Parallel): T034-T038 → T039 (validation)
7. **Final Validation** (Sequential): T040 → T041 → T042

**Time Estimate**: With parallel execution, US1 completion ~ 2-4 hours (vs 8-10 hours sequential)

---

## Implementation Strategy

### MVP-First Approach

**Minimum Viable Product**: Complete Phase 1-3 (US1) only
- Delivers all core value: 51 console.log/warn replaced with structured logging
- Developers can immediately benefit from filterable, structured logs
- Production deployment safe (all tests passing, no behavioral changes)

**Optional Enhancements**: Phase 4-5 (US2-US3)
- US2: Production log management (nice-to-have documentation)
- US3: Log aggregation support (infrastructure team benefit)

### Incremental Delivery

Each phase is a deployable increment:

1. **After Phase 2**: Prototype verified - proves feasibility
2. **After Phase 3**: US1 complete - fully functional logger migration
3. **After Phase 4**: US2 complete - production documentation added
4. **After Phase 5**: US3 complete - aggregation support documented
5. **After Phase 6**: Polish complete - project documentation updated

### Risk Mitigation Checkpoints

**Decision Gate 1** (After T008 - Prototype):
- ✅ Logger works in browser → Continue
- ❌ Logger fails → Investigate, fix, or abort migration

**Decision Gate 2** (After T011 - High-Impact):
- ✅ VoIP and VideoConf work → Continue bulk migration
- ❌ Features broken → Investigate impact before proceeding

**Final Quality Gate** (T041):
- ✅ All tests pass, build succeeds → Ready to commit
- ❌ Any failures → Fix before committing (no partial migration allowed)

---

## Summary

**Total Tasks**: 49 tasks
- Phase 1 (Setup): 5 tasks
- Phase 2 (Foundational): 3 tasks (prototype)
- Phase 3 (US1): 34 tasks (27 file migrations + 7 validations)
- Phase 4 (US2): 2 tasks (documentation)
- Phase 5 (US3): 2 tasks (documentation)
- Phase 6 (Polish): 3 tasks (final cleanup)

**Parallelization**: 26 file migrations can run simultaneously (53% of total tasks)

**MVP Scope**: Phases 1-3 (42 tasks) delivers complete logger migration

**Estimated Time**:
- Sequential execution: ~10-12 hours
- Parallel execution: ~4-6 hours (with batching strategy)
- MVP only: ~3-4 hours (parallel execution)

**Independent Testing**: Each user story can be tested independently:
- US1: Browse features, verify Logger output in console
- US2: Test log level configuration
- US3: Verify log format for aggregation

**Success Criteria**: All tasks complete → 51 console.log/warn replaced, tests passing, features working
