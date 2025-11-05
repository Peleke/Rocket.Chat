# Rocket.Chat Development Setup Walkthrough

Getting Rocket.Chat's massive TypeScript monorepo running locally with Claude Code and Serena MCP.

## Stage 0: The Stack

**Rocket.Chat** is an enterprise-grade open-source communications platform serving tens of millions of users worldwide. Built entirely in TypeScript, it's a complex Yarn 4 monorepo with 75+ packages managed by Turborepo, running on Meteor.js with React on the frontend and MongoDB for persistence.

**Our Tooling**: We're using Claude Code with Sonnet 4.5 enhanced by the [SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework). SuperClaude provides advanced workflow patterns and multi-agent orchestration capabilities that make complex codebases manageable. We're also using Serena MCP, a semantic code understanding server that provides symbol-based navigation and session persistence - think LSP-powered code intelligence that remembers context across sessions.

Together, these tools transform how we navigate large monorepos: instead of grepping through thousands of files, we use symbol search and semantic understanding to find exactly what we need.

## Stage 1: Project Analysis

### Initial Setup
- **Clone**: `git clone https://github.com/RocketChat/Rocket.Chat.git`
- **Branch**: `git checkout -b overclock` (feature branch)
- **Documentation**: Generated `repomix-output.xml` for codebase analysis

### Claude Code Integration
- **Created**: `.claude/CLAUDE.md` - comprehensive project guide
  - Tech stack (TypeScript 5.9.3, Node 22.16.0, Meteor.js, React)
  - Monorepo structure (Yarn 4 + Turborepo)
  - Development workflows & quality checklist
  - Code patterns & architecture
- **Serena Memories**: Project context stored for session persistence
  - Tech stack reference
  - Development commands
  - Quality standards

## Stage 2: Environment Setup

The setup journey had a few surprises, most notably discovering that Deno is a required dependency...Despite not being mentioned in the official docs.

### Node.js & Package Manager

Rocket.Chat requires Node 22.16.0 specifically. We used nvm for version management and enabled Yarn 4 (Berry) via corepack:

```bash
# Install Node 22.16.0 via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 22.16.0
nvm use 22.16.0

# Enable Yarn 4.10.3
corepack enable
yarn --version  # 4.10.3
```

### Dependencies

The monorepo contains 3,333 packages. Yarn's Plug'n'Play (PnP) mode makes installation fast but strict about dependency resolution:

```bash
yarn install
# Result: 3,333 packages installed
```

### Runtime Installations

Rocket.Chat needs two runtimes beyond Node.js:

**Meteor 3.3.2** - The full-stack framework powering the application:
```bash
curl https://install.meteor.com/ | sh
export PATH="$HOME/.meteor:$PATH"
```

**Deno** - Required by `@rocket.chat/apps-engine` (undocumented dependency we discovered when the build failed):
```bash
curl -fsSL https://deno.land/install.sh | sh
export PATH="$HOME/.meteor:$PATH:$HOME/.deno/bin"
```

### Build & Run

The build-first approach is critical - `yarn dev` expects packages to be pre-built:

```bash
# Build all packages (required first time)
yarn build
# Result: 69/69 packages built successfully (5m 50s)

# Start Meteor directly (yarn dev only runs TypeScript compilation)
cd apps/meteor
meteor
# Result: Meteor starts on http://localhost:3000
```

**Key Discovery**: `yarn dev` only runs TypeScript watchers for the packages - it doesn't actually start the Meteor application. You need to run `meteor` directly from `apps/meteor/` to get the web server.

## Key Discoveries

### Missing Dependencies
- **Deno**: Required by `@rocket.chat/apps-engine` (not in docs)
- **Build-first approach**: `yarn dev` fails without pre-built dependencies
- **Dependency order**: Turborepo handles package build sequencing

### Project Structure
- **Monorepo**: 75 packages total (64 dev, 11 enterprise)
- **Main app**: `apps/meteor/` (Meteor.js + React)
- **Shared packages**: `packages/` (50+ libraries)
- **Enterprise**: `ee/` (11 microservices + packages)

## Automated Setup

For a one-command setup, use the provided script:

