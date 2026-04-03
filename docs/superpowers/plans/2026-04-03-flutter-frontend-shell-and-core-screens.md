# LearnAI Flutter Frontend Shell And Core Screens Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Flutter app shell, bottom navigation, core screen templates, and first-pass secondary routes for LearnAI using Stitch as the current design source and local mock data as the initial runtime model.

**Architecture:** Use a feature-first Flutter structure under `lib/src`, with `flutter_riverpod` for app state, `go_router` for the tab shell and nested routes, and a local-first mock data layer that can be replaced by real repositories later. Phase 1 focuses on visual and interaction scaffolding only: no backend integration, no persistent storage writes, and no production AI calls yet.

**Tech Stack:** Flutter, Dart, Material 3, flutter_riverpod, go_router, flutter_test

---

## File Structure

### Modify

- `flutter_app/pubspec.yaml`
- `flutter_app/lib/main.dart`
- `flutter_app/test/widget_test.dart`

### Create

- `flutter_app/lib/src/app/app.dart`
- `flutter_app/lib/src/app/router/app_router.dart`
- `flutter_app/lib/src/app/theme/app_theme.dart`
- `flutter_app/lib/src/app/theme/app_colors.dart`
- `flutter_app/lib/src/app/theme/app_text_styles.dart`
- `flutter_app/lib/src/features/navigation/presentation/app_shell.dart`
- `flutter_app/lib/src/features/navigation/presentation/app_bottom_nav.dart`
- `flutter_app/lib/src/features/home/presentation/home_screen.dart`
- `flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- `flutter_app/lib/src/features/review/presentation/review_screen.dart`
- `flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- `flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- `flutter_app/lib/src/features/review/presentation/review_schedule_screen.dart`
- `flutter_app/lib/src/features/review/presentation/review_mistakes_screen.dart`
- `flutter_app/lib/src/features/review/presentation/mastery_quiz_screen.dart`
- `flutter_app/lib/src/features/review/presentation/quiz_results_screen.dart`
- `flutter_app/lib/src/features/roadmap/presentation/knowledge_graph_screen.dart`
- `flutter_app/lib/src/features/profile/presentation/learning_insights_screen.dart`
- `flutter_app/lib/src/features/profile/presentation/achievements_gallery_screen.dart`
- `flutter_app/lib/src/features/chat/presentation/focus_mode_screen.dart`
- `flutter_app/lib/src/features/chat/presentation/multimodal_input_screen.dart`
- `flutter_app/lib/src/shared/layout/app_scaffold_shell.dart`
- `flutter_app/lib/src/shared/widgets/section_card.dart`
- `flutter_app/lib/src/shared/widgets/primary_action_button.dart`
- `flutter_app/lib/src/shared/widgets/progress_badge.dart`
- `flutter_app/lib/src/shared/mock/mock_learning_data.dart`
- `flutter_app/test/app/app_shell_test.dart`
- `flutter_app/test/features/navigation/bottom_navigation_test.dart`
- `flutter_app/test/features/home/home_screen_test.dart`
- `flutter_app/test/features/chat/chat_screen_test.dart`
- `flutter_app/test/features/roadmap/roadmap_screen_test.dart`
- `flutter_app/test/features/review/review_screen_test.dart`
- `flutter_app/test/features/profile/profile_analytics_screen_test.dart`

### Reference Before Coding

- `/Users/xia/program/Learn/docs/superpowers/specs/2026-04-03-learning-app-page-structure-design.md`
- `/Users/xia/program/Learn/docs/02-technical-architecture.md`
- Stitch project `projects/11966180925757169298`

## Task 1: Replace Template App With Routed Application Shell

**Files:**
- Modify: `flutter_app/pubspec.yaml`
- Modify: `flutter_app/lib/main.dart`
- Modify: `flutter_app/test/widget_test.dart`
- Create: `flutter_app/lib/src/app/app.dart`
- Create: `flutter_app/lib/src/app/router/app_router.dart`
- Create: `flutter_app/lib/src/features/navigation/presentation/app_shell.dart`
- Create: `flutter_app/lib/src/features/navigation/presentation/app_bottom_nav.dart`
- Test: `flutter_app/test/app/app_shell_test.dart`

- [ ] **Step 1: Write the failing app shell test**

```dart
testWidgets('boots into Home with five bottom tabs', (tester) async {
  await tester.pumpWidget(const ProviderScope(child: LearnAiApp()));

  expect(find.text('Home'), findsWidgets);
  expect(find.text('Roadmap'), findsOneWidget);
  expect(find.text('Review'), findsOneWidget);
  expect(find.text('Socratic Chat'), findsOneWidget);
  expect(find.text('Profile & Analytics'), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/app/app_shell_test.dart`
Expected: FAIL because `LearnAiApp`, router, and shell do not exist yet.

- [ ] **Step 3: Add routing dependencies and implement the shell**

Add these dependencies:

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1
```

Implement:

- `main.dart` as a minimal bootstrap using `ProviderScope`
- `LearnAiApp` in `lib/src/app/app.dart`
- `GoRouter` setup with five tab roots
- `app_shell.dart` with a `StatefulNavigationShell` or equivalent indexed tab shell
- `app_bottom_nav.dart` with the five agreed tab labels

- [ ] **Step 4: Run the focused test to verify it passes**

Run: `flutter test test/app/app_shell_test.dart`
Expected: PASS

- [ ] **Step 5: Run app-wide smoke verification**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add flutter_app/pubspec.yaml flutter_app/lib/main.dart flutter_app/lib/src/app flutter_app/lib/src/features/navigation flutter_app/test/app/app_shell_test.dart
git commit -m "feat: add flutter app shell and bottom navigation"
```

## Task 2: Establish Theme Tokens From Stitch Design System

**Files:**
- Create: `flutter_app/lib/src/app/theme/app_theme.dart`
- Create: `flutter_app/lib/src/app/theme/app_colors.dart`
- Create: `flutter_app/lib/src/app/theme/app_text_styles.dart`
- Modify: `flutter_app/lib/src/app/app.dart`
- Test: `flutter_app/test/app/app_shell_test.dart`

- [ ] **Step 1: Extend the app shell test to assert branded app identity**

```dart
expect(find.text('Today'), findsOneWidget);
```

This should fail until branded page content and theme-backed shell content exist.

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/app/app_shell_test.dart`
Expected: FAIL because the current shell has no branded content.

- [ ] **Step 3: Implement theme tokens**

Reflect the Stitch design system in code:

- Indigo-led color palette
- warm surface hierarchy
- mint accent for progress and celebration
- Manrope-style heading scale
- Inter-style body and label scale
- card-first, low-border visual language

Expose:

- `AppColors`
- `AppTextStyles`
- `buildAppTheme()`

- [ ] **Step 4: Apply the theme to `LearnAiApp` and ensure the initial screen uses it**

The `Home` tab should render with the new theme, not Flutter defaults.

- [ ] **Step 5: Re-run verification**

Run:
- `flutter test test/app/app_shell_test.dart`
- `flutter analyze`

Expected:
- app shell test PASS
- analyzer clean

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/app/theme flutter_app/lib/src/app/app.dart flutter_app/test/app/app_shell_test.dart
git commit -m "feat: add LearnAI app theme tokens"
```

## Task 3: Build Shared Layout And Mock Data Layer

**Files:**
- Create: `flutter_app/lib/src/shared/layout/app_scaffold_shell.dart`
- Create: `flutter_app/lib/src/shared/widgets/section_card.dart`
- Create: `flutter_app/lib/src/shared/widgets/primary_action_button.dart`
- Create: `flutter_app/lib/src/shared/widgets/progress_badge.dart`
- Create: `flutter_app/lib/src/shared/mock/mock_learning_data.dart`
- Test: `flutter_app/test/features/home/home_screen_test.dart`

- [ ] **Step 1: Write the failing Home scaffold test**

```dart
testWidgets('Home shows learning task and review task cards', (tester) async {
  await tester.pumpWidget(makeTestableApp(const HomeScreen()));

  expect(find.text('Continue Learning'), findsOneWidget);
  expect(find.text('Today Review'), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/home/home_screen_test.dart`
Expected: FAIL because shared widgets and mock data do not exist.

- [ ] **Step 3: Implement shared scaffolding**

Create:

- a reusable screen shell for top spacing and safe-area layout
- a generic section card
- a primary CTA button
- a progress badge/chip
- mock content that matches the page-structure spec

- [ ] **Step 4: Re-run the focused test**

Run: `flutter test test/features/home/home_screen_test.dart`
Expected: PASS once the reusable scaffolding is available and `HomeScreen` can consume it.

- [ ] **Step 5: Run analyzer**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/shared flutter_app/test/features/home/home_screen_test.dart
git commit -m "feat: add shared layout widgets and mock learning data"
```

## Task 4: Implement Home As The Learning Control Center

**Files:**
- Create: `flutter_app/lib/src/features/home/presentation/home_screen.dart`
- Modify: `flutter_app/lib/src/features/navigation/presentation/app_shell.dart`
- Test: `flutter_app/test/features/home/home_screen_test.dart`

- [ ] **Step 1: Expand the Home test with concrete expectations**

Assert these sections exist:

- welcome summary
- continue learning card
- review shortcut
- roadmap shortcut
- analytics shortcut
- achievement shortcut

- [ ] **Step 2: Run the focused Home test to verify it fails**

Run: `flutter test test/features/home/home_screen_test.dart`
Expected: FAIL because the final section set is not implemented yet.

- [ ] **Step 3: Implement `HomeScreen`**

Build the page from Stitch + spec:

- top summary hero
- today learning block
- today review block
- current roadmap block
- insights summary block
- achievement entry block

Wire buttons to the agreed routes, even if target pages are placeholders at this point.

- [ ] **Step 4: Re-run the focused Home test**

Run: `flutter test test/features/home/home_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Verify shell integration**

Run: `flutter test test/app/app_shell_test.dart`
Expected: PASS with Home as the default tab.

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/home flutter_app/lib/src/features/navigation/presentation/app_shell.dart flutter_app/test/features/home/home_screen_test.dart
git commit -m "feat: implement home screen shell"
```

## Task 5: Implement Socratic Chat As The Primary Learning Workspace

**Files:**
- Create: `flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- Create: `flutter_app/lib/src/features/chat/presentation/focus_mode_screen.dart`
- Create: `flutter_app/lib/src/features/chat/presentation/multimodal_input_screen.dart`
- Test: `flutter_app/test/features/chat/chat_screen_test.dart`

- [ ] **Step 1: Write the failing chat test**

```dart
testWidgets('Chat shows current topic, ai prompt, and input area', (tester) async {
  await tester.pumpWidget(makeTestableApp(const ChatScreen()));

  expect(find.textContaining('Current Topic'), findsOneWidget);
  expect(find.byType(TextField), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/chat/chat_screen_test.dart`
Expected: FAIL because chat screens do not exist.

- [ ] **Step 3: Implement the core chat layout**

Include:

- topic header
- AI conversation card
- user response composer
- hint / reteach affordance
- shortcuts to focus mode and multimodal input

Represent `AI Thinking State` inline as a render state of the chat screen, not as a separate root route.

- [ ] **Step 4: Re-run the focused test**

Run: `flutter test test/features/chat/chat_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Verify navigation**

Run: `flutter test test/features/navigation/bottom_navigation_test.dart`
Expected: PASS after tapping the `Socratic Chat` tab.

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/chat flutter_app/test/features/chat/chat_screen_test.dart flutter_app/test/features/navigation/bottom_navigation_test.dart
git commit -m "feat: implement socratic chat shell"
```

## Task 6: Implement Roadmap And Knowledge Graph Entry

**Files:**
- Create: `flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- Create: `flutter_app/lib/src/features/roadmap/presentation/knowledge_graph_screen.dart`
- Test: `flutter_app/test/features/roadmap/roadmap_screen_test.dart`

- [ ] **Step 1: Write the failing roadmap test**

```dart
testWidgets('Roadmap shows stages and start-learning action', (tester) async {
  await tester.pumpWidget(makeTestableApp(const RoadmapScreen()));

  expect(find.text('Current Roadmap'), findsOneWidget);
  expect(find.text('Start This Node'), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/roadmap/roadmap_screen_test.dart`
Expected: FAIL because roadmap pages do not exist.

- [ ] **Step 3: Implement roadmap UI**

Include:

- roadmap summary
- stage cards
- current node detail
- CTA to enter chat
- CTA to open knowledge graph

- [ ] **Step 4: Re-run the focused roadmap test**

Run: `flutter test test/features/roadmap/roadmap_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Verify navigation from shell**

Run: `flutter test test/features/navigation/bottom_navigation_test.dart`
Expected: PASS when switching to `Roadmap`.

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/roadmap flutter_app/test/features/roadmap/roadmap_screen_test.dart flutter_app/test/features/navigation/bottom_navigation_test.dart
git commit -m "feat: implement roadmap screens"
```

## Task 7: Implement Review Flow Skeleton

**Files:**
- Create: `flutter_app/lib/src/features/review/presentation/review_screen.dart`
- Create: `flutter_app/lib/src/features/review/presentation/review_schedule_screen.dart`
- Create: `flutter_app/lib/src/features/review/presentation/review_mistakes_screen.dart`
- Create: `flutter_app/lib/src/features/review/presentation/mastery_quiz_screen.dart`
- Create: `flutter_app/lib/src/features/review/presentation/quiz_results_screen.dart`
- Test: `flutter_app/test/features/review/review_screen_test.dart`

- [ ] **Step 1: Write the failing review test**

```dart
testWidgets('Review shows schedule, weak points, and quiz entry', (tester) async {
  await tester.pumpWidget(makeTestableApp(const ReviewScreen()));

  expect(find.text('Review Schedule'), findsOneWidget);
  expect(find.text('Weak Points'), findsOneWidget);
  expect(find.text('Mastery Quiz'), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/review/review_screen_test.dart`
Expected: FAIL because review pages do not exist.

- [ ] **Step 3: Implement review pages**

Build:

- review hub
- schedule page
- mistakes detail page
- mastery quiz starter
- quiz results summary

Keep quiz interactions mock-driven in this phase.

- [ ] **Step 4: Re-run the focused test**

Run: `flutter test test/features/review/review_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Verify route wiring**

Run: `flutter test test/features/navigation/bottom_navigation_test.dart`
Expected: PASS when moving from `Review` to its child routes.

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/review flutter_app/test/features/review/review_screen_test.dart flutter_app/test/features/navigation/bottom_navigation_test.dart
git commit -m "feat: implement review flow skeleton"
```

## Task 8: Implement Profile & Analytics Flow

**Files:**
- Create: `flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- Create: `flutter_app/lib/src/features/profile/presentation/learning_insights_screen.dart`
- Create: `flutter_app/lib/src/features/profile/presentation/achievements_gallery_screen.dart`
- Test: `flutter_app/test/features/profile/profile_analytics_screen_test.dart`

- [ ] **Step 1: Write the failing profile test**

```dart
testWidgets('Profile & Analytics shows stats, streak, and achievements entry', (tester) async {
  await tester.pumpWidget(makeTestableApp(const ProfileAnalyticsScreen()));

  expect(find.text('Learning Insights'), findsOneWidget);
  expect(find.text('Achievements'), findsOneWidget);
});
```

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/features/profile/profile_analytics_screen_test.dart`
Expected: FAIL because profile pages do not exist.

- [ ] **Step 3: Implement the profile and analytics screens**

Include:

- user summary card
- learning metrics
- streak and consistency block
- achievements entry
- settings entry placeholder

- [ ] **Step 4: Re-run the focused test**

Run: `flutter test test/features/profile/profile_analytics_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Verify shell routing**

Run: `flutter test test/features/navigation/bottom_navigation_test.dart`
Expected: PASS when selecting `Profile & Analytics`.

- [ ] **Step 6: Commit**

```bash
git add flutter_app/lib/src/features/profile flutter_app/test/features/profile/profile_analytics_screen_test.dart flutter_app/test/features/navigation/bottom_navigation_test.dart
git commit -m "feat: implement profile and analytics flow"
```

## Task 9: Clean Up Template Tests And Add Navigation Regression Coverage

**Files:**
- Modify: `flutter_app/test/widget_test.dart`
- Create: `flutter_app/test/features/navigation/bottom_navigation_test.dart`

- [ ] **Step 1: Replace the counter test with route regression tests**

Add cases for:

- default route lands on `Home`
- tapping each bottom tab changes visible page
- tapping Home CTA opens a child route

- [ ] **Step 2: Run navigation tests to verify failures before final fixes**

Run: `flutter test test/features/navigation/bottom_navigation_test.dart`
Expected: FAIL until all routes are wired correctly.

- [ ] **Step 3: Remove template-only counter assumptions**

Delete all counter-specific expectations from `widget_test.dart` and replace them with app-level smoke coverage.

- [ ] **Step 4: Re-run all tests**

Run: `flutter test`
Expected: PASS

- [ ] **Step 5: Run final static verification**

Run:
- `flutter analyze`
- `flutter test`

Expected:
- analyzer clean
- all widget tests PASS

- [ ] **Step 6: Commit**

```bash
git add flutter_app/test/widget_test.dart flutter_app/test/features/navigation/bottom_navigation_test.dart
git commit -m "test: replace template smoke tests with app navigation coverage"
```

## Task 10: Visual Review Against Stitch

**Files:**
- No required code file changes

- [ ] **Step 1: Launch the app locally**

Run: `flutter run`

- [ ] **Step 2: Compare the implemented screens against Stitch references**

Check at minimum:

- Home
- Socratic Chat
- Roadmap
- Review
- Profile & Analytics

- [ ] **Step 3: Record visual gaps**

Capture differences in:

- spacing
- hierarchy
- typography
- empty states
- CTA emphasis

- [ ] **Step 4: Create a follow-up refinement list**

Only after the shell and route structure are stable, queue any pixel-level refinement work.

## Execution Notes

- Use Stitch as the primary source for first-pass page structure and hierarchy.
- Do not block implementation on backend APIs.
- Keep all page data mock-driven until the screen skeleton is stable.
- Treat `AI Thinking State` as an in-screen render state, not a separate navigable product page.
- Treat `New Achievement Notification` as a later overlay or modal pattern, not a first-pass routed screen.
- If the user supplies newer image-based designs that differ from Stitch, those images override the current Stitch visuals for the affected page only.
