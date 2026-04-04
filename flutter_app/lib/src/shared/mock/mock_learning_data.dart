import '../../app/locale/app_language.dart';
import '../models/chat_session_models.dart';
import '../models/home_dashboard_models.dart';
import '../models/profile_models.dart';
import '../models/review_models.dart';
import '../models/roadmap_models.dart';

const HomeDashboardState mockHomeDashboardState = HomeDashboardState(
  heroLabel: 'Today',
  greeting: 'Good Morning, Alex!',
  summary:
      'Return to your main inquiry, close one spaced review, and finish with a short reflection.',
  primaryActionLabel: 'Continue current learning',
  pausedCheckpoint: 'You paused at: Wave-particle duality -> Compare stage',
  alternateReviewLabel: 'Switch to review first',
  learningTask: HomeTaskCard(
    title: 'Quantum Physics Fundamentals',
    description:
        'Resume the current guided dialogue and strengthen the boundary around uncertainty.',
    badgeLabel: 'Stage 2 • Compare',
    ctaLabel: 'Enter inquiry',
    route: '/chat',
  ),
  reviewTask: HomeTaskCard(
    title: 'Review due today',
    description:
        'Two concepts are ready for recall because they are starting to fade.',
    badgeLabel: '2 due today',
    ctaLabel: 'Open review',
    route: '/review',
  ),
  todayLoop: <HomeLoopStep>[
    HomeLoopStep(label: 'Main inquiry', isComplete: false),
    HomeLoopStep(label: 'Spaced review', isComplete: false),
    HomeLoopStep(label: 'Session wrap-up', isComplete: false),
  ],
  exploration: HomeExplorationSuggestion(
    title: 'Copenhagen interpretation',
    description:
        'Explore a branch that deepens the uncertainty discussion without replacing the main path.',
    relatedReason:
        'Best opened after today’s main path because it depends on a clear distinction between measurement and interpretation.',
    ctaLabel: 'Save for after the main path',
  ),
  quickLinks: <HomeQuickLink>[
    HomeQuickLink(
      title: 'Current roadmap',
      description: 'Check the active stage and the next unlock condition.',
      badgeLabel: '3 stages',
      route: '/roadmap',
    ),
    HomeQuickLink(
      title: 'Learning insights',
      description: 'See your weekly rhythm, streak, and explanation quality.',
      badgeLabel: '24 day streak',
      route: '/profile',
    ),
    HomeQuickLink(
      title: 'Achievements',
      description: 'Review the milestones you unlocked and what is next.',
      badgeLabel: '3 new',
      route: '/profile',
    ),
  ],
);

const ChatSessionState mockChatSessionState = ChatSessionState(
  task: ChatTaskSummary(
    topic: 'The Essence of Justice',
    currentPrompt: 'Explain the difference between justice and simple obedience.',
    successSignal:
        'You can define justice in your own words and support it with one real example.',
  ),
  messages: <ChatMessage>[
    ChatMessage(
      role: ChatMessageRole.coach,
      content:
          'Before we speak of justice, tell me this: is every lawful act also just?',
    ),
    ChatMessage(
      role: ChatMessageRole.learner,
      content:
          'I think justice is deeper than rules, because rules can be followed without fairness.',
    ),
  ],
  currentStage: ChatPromptStage.explain,
  draft: '',
  questionIndex: 2,
  totalQuestions: 5,
  isThinking: false,
);

const ReviewQueueState mockReviewQueueState = ReviewQueueState(
  dueToday: <ReviewQueueItem>[
    ReviewQueueItem(
      id: 'wave-particle-duality',
      title: 'Wave-particle duality',
      detail: 'Clarify the analogy you use when explaining it.',
      reason: 'Review now because your last explanation was vague.',
      dueLabel: 'Due now',
      route: '/review/mistakes',
    ),
    ReviewQueueItem(
      id: 'observer-effect',
      title: 'Observer effect',
      detail: 'Separate the concept from measurement itself.',
      reason: 'Review now because this distinction faded overnight.',
      dueLabel: 'Today',
      route: '/review/quiz',
    ),
  ],
  upNext: <ReviewQueueItem>[
    ReviewQueueItem(
      id: 'uncertainty-principle',
      title: 'Uncertainty principle',
      detail: 'One more retrieval tomorrow will stabilize the core boundary.',
      reason: 'Up next because it is entering the ideal recall window.',
      dueLabel: 'Tomorrow',
      route: '/review/quiz',
    ),
  ],
  completedToday: <ReviewQueueItem>[
    ReviewQueueItem(
      id: 'photoelectric-effect',
      title: 'Photoelectric effect',
      detail: 'You successfully linked the concept to energy quanta.',
      reason: 'Completed with strong recall quality.',
      dueLabel: 'Done',
      route: '/review/results',
    ),
  ],
);

const RoadmapProgressState mockRoadmapProgressState = RoadmapProgressState(
  journeyTitle: 'Quantum Physics Fundamentals',
  currentGoal:
      'Clarify the difference between observed behavior, interpretation, and measurement.',
  whyThisIsNext:
      'This node comes next because your uncertainty explanation is solid enough to support a deeper comparison.',
  continueRoute: '/chat',
  milestones: <RoadmapMilestone>[
    RoadmapMilestone(
      title: 'Foundation Systems',
      detail: 'Clarify structure, intent, and constraints.',
      statusLabel: 'In progress',
      unlockRequirement: 'Unlock by finishing today’s compare step.',
      isActive: true,
      isLocked: false,
    ),
    RoadmapMilestone(
      title: 'Patterns in Motion',
      detail: 'Compare multiple models against real trade-offs.',
      statusLabel: 'Up next',
      unlockRequirement: 'Unlock by clearing two due reviews and one transfer prompt.',
      isActive: false,
      isLocked: false,
    ),
    RoadmapMilestone(
      title: 'Synthesis Studio',
      detail: 'Defend your own model with a clear rationale.',
      statusLabel: 'Locked',
      unlockRequirement: 'Unlock by completing the previous stage.',
      isActive: false,
      isLocked: true,
    ),
  ],
  savedBranches: <SavedBranch>[
    SavedBranch(
      title: 'Copenhagen interpretation',
      reason: 'Saved for later because it extends the current uncertainty discussion.',
    ),
    SavedBranch(
      title: 'Many-worlds view',
      reason: 'Saved for later because it is useful after the measurement unit.',
    ),
  ],
);

const ProfilePreferencesState mockProfilePreferencesState =
    ProfilePreferencesState(
      language: AppLanguage.english,
      reminderHour: 19,
      digestDay: 'Friday',
      offlineReady: true,
      syncStatus: 'Synced 8 min ago',
      dailyTargetMinutes: 25,
    );