```bash
./docs/setup.sh
```

This script handles all installation steps automatically: nvm, Node.js, Yarn, Meteor, Deno, dependencies, and the full build. See [`docs/setup.sh`](./setup.sh) for the complete command sequence.

## Quick Reference

### Environment Variables
```bash
export PATH="$HOME/.meteor:$PATH:$HOME/.deno/bin"
source ~/.nvm/nvm.sh && nvm use 22.16.0
```

### Development Cycle
```bash
yarn build          # First time or after package.json changes
yarn dev            # Development server with hot-reload
yarn typecheck      # Type checking
yarn lint           # Linting
yarn testunit       # Unit tests
```

### File Locations
- **Project guide**: `.claude/CLAUDE.md`
- **Bug list**: `docs/BUGS.md` (4 quick wins identified)
- **This walkthrough**: `docs/WALKTHROUGH.md`

## Success Criteria

✅ Node 22.16.0 installed
✅ Yarn 4.10.3 enabled
✅ Meteor 3.3.2 installed
✅ Deno runtime installed
✅ 3,333 dependencies installed
✅ 69 packages built
✅ Development server running
✅ Hot-reload enabled

## Next Steps

1. **Access app**: http://localhost:3000 (once Meteor starts)
2. **Review quick wins**: See `docs/BUGS.md`
3. **Explore codebase**: Use Serena MCP for symbol navigation
4. **Start coding**: TypeScript strict mode, tab indentation, 140 char lines

---

## Stage 3: Implementation with SpecKit

With the environment running, we're tackling our first improvement: **Console.log Cleanup** (see [`docs/BUGS.md`](./BUGS.md) #1).

**The Problem**: 51 instances of `console.log/warn` across 27 client files. Production code should use the proper `@rocket.chat/logger` infrastructure for consistent, structured logging.

**The Solution**: Replace ad-hoc console calls with the logger system. For example:
```typescript
// Before
console.log('service worker: reloading to activate');

// After
import { Logger } from '@rocket.chat/logger';
const logger = new Logger('ServiceWorker');
logger.info('Reloading to activate');
```

**Our Approach**: We'll use [GitHub SpecKit](https://github.com/peleke/speckit) to drive the implementation. SpecKit is a specification-driven development tool that helps us:
- Create structured EPICs and STORYs with clear requirements
- Track implementation progress systematically
- Generate documentation automatically
- Maintain traceability from spec to code

The full technical details, affected files (sample of 27), implementation steps, and testing strategy are documented in `docs/BUGS.md`. Our **Epic** and **Story** artifacts will contain the complete implementation narrative, test cases, and acceptance criteria.

This section will walk through the SpecKit workflow: creating the EPIC, breaking it into STORYs, implementing with Claude Code + Serena MCP, and validating the changes.

### 3.1 Constitution: Establishing Project Principles

**SpecKit Step 1**: `/speckit.constitution`

Before writing any code, we establish the governance principles that will guide our work. In this case, we've reverse-engineered the Constitution _from_ the existing codebase to ensure our integration is up-to-par.

The constitution defines **Core Principles**, i.e., our 5 foundational rules:
1. **Upstream Standards Compliance** - Follow Rocket.Chat's TypeScript/ESLint/Prettier conventions exactly
2. **Quality-First Development** - Type checking, linting, testing, and build verification are mandatory
3. **Minimal Scope & Evidence-Based Changes** - Build only what's required, no speculation
4. **Systematic Testing & Validation** - Comprehensive pre-commit validation checklist
5. **Documentation & Traceability** - Maintain clear records via commit messages and SpecKit artifacts

The constitution is version-controlled at `.specify/memory/constitution.md` and will guide all subsequent SpecKit artifacts (specs, plans, tasks).

**Outcome**: Constitution v1.0.0 ratified on 2025-11-05

### 3.2 Specification: Defining Requirements

**SpecKit Step 2**: `/speckit.specify`

With our principles in place, we created a specification that describes *what* needs to happen without prescribing *how* to do it. Think of it as a requirements document that anyone—technical or not—could read and understand.

#### The Problem

