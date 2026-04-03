# 本地存储与数据同步方案

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.0
- **文档创建日期**：2026-04-03
- **技术负责人**：技术团队

## 一、方案概述

### 1.1 设计目标
- **本地优先**：所有核心数据优先存储在本地，提供极速响应
- **云端备份**：用户可选择是否同步数据到云端，提供双重保障
- **离线可用**：无网络环境下仍可使用核心功能
- **容错机制**：本地数据破损时自动切换到云端
- **用户自主**：用户对个人数据有完全控制权

### 1.2 核心原则
1. **本地优先，云端为辅**
2. **双重备份，数据安全**
3. **离线可用，随时学习**
4. **灵活选择，尊重用户**
5. **智能切换，无缝体验**

## 二、本地存储架构

### 2.1 存储技术选型

| 技术 | 用途 | 优势 |
|------|------|------|
| SQFlite | 结构化数据存储 | 高性能、支持复杂查询、关系型数据 |
| Hive | 半结构化数据存储 | 轻量级、快速、NoSQL风格 |
| SharedPreferences | 配置数据存储 | 简单键值对、易于使用 |

### 2.2 SQFlite（结构化数据）

#### 2.2.1 数据库设计

```sql
-- 学习路线表
CREATE TABLE learning_routes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    topic TEXT,
    target_outcome TEXT,
    current_level TEXT DEFAULT 'beginner',
    target_level TEXT DEFAULT 'intermediate',
    status TEXT DEFAULT 'active',
    current_stage INTEGER DEFAULT 1,
    total_stages INTEGER DEFAULT 1,
    progress_percentage INTEGER DEFAULT 0,
    estimated_duration INTEGER,
    started_at INTEGER,
    completed_at INTEGER,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1
);

-- 学习阶段表
CREATE TABLE learning_stages (
    id TEXT PRIMARY KEY,
    route_id TEXT,
    stage_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    goal TEXT,
    completion_criteria TEXT,
    why_first TEXT,
    connection_to_prev TEXT,
    status TEXT DEFAULT 'locked',
    order_index INTEGER DEFAULT 0,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (route_id) REFERENCES learning_routes(id)
);

-- 知识点表
CREATE TABLE knowledge_points (
    id TEXT PRIMARY KEY,
    stage_id TEXT,
    title TEXT NOT NULL,
    content TEXT,
    summary TEXT,
    difficulty TEXT DEFAULT 'easy',
    category TEXT,
    tags TEXT,
    mastery_level TEXT DEFAULT 'not_started',
    estimated_study_time INTEGER DEFAULT 30,
    order_index INTEGER DEFAULT 0,
    is_template INTEGER DEFAULT 0,
    template_id TEXT,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (stage_id) REFERENCES learning_stages(id)
);

-- 学习记录表
CREATE TABLE learning_records (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    knowledge_point_id TEXT,
    action TEXT NOT NULL,
    duration INTEGER DEFAULT 0,
    details TEXT,
    device_type TEXT,
    ip_address TEXT,
    created_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (knowledge_point_id) REFERENCES knowledge_points(id)
);

-- 复习计划表
CREATE TABLE review_plans (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    knowledge_point_id TEXT,
    next_review_date INTEGER NOT NULL,
    review_count INTEGER DEFAULT 0,
    mastery_level TEXT DEFAULT 'basic',
    algorithm_type TEXT DEFAULT 'default',
    easiness_factor REAL DEFAULT 2.5,
    interval_days INTEGER DEFAULT 1,
    repetitions INTEGER DEFAULT 0,
    last_review_at INTEGER,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (knowledge_point_id) REFERENCES knowledge_points(id)
);

-- 复习任务表
CREATE TABLE review_tasks (
    id TEXT PRIMARY KEY,
    plan_id TEXT,
    scheduled_date INTEGER NOT NULL,
    review_type TEXT NOT NULL,
    review_content TEXT,
    status TEXT DEFAULT 'pending',
    result TEXT,
    user_response TEXT,
    completed_at INTEGER,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (plan_id) REFERENCES review_plans(id)
);

-- 成就表
CREATE TABLE achievements (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    icon_url TEXT,
    category TEXT DEFAULT 'learning',
    condition_type TEXT NOT NULL,
    condition_value TEXT,
    reward_type TEXT,
    reward_value INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,
    order_index INTEGER DEFAULT 0,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0
);

-- 用户成就表
CREATE TABLE user_achievements (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    achievement_id TEXT,
    progress REAL DEFAULT 0.0,
    unlocked_at INTEGER,
    metadata TEXT,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id),
    UNIQUE(user_id, achievement_id)
);

-- 用户统计表
CREATE TABLE user_statistics (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    date INTEGER NOT NULL,
    study_duration INTEGER DEFAULT 0,
    knowledge_points_learned INTEGER DEFAULT 0,
    review_tasks_completed INTEGER DEFAULT 0,
    chat_sessions_count INTEGER DEFAULT 0,
    questions_answered INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    streak INTEGER DEFAULT 0,
    created_at INTEGER,
    updated_at INTEGER,
    is_synced INTEGER DEFAULT 0,
    sync_version INTEGER DEFAULT 1,
    UNIQUE(user_id, date)
);

-- 索引
CREATE INDEX idx_learning_routes_user_id ON learning_routes(id);
CREATE INDEX idx_learning_stages_route_id ON learning_stages(route_id);
CREATE INDEX idx_knowledge_points_stage_id ON knowledge_points(stage_id);
CREATE INDEX idx_learning_records_user_id ON learning_records(user_id);
CREATE INDEX idx_review_plans_user_id ON review_plans(user_id);
CREATE INDEX idx_review_plans_next_review_date ON review_plans(next_review_date);
CREATE INDEX idx_review_tasks_plan_id ON review_tasks(plan_id);
CREATE INDEX idx_review_tasks_scheduled_date ON review_tasks(scheduled_date);
CREATE INDEX idx_user_statistics_user_date ON user_statistics(user_id, date);
```

