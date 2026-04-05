# LearnAI Benchmark-Inspired Frontend Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade the current Flutter frontend from a high-fidelity visual prototype into a task-driven, stateful learning experience that feels coherent across `Home`, `Chat`, `Review`, `Roadmap`, and `Profile & Analytics`.

**Architecture:** Keep this phase frontend-only and local-first. Introduce Riverpod-backed local session state, review state, roadmap state, and settings state so the app can demonstrate realistic behavior without waiting on backend APIs. Build reusable status-feedback primitives and wire every major CTA to predictable local behavior, while preserving the existing Stitch-inspired visual language.

**Tech Stack:** Flutter, Dart, Material 3, flutter_riverpod, go_router, flutter_test

---

## File Structure

### Modify

- `flutter_app/lib/src/app/router/app_router.dart`
- `flutter_app/lib/src/features/home/presentation/home_screen.dart`
- `flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- `flutter_app/lib/src/features/review/presentation/review_screen.dart`
- `flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- `flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- `flutter_app/lib/src/shared/layout/app_scaffold_shell.dart`
- `flutter_app/lib/src/shared/mock/mock_learning_data.dart`
- `flutter_app/test/features/home/home_screen_test.dart`
- `flutter_app/test/features/chat/chat_screen_test.dart`
- `flutter_app/test/features/review/review_screen_test.dart`
- `flutter_app/test/features/roadmap/roadmap_screen_test.dart`
- `flutter_app/test/features/profile/profile_analytics_screen_test.dart`
- `flutter_app/test/features/navigation/secondary_navigation_test.dart`

### Create

- `flutter_app/lib/src/features/home/application/home_dashboard_provider.dart`
- `flutter_app/lib/src/features/chat/application/chat_session_controller.dart`
- `flutter_app/lib/src/features/review/application/review_queue_provider.dart`
- `flutter_app/lib/src/features/roadmap/application/roadmap_progress_provider.dart`
- `flutter_app/lib/src/features/profile/application/profile_preferences_provider.dart`
- `flutter_app/lib/src/shared/models/home_dashboard_models.dart`
- `flutter_app/lib/src/shared/models/chat_session_models.dart`
- `flutter_app/lib/src/shared/models/review_models.dart`
- `flutter_app/lib/src/shared/models/roadmap_models.dart`
- `flutter_app/lib/src/shared/models/profile_models.dart`
- `flutter_app/lib/src/shared/widgets/status_message_card.dart`
- `flutter_app/lib/src/shared/widgets/task_stage_stepper.dart`
- `flutter_app/lib/src/shared/widgets/context_action_chips.dart`
- `flutter_app/lib/src/shared/widgets/empty_state_card.dart`
- `flutter_app/test/features/chat/chat_session_controller_test.dart`
- `flutter_app/test/features/review/review_queue_provider_test.dart`
- `flutter_app/test/features/profile/profile_preferences_provider_test.dart`

### Reference Before Coding

- `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-05-benchmark-inspired-frontend-optimization-design.md`
- `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-frontend-logic-confirmation-and-optimization-design.md`
- `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-feature-gap-and-priority-analysis.md`
- `/Users/xia/program/Learn/skills/guided-learning-coach/SKILL.md`
- `/Users/xia/program/Learn/skills/guided-learning-coach/references/interaction-patterns.md`
- `/Users/xia/program/Learn/skills/guided-learning-coach/references/review-schedules.md`

### Constraints

- This plan does **not** add backend APIs or local database persistence yet.
- Every primary button must do something visible by the end of this phase.
- Every primary screen must have at least one `loading`, `empty`, or `feedback` state, even if it is mock-driven.
- Keep Chinese and English copy aligned; new UI cannot regress Chinese readability.

## Task 1: Introduce Local Learning State And UI Feedback Primitives

**Files:**
- Create: `flutter_app/lib/src/shared/models/home_dashboard_models.dart`
- Create: `flutter_app/lib/src/shared/models/chat_session_models.dart`
- Create: `flutter_app/lib/src/shared/models/review_models.dart`
- Create: `flutter_app/lib/src/shared/models/roadmap_models.dart`
- Create: `flutter_app/lib/src/shared/models/profile_models.dart`
- Create: `flutter_app/lib/src/features/home/application/home_dashboard_provider.dart`
- Create: `flutter_app/lib/src/features/chat/application/chat_session_controller.dart`
- Create: `flutter_app/lib/src/features/review/application/review_queue_provider.dart`
- Create: `flutter_app/lib/src/features/roadmap/application/roadmap_progress_provider.dart`
- Create: `flutter_app/lib/src/features/profile/application/profile_preferences_provider.dart`
- Create: `flutter_app/lib/src/shared/widgets/status_message_card.dart`
- Create: `flutter_app/lib/src/shared/widgets/empty_state_card.dart`
- Modify: `flutter_app/lib/src/shared/mock/mock_learning_data.dart`
- Test: `flutter_app/test/features/chat/chat_session_controller_test.dart`
- Test: `flutter_app/test/features/review/review_queue_provider_test.dart`
- Test: `flutter_app/test/features/profile/profile_preferences_provider_test.dart`

- [ ] **Step 1: Write the failing provider tests**

```dart
test('chat controller advances from explain to example after submit', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final notifier = container.read(chatSessionControllerProvider.notifier);
  notifier.updateDraft('Justice is deeper than law.');
  notifier.submitDraft();

  final state = container.read(chatSessionControllerProvider);
  expect(state.currentStage, ChatPromptStage.example);
  expect(state.messages.last.role, ChatMessageRole.coach);
});
```

```dart
test('review queue groups items by urgency', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final queue = container.read(reviewQueueProvider);
  expect(queue.dueToday, isNotEmpty);
  expect(queue.upNext, isNotEmpty);
});
```

```dart
test('profile preferences can switch app language and reminder cadence', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final notifier = container.read(profilePreferencesProvider.notifier);
  notifier.setReminderHour(20);

  expect(container.read(profilePreferencesProvider).reminderHour, 20);
});
```

- [ ] **Step 2: Run the focused tests to verify they fail**

Run:
- `flutter test test/features/chat/chat_session_controller_test.dart`
- `flutter test test/features/review/review_queue_provider_test.dart`
- `flutter test test/features/profile/profile_preferences_provider_test.dart`

Expected: FAIL because the models, providers, and controllers do not exist yet.

- [ ] **Step 3: Implement the local state layer**

Implement a small but explicit local domain model:

- `home_dashboard_models.dart`
  - current task summary
  - today loop completion flags
  - exploration suggestion metadata
- `chat_session_models.dart`
  - `ChatPromptStage` enum: `explain`, `example`, `compare`, `transfer`
  - `ChatMessageRole` enum: `coach`, `learner`, `system`
  - session state: draft, current question index, stage, helper state, feedback banner
- `review_models.dart`
  - due-today items
  - up-next items
  - completed-today items
  - review reason label
- `roadmap_models.dart`
  - active node
  - next node
  - unlock reason
  - branch queue item
- `profile_models.dart`
  - app language
  - reminder hour
  - digest day
  - offline-ready flag

Implement providers/controllers so later UI work can consume these states without new rewrites.

- [ ] **Step 4: Add reusable status-feedback primitives**

Create:

- `StatusMessageCard`
  - success/info/warning tone
  - compact title + description
- `EmptyStateCard`
  - icon, title, body, optional action

These widgets will be reused by `Home`, `Review`, and `Profile`.

- [ ] **Step 5: Re-run the focused tests**

Run:
- `flutter test test/features/chat/chat_session_controller_test.dart`
- `flutter test test/features/review/review_queue_provider_test.dart`
- `flutter test test/features/profile/profile_preferences_provider_test.dart`

Expected: PASS

- [ ] **Step 6: Run analyzer**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add flutter_app/lib/src/shared/models flutter_app/lib/src/features/home/application flutter_app/lib/src/features/chat/application flutter_app/lib/src/features/review/application flutter_app/lib/src/features/roadmap/application flutter_app/lib/src/features/profile/application flutter_app/lib/src/shared/widgets flutter_app/lib/src/shared/mock/mock_learning_data.dart flutter_app/test/features/chat/chat_session_controller_test.dart flutter_app/test/features/review/review_queue_provider_test.dart flutter_app/test/features/profile/profile_preferences_provider_test.dart
git commit -m "feat: add local frontend learning state"
```

