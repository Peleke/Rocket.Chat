## Overclock Accelerator Week 2: Hacking Rocket.Chat with Claude Code, SpecKit & Serena MCP

This week’s Overclock Accelerator challenge:

> “Use **SpecKit + RepoMix + Cursor (or Claude Code)** to implement a real change in an open-source repo.”

I picked one of the biggest open-source TypeScript projects around: **[Rocket.Chat](https://github.com/RocketChat/Rocket.Chat)** — a 75-package monorepo built with Yarn 4, Turborepo, Meteor, and React. It powers enterprise-grade chat for tens of millions of users, and it’s... enormous.

### The Experiment

This wasn’t a simple “bug fix.” It was an experiment in hands-free coding — an attempt to see if an LLM could actually engineer a change in a complex, real-world codebase without me typing a single command.

I didn’t clone, build, or edit by hand. Instead, I directed Claude Code through a structured workflow using SpecKit for planning and Serena MCP for persistent, symbol-level understanding.
Every action was guided, reasoned, and executed through dialogue — not shell commands.

The question behind it was simple:
If AI can already write snippets, can it also understand and modify a living codebase responsibly?
The answer, in this case, was yes.

TL;DR

I used Claude Code, SpecKit, and Serena MCP to perform a real fix in Rocket.Chat — fully through structured LLM reasoning.

The AI explored, planned, and implemented changes with zero direct edits or terminal use.

The fix replaced 51 raw console calls with structured logger calls across 27 files, type-safe and lint-clean.

### Setup

Getting Rocket.Chat running locally was its own puzzle:

* Node 22.16.0 + Yarn 4.10 + Meteor 3.3.2
* Undocumented Deno dependency via `@rocket.chat/apps-engine`
* 3,333 packages built with Yarn PnP
* `yarn dev` doesn’t start the app; you run Meteor directly

(Full walkthrough: [docs/WALKTHROUGH.md](https://github.com/Peleke/Rocket.Chat/blob/001-logger-migration/docs/WALKTHROUGH.md))

### The Fix

The documented issue looked trivial:

> Replace `console.log` and `console.warn` calls with Rocket.Chat’s structured logger.

In practice:
51 calls across 27 client files.
Each one migrated to use `@rocket.chat/logger`:

```ts
import { Logger } from '@rocket.chat/logger';
const logger = new Logger('ServiceWorker');
logger.info('Reloading to activate');
```

Zero stray console statements. Full typecheck, lint, and build passes. Structured logs throughout the client app.

---

### Interlude: Lessons

What stood out wasn’t just that the system worked — it’s how it worked.
I spent almost no time “coding” and all my time orchestrating. I was guiding the process, defining constraints, checking reasoning, not syntax.
It felt closer to pair programming with an unusually disciplined engineer than “prompting a chatbot.”

That’s the shift we’re starting to see everywhere.
These tools don’t make developers obsolete — they change the level at which we operate. The focus moves up a layer: less on implementation, more on intent, structure, and specification.
It’s early, messy, and occasionally absurd, but the pattern’s there.
Software development is becoming a conversation that produces code as a byproduct.

---

### Advanced

#### Integrations

Modern tools like Claude Code and Cursor are no longer monoliths. They are integration surfaces. Every plugin or connection is a bridge between the model’s reasoning loop and the external world: your repo, your docs, your data.

You don’t teach them everything: You connect them to the systems that already know.

That’s where [**MCPs**—*Model Context Protocols*](https://modelcontextprotocol.io/docs/getting-started/intro)—come in.
Think of an MCP as a translator. It lets an AI talk to an app or service as if it were another agent. The model doesn’t scrape or guess; it just says, “Ask Serena,” and Serena replies.
You don’t need to understand how the wires run. You only need to know that it gives the model real tools to work with, safely and predictably.

**Serena MCP** was the connective tissue of this project. It indexed Rocket.Chat’s source tree, remembered structure, resolved symbols, and made the model’s memory persistent.
Without it, every Claude session would start from zero. With it, the model could reason about architecture across hours or days, building a kind of *synthetic continuity* that’s impossible in stateless chat.
That’s the breakthrough: sustained understanding over time, not just clever one-off answers.

Other standout MCP integrations show how this pattern scales:

* **Context7** — long-term vector memory that LLMs can actually use.
* **Notion MCP** — enables live doc access and updates, keeping human and machine context aligned.
* **GitHub MCP** — deep repo inspection, PR review, and navigation without scraping or workarounds.

Together, they turn models into true collaborators rather than reactive tools.

---

#### Automation

Inside `.claude/commands`, **SpecKit** defines its automation layer: the slash commands that turn reasoning into repeatable action.
Each command is a small spec—inputs, constraints, expected outcomes. You can add your own by writing a simple YAML descriptor, dropping it into the directory, and immediately using `/your-command` inside Claude or Cursor.

For example:

```yaml
name: refactor-to-hooks
description: "Refactor a React component from class syntax to functional with hooks"
plan:
  - Analyze component file
  - Generate equivalent hook-based component
  - Replace imports and exports
  - Run lint and type check
```

Once added, `/refactor-to-hooks MyComponent.tsx` executes the entire sequence.
This is more than automation; it’s **procedural authorship**.
Your repo becomes a living system of executable processes that document themselves through use.

---

Follow the walkthrough here:
👉 [github.com/Peleke/Rocket.Chat/tree/001-logger-migration/docs/WALKTHROUGH.md](https://github.com/Peleke/Rocket.Chat/tree/001-logger-migration/docs/WALKTHROUGH.md)