### 2.3 Hive（半结构化数据）

#### 2.3.1 Hive数据模型

```dart
import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 0)
class ChatSession extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String userId;
  
  @HiveField(2)
  late String knowledgePointId;
  
  @HiveField(3)
  String? title;
  
  @HiveField(4)
  late String status; // 'active', 'ended'
  
  @HiveField(5)
  String? questionType;
  
  @HiveField(6)
  int currentQuestionNumber = 1;
  
  @HiveField(7)
  int totalQuestions = 4;
  
  @HiveField(8)
  String? modelUsed;
  
  @HiveField(9)
  int tokenUsed = 0;
  
  @HiveField(10)
  late int startedAt;
  
  @HiveField(11)
  int? endedAt;
  
  @HiveField(12)
  bool isSynced = false;
  
  @HiveField(13)
  int syncVersion = 1;
}

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String sessionId;
  
  @HiveField(2)
  late String role; // 'user', 'assistant', 'system'
  
  @HiveField(3)
  late String content;
  
  @HiveField(4)
  String contentType = 'text';
  
  @HiveField(5)
  String? questionType;
  
  @HiveField(6)
  String? feedbackType;
  
  @HiveField(7)
  bool isSkipped = false;
  
  @HiveField(8)
  bool isHinted = false;
  
  @HiveField(9)
  String? metadata;
  
  @HiveField(10)
  int orderIndex = 0;
  
  @HiveField(11)
  late int createdAt;
  
  @HiveField(12)
  bool isSynced = false;
  
  @HiveField(13)
  int syncVersion = 1;
}

@HiveType(typeId: 2)
class LearningLog extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String userId;
  
  @HiveField(2)
  String? knowledgePointId;
  
  @HiveField(3)
  late String action;
  
  @HiveField(4)
  Map<String, dynamic>? details;
  
  @HiveField(5)
  late int createdAt;
  
  @HiveField(6)
  bool isSynced = false;
  
  @HiveField(7)
  int syncVersion = 1;
}
```

#### 2.3.2 Hive Box注册

```dart
void registerHiveAdapters() {
  Hive.registerAdapter(ChatSessionAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(LearningLogAdapter());
}

Future<void> openHiveBoxes() async {
  await Hive.openBox<ChatSession>('chat_sessions');
  await Hive.openBox<ChatMessage>('chat_messages');
  await Hive.openBox<LearningLog>('learning_logs');
  await Hive.openBox('system_config');
}
```

### 2.4 SharedPreferences（配置数据）

#### 2.4.1 配置项定义