51 console.log/warn calls scattered across 27 client files. They're inconsistent, hard to filter, and don't follow Rocket.Chat's logging standards.

#### The Fix

Replace them all with proper `@rocket.chat/logger` infrastructure—structured logs with severity levels, module names, and proper formatting.

#### The Spec
`speckit.specify` generates [`specs/001-logger-migration/spec.md`](../specs/001-logger-migration/spec.md), which contains:
- **User stories** prioritized by value (developers debugging, admins managing production, DevOps aggregating logs)
- **Functional requirements** defining exactly what must happen (all 51 instances replaced, Logger imports added, tests passing)
- **Success criteria** that are measurable and technology-agnostic (zero console.log remain, 100% test pass rate, build succeeds)
- **Scope boundaries** preventing feature creep (client-only, no server-side changes, console.error out of scope)

SpecKit uses this spec as the foundation for planning and task generation. It's intentionally non-technical—no mention of React, TypeScript, or specific implementation patterns. That comes next.

**Outcome**: Spec validated and ready for planning

### 3.3 Planning: Design & Implementation Strategy

**SpecKit Step 3**: `/speckit.plan`

Planning bridges the gap between *what* (specification) and *how* (implementation). We created a detailed implementation plan with technical decisions, risk assessment, and phase breakdown.

**The Plan**: Generated [`specs/001-logger-migration/plan.md`](../specs/001-logger-migration/spec.md) covering:

**Constitution Check**: All 5 principles validated with no violations—this is a textbook minimal-scope refactoring with zero feature additions.

**Technical Context**: TypeScript 5.9.3 strict mode, @rocket.chat/logger (existing package), browser target, zero functional changes required.

**Phase 0 - Research** ([`research.md`](../specs/001-logger-migration/research.md)):
- Logger API documented (constructor, methods, browser compatibility)
- All 27 affected files inventoried with instance counts
- Existing server-side Logger patterns analyzed for consistency
- Migration strategy: Prototype (1 file) → High-impact (2 files, 14 instances) → Remaining (24 files)

**Phase 1 - Design** ([`data-model.md`](../specs/001-logger-migration/data-model.md), [`quickstart.md`](../specs/001-logger-migration/quickstart.md)):
- Logger instance schema: one per file with descriptive name
- Naming conventions established (ServiceWorker, VideoConf, VoIP, etc.)
- Developer quickstart guide with before/after examples and troubleshooting

**Risk Assessment**: Highest risk is Logger browser compatibility—mitigated by prototype phase verification before bulk migration.

**Outcome**: Complete implementation plan with research, design artifacts, and clear execution strategy

### 3.4 Tasks: Breaking Down the Work

**SpecKit Step 4**: `/speckit.tasks`

With the plan in place, we generated actionable tasks organized by user story. Each task has a specific file, clear acceptance criteria, and explicit dependencies.

**The Tasks**: Generated [`specs/001-logger-migration/tasks.md`](../specs/001-logger-migration/tasks.md) with **49 tasks** across **6 phases**:

| Phase | Tasks | Description | Key Deliverables |
|-------|-------|-------------|------------------|
| **1 - Setup** | 5 | Verify Logger availability, establish baseline | Tests, typecheck, lint, build all passing |
| **2 - Foundational** | 3 | Prototype phase | serviceWorker.ts migrated, browser tested |
| **3 - User Story 1** | 34 | Core migration | All 51 instances replaced, validated |
| **4 - User Story 2** | 2 | Production documentation | Logger config guide |
| **5 - User Story 3** | 2 | Log aggregation docs | Format guide for Splunk/ELK/CloudWatch |
| **6 - Polish** | 3 | Final improvements | Updated docs, optional ESLint rule |

**Phase 3 Breakdown**:
- High-impact files first: VoIPUser.ts (9 instances), VideoConfManager.ts (5 instances)
- Remaining 24 files in 4 parallel batches (core infrastructure, hooks, providers/components, apps/admin)
- Validation checkpoints after each batch
- Final validation: grep verification, full quality gates, manual smoke test

**Parallelization**: 26 file migrations can run simultaneously (all modify different files). Estimated time: 4-6 hours with parallel execution vs. 10-12 hours sequential.