## Task 2: Rework Home Into A Real Today Console

**Files:**
- Modify: `flutter_app/lib/src/features/home/presentation/home_screen.dart`
- Modify: `flutter_app/lib/src/shared/layout/app_scaffold_shell.dart`
- Modify: `flutter_app/test/features/home/home_screen_test.dart`
- Reuse: `flutter_app/lib/src/features/home/application/home_dashboard_provider.dart`
- Reuse: `flutter_app/lib/src/shared/widgets/status_message_card.dart`
- Reuse: `flutter_app/lib/src/shared/widgets/empty_state_card.dart`

- [ ] **Step 1: Expand the failing Home test**

Add assertions for:

- one dominant CTA
- last session checkpoint copy
- today loop card
- main-path-afterward exploration card
- stateful task labels instead of static showcase labels

```dart
expect(find.text('Continue current learning'), findsOneWidget);
expect(find.textContaining('You paused at'), findsOneWidget);
expect(find.text('Today loop'), findsOneWidget);
expect(find.text('Explore after the main path'), findsOneWidget);
```

- [ ] **Step 2: Run the Home test to verify it fails**

Run: `flutter test test/features/home/home_screen_test.dart`
Expected: FAIL because the current Home page is still a stitched showcase, not a task console.

- [ ] **Step 3: Implement the Home dashboard redesign**