```dart
class AppPreferences {
  // 用户设置
  static const String userTheme = 'user_theme';
  static const String userLanguage = 'user_language';
  static const String dailyGoalMinutes = 'daily_goal_minutes';
  static const String notificationEnabled = 'notification_enabled';
  static const String emailNotification = 'email_notification';
  static const String pushNotification = 'push_notification';
  static const String studyReminderTime = 'study_reminder_time';
  
  // 同步设置
  static const String syncEnabled = 'sync_enabled';
  static const String syncOnWifiOnly = 'sync_on_wifi_only';
  static const String autoSyncInterval = 'auto_sync_interval';
  static const String lastSyncTime = 'last_sync_time';
  static const String lastSuccessfulSyncTime = 'last_successful_sync_time';
  
  // 数据状态
  static const String localDataVersion = 'local_data_version';
  static const String cloudDataVersion = 'cloud_data_version';
  static const String lastConflictResolutionTime = 'last_conflict_resolution_time';
  
  // 应用状态
  static const String isFirstLaunch = 'is_first_launch';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String lastActiveTime = 'last_active_time';
}
```

## 三、数据同步策略

### 3.1 同步触发时机

| 触发时机 | 说明 | 优先级 |
|---------|------|--------|
| 应用启动时 | 检查是否有需要同步的数据 | 高 |
| 网络恢复时 | WiFi恢复时自动同步 | 高 |
| 用户手动触发 | 用户主动点击同步按钮 | 高 |
| 定期自动同步 | 按设定间隔自动同步 | 中 |
| 数据变更时 | 重要数据变更后立即同步 | 中 |
| 应用退到后台 | 后台同步未完成的数据 | 低 |

### 3.2 同步流程

```
┌─────────────────┐
│  检查同步设置    │
│  (是否启用同步)  │
└────────┬────────┘
         ↓
┌─────────────────┐
│  检查网络状态    │
│  (是否仅WiFi)    │
└────────┬────────┘
         ↓
┌─────────────────┐
│  获取本地未同步数据│
│  (is_synced = 0) │
└────────┬────────┘
         ↓
┌─────────────────┐
│  获取云端最新数据│
│  (last_sync_at)  │
└────────┬────────┘
         ↓
┌─────────────────┐
│  对比数据版本    │
│  (sync_version)  │
└────────┬────────┘
         ↓
┌─────────────────┐
│   处理冲突       │
│  (冲突解决策略)  │
└────────┬────────┘
         ↓
┌─────────────────┐
│   双向同步       │
│  (本地→云端)    │
│  (云端→本地)    │
└────────┬────────┘
         ↓
┌─────────────────┐
│  更新同步状态    │
│  (is_synced = 1) │
└────────┬────────┘
         ↓
┌─────────────────┐
│  通知用户结果    │
│  (成功/失败)     │
└─────────────────┘
```

### 3.3 冲突解决策略

| 冲突类型 | 解决策略 | 说明 |
|---------|---------|------|
| 时间戳冲突 | 最新优先 | 以最新更新的数据为准 |
| 内容冲突 | 用户选择 | 重要冲突由用户决定 |
| 删除冲突 | 保留确认 | 需要用户二次确认 |
| 学习进度冲突 | 合并+提示 | 合并进度并提示用户 |
| 知识点冲突 | 保留两个版本 | 提示用户选择 |

#### 3.3.1 冲突解决流程

```dart
enum ConflictResolutionStrategy {
  latestWins,
  localWins,
  cloudWins,
  userChoice,
  merge,
}

class ConflictResolver {
  Future<ResolutionResult> resolveConflict(
    dynamic localData,
    dynamic cloudData,
    ConflictResolutionStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictResolutionStrategy.latestWins:
        return _resolveByTimestamp(localData, cloudData);
      case ConflictResolutionStrategy.localWins:
        return ResolutionResult(winner: localData, source: 'local');
      case ConflictResolutionStrategy.cloudWins:
        return ResolutionResult(winner: cloudData, source: 'cloud');
      case ConflictResolutionStrategy.userChoice:
        return await _askUserChoice(localData, cloudData);
      case ConflictResolutionStrategy.merge:
        return _mergeData(localData, cloudData);
    }
  }
  
  ResolutionResult _resolveByTimestamp(dynamic local, dynamic cloud) {
    if (local.updatedAt > cloud.updatedAt) {
      return ResolutionResult(winner: local, source: 'local');
    } else {
      return ResolutionResult(winner: cloud, source: 'cloud');
    }
  }
}
```

### 3.4 增量同步

#### 3.4.1 变更追踪
每个数据项记录：
- `is_synced`：是否已同步（0=未同步，1=已同步）
- `updated_at`：更新时间戳
- `sync_version`：同步版本号