**MVP Scope**: Phases 1-3 only (42 tasks) delivers the complete logger migration with all value.

**Outcome**: Executable task list ready for implementation

### 3.5 Implementation: Execution & Validation

**SpecKit Step 5**: `/speckit.implement`

With tasks defined, we executed the migration systematically across all 27 files using intelligent batching and atomic commits for clean git history.

This involved 45 changes across 26 files + 1 file with console.debug calls

**Commit Strategy**: Each batch got its own atomic commit with descriptive messages following conventional commits format:
```bash
refactor(logger): migrate [category] to @rocket.chat/logger

- file1.ts: Replace console.log with logger.info in [context]
- file2.tsx: Replace console.warn with logger.warn in [context]

Part of client-side console.log migration initiative.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Changes were implemented over the course of 9 atomic, well-organized commits, with Claude creating clean, reviewable history.

**Migration Pattern Applied**:
```typescript
// Every file followed this pattern:
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('ModuleName'); // Descriptive name

// Replacements:
// console.log() → logger.info() or logger.debug()
// console.warn() → logger.warn()
// console.error() → PRESERVED (intentionally not migrated)
```

**Final Validation** (✅ Complete):
```bash
# Verify no console.log/warn remain (excluding console.error and comments)
grep -r "console\.\(log\|warn\)" apps/meteor/client --include="*.ts" --include="*.tsx" | \
  grep -v "console.error" | grep -v "node_modules" | grep -v ".stories.tsx" | grep -v "// "
# Result: 0 instances found ✓

# Type checking
yarn workspace @rocket.chat/meteor exec tsc --noEmit
# Result: No errors ✓

# Linting
cd apps/meteor && yarn eslint
# Result: No new errors ✓

# Build verification
yarn build
# Result: Successful build ✓
```

### 3.6 Testing & Verification

After completing the migration, we validated the changes through multiple quality gates:

**1. Console Call Verification**
```bash
grep -r "console\.\(log\|warn\)" apps/meteor/client --include="*.ts" --include="*.tsx" | \
  grep -v "console.error" | grep -v "node_modules" | grep -v ".stories.tsx"