Update `HomeScreen` so it clearly answers:

- what should the learner do first
- where did they stop last time
- what must be finished today
- what is worth exploring after the main path

Concrete UI changes:

- Hero area with one primary CTA only
- replace broad stat chips with concise loop status
- add a `Today loop` card with:
  - main inquiry status
  - today review status
  - session wrap-up status
- add one exploration card explicitly tied to the current roadmap topic
- show a compact status banner when the user returns from review or chat routes

- [ ] **Step 4: Ensure Home actions use real local state**

Wire buttons to meaningful behavior:

- primary CTA -> `/chat`
- alternate review CTA -> `/review`
- roadmap CTA -> `/roadmap`
- insight CTA -> `/profile`

The screen content must read from `homeDashboardProvider`, not hard-coded page text.

- [ ] **Step 5: Re-run Home verification**

Run:
- `flutter test test/features/home/home_screen_test.dart`
- `flutter test test/features/navigation/secondary_navigation_test.dart`

Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/home/presentation/home_screen.dart flutter_app/lib/src/shared/layout/app_scaffold_shell.dart flutter_app/test/features/home/home_screen_test.dart flutter_app/test/features/navigation/secondary_navigation_test.dart
git commit -m "feat: turn home into a task-driven dashboard"
```

## Task 3: Upgrade Chat Into A Stateful Learning Workspace

**Files:**
- Modify: `flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- Modify: `flutter_app/test/features/chat/chat_screen_test.dart`
- Reuse: `flutter_app/lib/src/features/chat/application/chat_session_controller.dart`
- Create: `flutter_app/lib/src/shared/widgets/task_stage_stepper.dart`
- Create: `flutter_app/lib/src/shared/widgets/context_action_chips.dart`

- [ ] **Step 1: Expand the failing Chat widget test**

Add assertions for:

- task card
- stage stepper
- helper actions
- draft submission feedback

```dart
expect(find.text('Current task'), findsOneWidget);
expect(find.text('Explain'), findsOneWidget);
expect(find.text('Give me a hint'), findsOneWidget);
expect(find.text('Teach it another way'), findsOneWidget);
expect(find.text('I still do not get it'), findsOneWidget);
```

- [ ] **Step 2: Run Chat tests to verify they fail**

Run:
- `flutter test test/features/chat/chat_screen_test.dart`
- `flutter test test/features/chat/chat_session_controller_test.dart`

Expected: FAIL because the current screen has no task card, no stepper, and no local message flow.

- [ ] **Step 3: Implement the chat workspace**

Build these UI layers:

- `Current task` card
  - topic
  - current stage
  - success condition for this turn
- `TaskStageStepper`
  - `Explain`
  - `Example`
  - `Compare`
  - `Transfer`
- `ContextActionChips`
  - `Give me a hint`
  - `Teach it another way`
  - `I still do not get it`

Behavior:

- draft lives in `chatSessionController`
- submit appends learner message locally
- show a short in-page thinking state
- append next coach prompt
- update stage when appropriate
- helper actions create visible feedback and next-step copy

- [ ] **Step 4: Keep existing detail routes contextual**

Do not remove these routes:

- `/chat/focus`
- `/chat/thinking`
- `/chat/multimodal`

But make sure the entry copy clearly frames them as extensions of the same active session, not detached showcase pages.

- [ ] **Step 5: Re-run Chat verification**

Run:
- `flutter test test/features/chat/chat_screen_test.dart`
- `flutter test test/features/chat/chat_detail_screens_test.dart`
- `flutter test test/features/chat/chat_session_controller_test.dart`

Expected: PASS