#### 3.4.2 差异计算
```dart
class SyncDiffCalculator {
  Future<SyncDiff> calculateDiff() async {
    final localChanges = await _getLocalChanges();
    final cloudChanges = await _getCloudChanges();
    
    return SyncDiff(
      localToCloud: localChanges,
      cloudToLocal: cloudChanges,
      conflicts: _findConflicts(localChanges, cloudChanges),
    );
  }
  
  Future<List<dynamic>> _getLocalChanges() async {
    final db = await DatabaseHelper.instance.database;
    final results = await db.query(
      'learning_routes',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return results;
  }
}
```

#### 3.4.3 批量处理
- 批量同步多个数据项
- 按优先级排序（重要数据优先）
- 分批处理避免超时

#### 3.4.4 断点续传
- 记录同步进度
- 支持同步中断后继续
- 避免重复同步已完成的数据

## 四、数据完整性验证

### 4.1 本地数据验证

#### 4.1.1 完整性检查
```dart
class DataIntegrityChecker {
  Future<IntegrityReport> checkIntegrity() async {
    final report = IntegrityReport();
    
    // 检查数据库完整性
    report.databaseIssues = await _checkDatabaseIntegrity();
    
    // 检查Hive数据完整性
    report.hiveIssues = await _checkHiveIntegrity();
    
    // 检查校验和
    report.checksumIssues = await _verifyChecksums();
    
    return report;
  }
  
  Future<List<DatabaseIssue>> _checkDatabaseIntegrity() async {
    final issues = <DatabaseIssue>[];
    final db = await DatabaseHelper.instance.database;
    
    // 检查外键约束
    // 检查必需字段
    // 检查数据格式
    
    return issues;
  }
}
```

#### 4.1.2 校验和验证
使用SHA-256校验和检测数据破损：
```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChecksumManager {
  String calculateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  Future<bool> verifyChecksum(String data, String expectedChecksum) async {
    final actualChecksum = calculateChecksum(data);
    return actualChecksum == expectedChecksum;
  }
}
```

#### 4.1.3 自动修复策略
| 问题类型 | 修复策略 |
|---------|---------|
| 小数据破损 | 自动从云端同步修复 |
| 索引损坏 | 自动重建索引 |
| 外键约束破坏 | 提示用户手动修复 |
| 大面积损坏 | 提示用户恢复完整备份 |

### 4.2 数据恢复流程

```
1. 检测到数据破损
2. 检查是否有云端备份
3. 提示用户是否恢复
4. 用户确认恢复
5. 从云端同步修复数据
6. 验证修复后的数据
7. 通知用户恢复结果
8. 记录恢复日志
```

## 五、数据访问策略

### 5.1 优先本地策略

#### 5.1.1 数据访问流程
```dart
class DataAccessManager {
  Future<T?> getData<T>({
    required String localSource,
    required Future<T?> Function() cloudFallback,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      final cloudData = await cloudFallback();
      if (cloudData != null) {
        await _saveToLocal(cloudData);
      }
      return cloudData;
    }
    
    // 优先尝试本地
    final localData = await _getFromLocal<T>(localSource);
    if (localData != null && await _isLocalDataValid(localData)) {
      return localData;
    }
    
    // 本地失败，尝试云端
    final cloudData = await cloudFallback();
    if (cloudData != null) {
      await _saveToLocal(cloudData);
    }
    
    return cloudData;
  }
  
  Future<bool> _isLocalDataValid(dynamic data) async {
    // 检查数据是否过期
    // 检查数据完整性
    // 检查数据版本
    return true;
  }
}
```

#### 5.1.2 本地数据验证
1. 检查数据是否存在
2. 检查数据完整性（校验和）
3. 检查数据是否过期
4. 检查数据版本兼容性

### 5.2 智能切换策略

| 场景 | 数据来源 | 说明 |
|------|---------|------|
| 网络不可用 | 本地 | 完全离线 |
| 本地数据有效 | 本地 | 优先本地 |
| 本地数据破损 | 云端 | 自动降级 |
| 用户请求刷新 | 云端 | 强制刷新 |
| 首次访问 | 云端 → 本地 | 先云端后缓存 |

## 六、图表本地绘制

### 6.1 本地数据绘制策略

