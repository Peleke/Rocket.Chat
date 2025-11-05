# Rocket.Chat Contribution Constitution

<!--
Sync Impact Report (2025-11-05):
Version: 0.0.0 → 1.0.0 (Initial constitution creation)

Modified Principles:
- All principles defined from template baseline

Added Sections:
- Core Principles (5 principles established)
- Quality Standards (testing, linting, type safety)
- Development Workflow (feature branch workflow, commit conventions)
- Governance (amendment procedures, version control)

Templates Status:
✅ plan-template.md - Constitution check aligned
✅ spec-template.md - Quality requirements propagated
✅ tasks-template.md - Task categorization includes principle-driven types
✅ checklist-template.md - Quality gates reference constitution
✅ agent-file-template.md - Generic guidance confirmed

Follow-up TODOs:
- None (all placeholders resolved)
-->

## Core Principles

### I. Upstream Standards Compliance (NON-NEGOTIABLE)

All contributions MUST adhere to Rocket.Chat's established standards:
- **TypeScript Strict Mode**: No `any` types without justification
- **Code Style**: Tab indentation, 140-char lines, single quotes, trailing commas
- **Prettier/ESLint**: All code must pass linting before commit
- **Testing**: Unit tests required for new features, E2E tests for user flows
- **Architecture**: Follow existing patterns (functional React components with hooks, DDP for real-time, Meteor methods for RPC)

**Rationale**: This is an upstream contribution to an established enterprise codebase. We respect and follow their conventions to ensure our changes integrate seamlessly and can be merged without friction.

### II. Quality-First Development

Code quality is not negotiable. Every change must meet these standards:
- **Type Safety**: `yarn typecheck` MUST pass with zero errors
- **Lint Compliance**: `yarn lint` MUST pass, use `eslint:fix` for auto-fixes
- **Test Coverage**: `yarn testunit` MUST pass, new code requires tests
- **Build Verification**: `yarn build` MUST succeed before commit

**Rationale**: Rocket.Chat serves tens of millions of users in high-security environments (government, defense, critical infrastructure). Quality failures can impact real-world communications and safety.

### III. Minimal Scope & Evidence-Based Changes

Build only what's explicitly required, nothing more:
- **MVP First**: Start with the minimum viable solution
- **No Speculation**: YAGNI - You Aren't Gonna Need It
- **Evidence-Based**: All technical claims must be verifiable through testing or documentation
- **Scope Discipline**: Resist feature creep, focus on the defined problem

**Rationale**: Large enterprise codebases have complex interdependencies. Minimal, focused changes reduce risk, ease review, and increase merge likelihood.

### IV. Systematic Testing & Validation

Comprehensive validation before any commit:
1. **Type Check**: Verify TypeScript compilation
2. **Lint**: Check code style compliance
3. **Unit Tests**: Run test suite
4. **Build**: Verify production build
5. **Manual Test**: Smoke test affected functionality

**Rationale**: Rocket.Chat's CI pipeline is rigorous. Local validation catches issues early, accelerates review, and respects maintainer time.

### V. Documentation & Traceability

Maintain clear records of all changes:
- **Commit Messages**: Follow conventional commits (`feat:`, `fix:`, `refactor:`, etc.)
- **Implementation Docs**: Document decisions, trade-offs, and rationale
- **SpecKit Artifacts**: Maintain EPICs, STORYs, specs, plans, and tasks
- **Code Comments**: Explain "why", not "what"

**Rationale**: Future maintainers (including ourselves) need context to understand changes. Documentation enables maintenance, debugging, and evolution.

## Quality Standards

### Testing Requirements

- **Unit Tests**: All new functions/components require unit tests
- **Integration Tests**: New library contracts and inter-service communication require integration tests
- **E2E Tests**: User-facing features require Playwright E2E tests
- **Accessibility**: Use `@axe-core/playwright` for WCAG compliance validation
- **Coverage**: Maintain or improve existing coverage levels

### Linting & Formatting

- **ESLint**: Must pass without errors or warnings
- **Stylelint**: CSS/style changes must pass style linting
- **Prettier**: Auto-format before commit (tabs, 140 chars, single quotes)
- **TypeScript**: Strict mode with explicit types (avoid `any`)

### Security & Safety

- **Input Validation**: Validate all user input server-side
- **Authentication**: Check `this.userId` in Meteor methods
- **XSS Prevention**: Use React's automatic escaping, sanitize user input
- **No Secrets**: Never commit API keys, credentials, or tokens

## Development Workflow

### Branch Strategy

1. **Feature Branches**: All work on `feature/<description>` branches
2. **Base Branch**: Branch from `develop` (main development branch)
3. **No Direct Commits**: Never commit directly to `develop` or `master`
4. **Clean History**: Meaningful commit messages, logical commit boundaries

### Commit Process

1. **Pre-Commit Checklist**:
   - ✅ `yarn typecheck` passes
   - ✅ `yarn lint` passes (use `eslint:fix` if needed)
   - ✅ `yarn testunit` passes
   - ✅ `yarn build` succeeds
   - ✅ Manual smoke test completed

2. **Commit Convention**:
   ```
   <type>(<scope>): <description>

   [optional body]
   [optional footer]
   ```
   Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

3. **Pull Request**:
   - Reference issue/EPIC in description
   - Provide clear context and testing evidence
   - Request review from maintainers

### SpecKit Integration

All features follow the SpecKit workflow:

1. **Constitution**: Establish principles (this document)
2. **Specification**: Create baseline spec with requirements
3. **Plan**: Design implementation strategy
4. **Tasks**: Break down into actionable tasks
5. **Implementation**: Execute with validation at each step

## Governance

### Amendment Procedure

Constitution changes require:
1. **Justification**: Clear rationale for changes
2. **Version Bump**: Semantic versioning (MAJOR.MINOR.PATCH)
3. **Template Sync**: Update all dependent templates
4. **Impact Report**: Document changes and affected artifacts
5. **Review**: Team consensus before adoption

### Versioning Policy

- **MAJOR**: Backward-incompatible governance or principle removal/redefinition
- **MINOR**: New principle/section added or materially expanded guidance
- **PATCH**: Clarifications, wording fixes, non-semantic refinements

### Compliance Review

- All PRs must verify compliance with this constitution
- SpecKit artifacts (spec, plan, tasks) must reference applicable principles
- Quality gates are mandatory, no exceptions for deadlines
- Complexity must be justified against Principle III (Minimal Scope)

### Runtime Development Guidance

For day-to-day development guidance specific to Rocket.Chat:
- **Project Guide**: `.claude/CLAUDE.md` (comprehensive setup and conventions)
- **Bug Tracking**: `docs/BUGS.md` (current issues and priorities)
- **Walkthrough**: `docs/WALKTHROUGH.md` (setup and implementation journey)

**Version**: 1.0.0 | **Ratified**: 2025-11-05 | **Last Amended**: 2025-11-05