- [ ] **Step 6: Run analyzer**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add flutter_app/lib/src/features/chat/presentation/chat_screen.dart flutter_app/lib/src/shared/widgets/task_stage_stepper.dart flutter_app/lib/src/shared/widgets/context_action_chips.dart flutter_app/test/features/chat/chat_screen_test.dart flutter_app/test/features/chat/chat_detail_screens_test.dart flutter_app/test/features/chat/chat_session_controller_test.dart
git commit -m "feat: add stateful chat learning workspace"
```

## Task 4: Turn Review Into An Executable Review Queue

**Files:**
- Modify: `flutter_app/lib/src/features/review/presentation/review_screen.dart`
- Modify: `flutter_app/test/features/review/review_screen_test.dart`
- Reuse: `flutter_app/lib/src/features/review/application/review_queue_provider.dart`
- Reuse: `flutter_app/lib/src/shared/widgets/status_message_card.dart`
- Reuse: `flutter_app/lib/src/shared/widgets/empty_state_card.dart`

- [ ] **Step 1: Expand the failing Review test**

Add assertions for:

- due today section
- up next section
- completed today section
- explicit reason labels

```dart
expect(find.text('Due today'), findsOneWidget);
expect(find.text('Up next'), findsOneWidget);
expect(find.text('Completed today'), findsOneWidget);
expect(find.textContaining('Review now because'), findsWidgets);
```

- [ ] **Step 2: Run Review tests to verify they fail**

Run:
- `flutter test test/features/review/review_screen_test.dart`
- `flutter test test/features/review/review_queue_provider_test.dart`

Expected: FAIL because the current Review page is still a layout page, not a queue-based review center.

- [ ] **Step 3: Implement the review queue redesign**

Update `ReviewScreen` to include:

- `Due today`
  - the items that must be reviewed now
- `Up next`
  - lower-urgency items
- `Completed today`
  - recently closed review tasks
- `Why now`
  - one-line explanation for each active review item
- one fast entry point into quiz or mistake review

Use `ReviewQueueProvider` as the single source of truth.

- [ ] **Step 4: Make review actions visibly stateful**

At minimum:

- opening quiz and returning can show updated completion feedback
- completing a review item can move it between sections in local state
- if the due-today queue is empty, show an `EmptyStateCard` instead of blank space

- [ ] **Step 5: Re-run Review verification**

Run:
- `flutter test test/features/review/review_screen_test.dart`
- `flutter test test/features/review/review_detail_screens_test.dart`
- `flutter test test/features/review/review_queue_provider_test.dart`

Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/review/presentation/review_screen.dart flutter_app/test/features/review/review_screen_test.dart flutter_app/test/features/review/review_detail_screens_test.dart flutter_app/test/features/review/review_queue_provider_test.dart
git commit -m "feat: make review a task queue"
```

## Task 5: Clarify Roadmap Progression And Branching

**Files:**
- Modify: `flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- Modify: `flutter_app/test/features/roadmap/roadmap_screen_test.dart`
- Reuse: `flutter_app/lib/src/features/roadmap/application/roadmap_progress_provider.dart`

- [ ] **Step 1: Expand the failing Roadmap test**

Add assertions for:

- stage goal copy
- unlock condition copy
- why-this-next explanation
- branch queue section

```dart
expect(find.text('Current stage goal'), findsOneWidget);
expect(find.text('Why this is next'), findsOneWidget);
expect(find.text('Unlock by'), findsWidgets);
expect(find.text('Saved branches'), findsOneWidget);
```

- [ ] **Step 2: Run the Roadmap test to verify it fails**

Run: `flutter test test/features/roadmap/roadmap_screen_test.dart`
Expected: FAIL because the current Roadmap screen lacks explicit goal, unlock, and branch states.

- [ ] **Step 3: Implement progression-aware roadmap content**

Update `RoadmapScreen` so the learner can immediately understand:

- current stage goal
- current active node
- what unlocks next
- why the next node follows logically
- what interesting branches have been saved for later

Use `roadmapProgressProvider` for all stage labels, not hard-coded strings.

- [ ] **Step 4: Wire the Continue Learning CTA**

`Continue Learning` must route to `/chat` and conceptually point to the active node from roadmap state.

- [ ] **Step 5: Re-run Roadmap verification**

Run:
- `flutter test test/features/roadmap/roadmap_screen_test.dart`
- `flutter test test/features/roadmap/knowledge_graph_screen_test.dart`

Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart flutter_app/test/features/roadmap/roadmap_screen_test.dart flutter_app/test/features/roadmap/knowledge_graph_screen_test.dart
git commit -m "feat: clarify roadmap progression"
```

## Task 6: Strengthen Profile Into A Real Control Center

