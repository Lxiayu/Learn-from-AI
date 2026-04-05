# Local-First Doc Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align architecture, database, deployment, and frontend/spec documentation to the approved local-first implementation phase while preserving CloudBase as the future migration target.

**Architecture:** Update the docs to use a dual-track model: current implementation is local-first with Flutter + local FastAPI + local database, while future production remains CloudBase-oriented. Keep existing product and data model intent, but remove wording that implies CloudBase is required now.

**Tech Stack:** Markdown docs, existing project specs, approved spec `2026-04-05-local-first-backend-and-cloud-migration-design.md`

---

### Task 1: Add the execution plan document

**Files:**
- Create: `/Users/xia/program/Learn/docs/superpowers/plans/2026-04-05-local-first-doc-alignment.md`

- [ ] **Step 1: Write the plan file**
- [ ] **Step 2: Save it before editing other docs**

### Task 2: Align the main architecture document

**Files:**
- Modify: `/Users/xia/program/Learn/docs/02-technical-architecture.md`

- [ ] **Step 1: Add current-stage vs target-stage framing**
- [ ] **Step 2: Update tech stack and deployment wording**
- [ ] **Step 3: Align storage, AI, monitoring, and deployment sections**

### Task 3: Align the database document

**Files:**
- Modify: `/Users/xia/program/Learn/docs/07-database-design.md`

- [ ] **Step 1: Add local-first implementation note**
- [ ] **Step 2: Clarify current local DB vs future cloud mapping**
- [ ] **Step 3: Preserve logical schema while adding migration constraints**

### Task 4: Rewrite the deployment guide

**Files:**
- Modify: `/Users/xia/program/Learn/docs/09-deployment-guide.md`

- [ ] **Step 1: Replace outdated cluster-first guidance**
- [ ] **Step 2: Document local development and integration deployment**
- [ ] **Step 3: Add future CloudBase migration path**

### Task 5: Align supporting specs

**Files:**
- Modify: `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-feature-gap-and-priority-analysis.md`
- Modify: `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-frontend-logic-confirmation-and-optimization-design.md`

- [ ] **Step 1: Clarify local backend priority**
- [ ] **Step 2: Replace direct-cloud assumptions with local FastAPI assumptions**

### Task 6: Review and commit

**Files:**
- Modify: all changed docs

- [ ] **Step 1: Read changed docs for consistency**
- [ ] **Step 2: Check `git diff --stat`**
- [ ] **Step 3: Commit doc updates**