#### 6.1.1 学习统计图表
```dart
class ChartDataProvider {
  Future<List<DailyStat>> getDailyStats(DateTime start, DateTime end) async {
    // 优先从本地获取
    final localStats = await _getLocalDailyStats(start, end);
    
    if (localStats.isNotEmpty && await _isStatsComplete(localStats, start, end)) {
      return localStats;
    }
    
    // 本地数据不完整，从云端补充
    final cloudStats = await _getCloudDailyStats(start, end);
    
    // 合并本地和云端数据
    final mergedStats = _mergeStats(localStats, cloudStats);
    
    // 保存到本地
    await _saveStatsToLocal(mergedStats);
    
    return mergedStats;
  }
  
  List<DailyStat> _mergeStats(List<DailyStat> local, List<DailyStat> cloud) {
    final merged = <DailyStat>[];
    final localMap = {for (var stat in local) stat.date: stat};
    
    for (var cloudStat in cloud) {
      final localStat = localMap[cloudStat.date];
      if (localStat != null && localStat.updatedAt > cloudStat.updatedAt) {
        merged.add(localStat);
      } else {
        merged.add(cloudStat);
      }
    }
    
    return merged;
  }
}
```

#### 6.1.2 图表库选择
使用 `fl_chart` 库进行本地图表绘制，支持：
- 折线图（学习趋势）
- 柱状图（每日统计）
- 饼图（知识点掌握度）
- 散点图（学习分布）

### 6.2 性能优化
- 数据预加载
- 图表数据缓存
- 虚拟滚动（大数据量）
- 异步绘制

## 七、安全与隐私

### 7.1 本地数据安全

#### 7.1.1 加密存储
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  Future<void> saveEncrypted(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  Future<String?> readEncrypted(String key) async {
    return await _storage.read(key: key);
  }
}
```

#### 7.1.2 敏感数据加密
| 数据类型 | 加密方式 | 存储位置 |
|---------|---------|---------|
| 密码 | bcrypt | 不存储本地 |
| 个人信息 | AES-256 | SQFlite加密字段 |
| 学习数据 | 可选加密 | 用户选择 |
| 认证Token | Keychain/Keystore | 安全存储 |

### 7.2 隐私设置

#### 7.2.1 同步选择
用户可选择：
- 是否启用同步
- 同步哪些数据类型
- 是否仅WiFi同步
- 同步频率

#### 7.2.2 数据导出
- 导出本地数据
- 导出云端数据
- 数据格式（JSON、CSV）
- 选择性导出

## 八、存储监控与维护

### 8.1 存储空间监控

```dart
class StorageMonitor {
  Future<StorageInfo> getStorageInfo() async {
    final totalSpace = await _getTotalSpace();
    final usedSpace = await _getUsedSpace();
    final appSpace = await _getAppSpace();
    final cacheSpace = await _getCacheSpace();
    
    return StorageInfo(
      totalSpace: totalSpace,
      usedSpace: usedSpace,
      appSpace: appSpace,
      cacheSpace: cacheSpace,
      availableSpace: totalSpace - usedSpace,
    );
  }
  
  Future<void> cleanOldData(int days) async {
    // 清理N天前的日志
    // 清理旧的临时文件
    // 清理未同步的废弃数据
  }
}
```

### 8.2 定期维护任务

| 任务 | 频率 | 说明 |
|------|------|------|
| 数据完整性检查 | 每周 | 检查本地数据完整性 |
| 旧数据清理 | 每月 | 清理过期的临时数据 |
| 缓存清理 | 用户触发 | 清理应用缓存 |
| 数据库优化 | 每月 | VACUUM、索引重建 |

## 九、技术风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|---------|
| 本地数据破损 | 高 | 云端备份、自动恢复 |
| 同步冲突 | 中 | 冲突解决策略、用户选择 |
| 存储空间不足 | 中 | 存储监控、清理旧数据 |
| 网络不可用 | 低 | 完全离线可用核心功能 |
| 数据丢失 | 高 | 双重备份、定期导出 |
| 性能问题 | 中 | 本地优化、索引优化 |

## 十、最佳实践

### 10.1 开发最佳实践
1. 所有数据操作通过统一的DataManager
2. 本地数据访问使用异步操作
3. 批量操作提高性能
4. 合理使用事务确保一致性
5. 完善的错误处理和日志

### 10.2 用户体验最佳实践
1. 提供清晰的同步状态反馈
2. 后台同步不阻塞UI
3. 提供数据管理工具
4. 尊重用户隐私选择
5. 提供数据备份和恢复功能

## 十一、附录

### 11.1 参考资源
- SQFlite官方文档
- Hive官方文档
- SharedPreferences文档
- fl_chart文档
- Flutter安全存储文档

### 11.2 相关文档
- 技术架构文档
- API接口文档
- 数据库设计文档