**Files:**
- Modify: `flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- Modify: `flutter_app/test/features/profile/profile_analytics_screen_test.dart`
- Reuse: `flutter_app/lib/src/features/profile/application/profile_preferences_provider.dart`
- Reuse: `flutter_app/lib/src/shared/widgets/status_message_card.dart`

- [ ] **Step 1: Expand the failing Profile test**

Add assertions for:

- reminder controls
- sync status copy
- study goal preference copy
- stronger connection between analytics and achievements

```dart
expect(find.text('Reminder time'), findsOneWidget);
expect(find.text('Sync status'), findsOneWidget);
expect(find.text('Daily study target'), findsOneWidget);
expect(find.text('Achievement momentum'), findsOneWidget);
```

- [ ] **Step 2: Run the Profile test to verify it fails**

Run:
- `flutter test test/features/profile/profile_analytics_screen_test.dart`
- `flutter test test/features/profile/profile_preferences_provider_test.dart`

Expected: FAIL because the current profile page does not yet behave like a control center.

- [ ] **Step 3: Implement profile control-center improvements**

Update `ProfileAnalyticsScreen` to include:

- reminder time row
- digest cadence row
- sync status row
- local cache availability row
- daily study target summary
- an explicit bridge between achievement progress and analytics trends

Keep the existing language switch and ensure it still works.

- [ ] **Step 4: Make settings visibly interactive**

At minimum:

- changing reminder time updates local state
- toggling one preference shows immediate UI feedback
- sync status reads from profile preferences model, not static text

- [ ] **Step 5: Re-run Profile verification**

Run:
- `flutter test test/features/profile/profile_analytics_screen_test.dart`
- `flutter test test/features/profile/profile_detail_screens_test.dart`
- `flutter test test/features/profile/profile_preferences_provider_test.dart`

Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart flutter_app/test/features/profile/profile_analytics_screen_test.dart flutter_app/test/features/profile/profile_detail_screens_test.dart flutter_app/test/features/profile/profile_preferences_provider_test.dart
git commit -m "feat: improve profile control center"
```

## Task 7: Integration Polish, Route Safety, And Regression Coverage

**Files:**
- Modify: `flutter_app/lib/src/app/router/app_router.dart`
- Modify: `flutter_app/test/features/navigation/secondary_navigation_test.dart`
- Modify: `flutter_app/test/app/app_shell_test.dart`
- Review: all files touched in Tasks 1-6

- [ ] **Step 1: Add regression expectations for route continuity**

Extend navigation tests so they assert:

- Home -> Chat
- Home -> Review
- Roadmap -> Chat
- Profile language toggle survives route changes within the session
- detail pages still open without breaking shell navigation

```dart
expect(find.text('Current task'), findsOneWidget);
expect(find.text('Due today'), findsOneWidget);
```

- [ ] **Step 2: Run navigation tests to verify current gaps**

Run:
- `flutter test test/features/navigation/secondary_navigation_test.dart`
- `flutter test test/app/app_shell_test.dart`

Expected: FAIL if routes or shell state still assume static screen behavior.

- [ ] **Step 3: Tighten routing and shell behavior**

Verify these rules:

- no tab switch should feel like a detached demo jump
- no primary route should land on a blank or misleading state
- detail routes should preserve back navigation expectations
- no button should silently no-op

If a feature still lacks full business logic, surface a visible status card or snackbar instead of leaving the action inert.

- [ ] **Step 4: Run full verification**

Run:
- `flutter analyze`
- `flutter test`
- `flutter build web`

Expected:
- analyzer clean
- all tests PASS
- web build succeeds

- [ ] **Step 5: Commit**

```bash
git add flutter_app/lib/src/app/router/app_router.dart flutter_app/test/features/navigation/secondary_navigation_test.dart flutter_app/test/app/app_shell_test.dart flutter_app/lib/src flutter_app/test
git commit -m "feat: polish learning flow continuity"
```

## Acceptance Checklist

- [ ] `Home` opens with one dominant next action and clear session continuity
- [ ] `Chat` supports draft, local submit, helper actions, and visible stage progression
- [ ] `Review` behaves like a queue, not a static showcase
- [ ] `Roadmap` explains current goal, next unlock, and saved branches
- [ ] `Profile` behaves like a control center, not just a stats board
- [ ] Chinese and English both remain readable after new copy is added
- [ ] No primary CTA is left as a silent no-op
- [ ] `flutter analyze`, `flutter test`, and `flutter build web` all pass

## Out Of Scope For This Plan

- Local database persistence
- Remote API integration
- Real LLM request orchestration
- Auth flows
- Push notification delivery

These belong in the next plan: `frontend state + local database + minimal backend integration`.