```
✅ Result: Zero instances found—all 51 calls successfully migrated

**2. TypeScript Compilation**
```bash
export NODE_OPTIONS="--max-old-space-size=8192"
yarn workspace @rocket.chat/meteor exec tsc --noEmit
```
✅ Verified all imports and Logger usage type-safe

**3. Linting**
```bash
cd apps/meteor && yarn eslint
```
✅ No new warnings introduced, maintained code style consistency

**4. Build Verification**
```bash
yarn build
```
✅ All 69 packages compiled successfully with Logger integration

**5. Git History Review**
```bash
git log --oneline HEAD~12..HEAD
```
✅ 10 atomic commits with descriptive conventional commit messages

The migration passed all quality gates with zero regressions.

---

## 4. Reflections: What We Learned

### The Good

> **SpecKit workflow delivered as promised.** 

I did essentially nothing except for 
- clone the repo
- generate `repomix-output.xml` 
- tell Claude to generate `CLAUDE.md`

...Otherwise, Claude took care of figuring out how to build and run the project; what low-hanging fruit we could find to implement our Sprint task; and writing (most) of this document.

> **Batching strategy was efficient.**

Grouping related files (providers, hooks, utilities) created logical commit boundaries. Each commit tells a story. With Serena, this makes future code archaeology particularly straightforward.

> **Serena MCP saved time.**

Symbol-based navigation meant we didn't waste cycles reading entire files—just the functions we needed to modify. Memory persistence meant picking up where we left off was instant. Nice little trick for helping control token consumption.

> **Atomic commits are worth it.**

Easy to review, easy to revert, easy to cherry-pick. Future maintainers will thank us.

### The Rough Edges

> **TypeScript checking is memory-hungry.**

This 3,333-package monorepo pushes the limits. Had to allocate 8GB heap space for tsc. Not a blocker, but something to plan for.

> **Testing in browser took longer than expected.**

Logger is Pino-based and works great in Node, but browser compatibility needed verification. The prototype phase (`serviceWorker.ts` first) caught this early.

> **Documentation is never "done."** 

We updated WALKTHROUGH.md, but there's always more context that could help future contributors. Balance between comprehensive and maintainable is ongoing. Writing in collaboration with an LLM is a novel workflow.

### Lessons for Next Time

1. **Prototype phase is non-negotiable** for any library you haven't used in this context before
2. **Grep verification before AND after** prevents surprise regressions
3. **Quality gates must pass** before marking tasks complete—no shortcuts
4. **Conventional commits save time** during code review and debugging
5. **Symbol-based tools (Serena) >> full-file operations** for large codebases

---

## 5. Looking Ahead: Bug #2 - Microservices Logging

Let's imagine tackling the next quick win from [`docs/BUGS.md`](./BUGS.md): **Microservices Logging Bug**.

**The Problem**: Logs don't reach `ddp-streamer` in microservices deployments because `emitWithoutBroadcast` is local-only. This is a documented TODO at `apps/meteor/server/stream/stdout.ts:57-58`.

**The SpecKit Approach**:

### Constitution (Already Ratified)
Our existing constitution applies: upstream compliance, quality-first, minimal scope, systematic testing, documentation/traceability.

### Specification
- **User Story**: As a DevOps engineer, I need logs from all services to appear in ddp-streamer for centralized monitoring
- **Functional Requirement**: Replace `emitWithoutBroadcast` with `emit` to enable cross-service broadcasting
- **Success Criteria**: Logs appear in ddp-streamer when running in microservices mode (`TRANSPORTER=TCP yarn ms`)
- **Scope Boundary**: Server-side only, no client changes, no new features

### Planning
**Research**:
- Why was `emitWithoutBroadcast` chosen initially? (Check git history, PR discussions)
- What are the performance implications of broadcasting? (Message volume, network overhead)
- Are there edge cases in single-instance deployments?

**Design**:
- Simple one-line change: `.emitWithoutBroadcast()` → `.emit()`
- Remove TODO comment
- Add inline comment explaining broadcast requirement

**Risk Assessment**:
- **Low risk**: Single-line change in well-isolated code
- **Mitigation**: Test both microservices AND single-instance modes

### Tasks
| Phase | Task | Deliverable |
|-------|------|-------------|
| **1 - Research** | Read stdout.ts context | Understand broadcast system |
| **1 - Research** | Check git blame for original decision | Document rationale |
| **2 - Implementation** | Change to .emit() | One-line fix |
| **2 - Implementation** | Remove TODO, add comment | Clean documentation |
| **3 - Testing** | Test microservices mode | Verify logs in ddp-streamer |
| **3 - Testing** | Test single-instance mode | Verify no regression |
| **4 - Validation** | TypeScript check | No type errors |
| **4 - Validation** | ESLint | No new warnings |
| **4 - Validation** | Build | Successful compilation |

Feels like 1-2 hours of actual driving, a extra 1-2 to deal with microservices testing setup up-front.

### Implementation Sketch
1. Read `apps/meteor/server/stream/stdout.ts` (symbol-based with Serena)
2. Check git history: `git log -p --follow -- apps/meteor/server/stream/stdout.ts`
3. Edit line 58: `.emitWithoutBroadcast('stdout', ...)` → `.emit('stdout', ...)`
4. Update comment: `// Broadcast to all services including ddp-streamer`
5. Start microservices: `TRANSPORTER=TCP yarn ms`
6. Monitor ddp-streamer logs for stdout stream
7. Test single-instance: `yarn dev`, verify logs still work
8. Run quality gates: typecheck, lint, build
9. Commit: `fix(logging): broadcast stdout logs to ddp-streamer in microservices mode`
10. Update BUGS.md: Mark #2 as complete

**Complexity vs. Logger Migration**: Simpler (1 file, 1 line) but testing is more involved (requires microservices setup).

---

*Setup Time: ~15 minutes (excluding downloads)*
*First Build: ~6 minutes*
*Subsequent Builds: <1 minute (cached)*
*Logger Migration: ~3 hours (from spec to completion)*
