# 开发规范文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.0
- **文档创建日期**：2026-04-03
- **规范负责人**：开发团队

## 一、代码规范

### 1.1 Flutter/Dart代码规范

#### 1.1.1 命名规范
```dart
// 类名：大驼峰命名
class LearningRouteService {}

// 变量名：小驼峰命名
String userName = '';
int learningProgress = 0;

// 常量：小驼峰命名
const int maxRetryCount = 3;

// 私有成员：下划线前缀
class _LearningRouteState {
  String _currentRouteId = '';
}

// 文件名：小写+下划线
// learning_route_page.dart
// user_service.dart
```

#### 1.1.2 目录结构
```
lib/
├── main.dart                    # 应用入口
├── app.dart                     # App配置
├── config/                      # 配置文件
│   ├── app_config.dart
│   ├── api_config.dart
│   └── theme_config.dart
├── models/                      # 数据模型
│   ├── user.dart
│   ├── learning_route.dart
│   └── knowledge_point.dart
├── services/                    # 服务层
│   ├── api/
│   │   ├── api_client.dart
│   │   ├── auth_api.dart
│   │   └── learning_api.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── cache_manager.dart
│   └── ai/
│       └── chat_service.dart
├── providers/                   # 状态管理
│   ├── user_provider.dart
│   ├── learning_provider.dart
│   └── theme_provider.dart
├── pages/                       # 页面
│   ├── home/
│   │   ├── home_page.dart
│   │   └── home_controller.dart
│   ├── learning/
│   │   ├── learning_page.dart
│   │   └── learning_controller.dart
│   └── profile/
│       ├── profile_page.dart
│       └── profile_controller.dart
├── widgets/                     # 公共组件
│   ├── common/
│   │   ├── app_button.dart
│   │   ├── app_input.dart
│   │   └── app_card.dart
│   └── learning/
│       ├── chat_bubble.dart
│       ├── progress_bar.dart
│       └── knowledge_card.dart
├── utils/                       # 工具类
│   ├── logger.dart
│   ├── validators.dart
│   └── date_utils.dart
└── constants/                   # 常量定义
    ├── app_constants.dart
    ├── api_constants.dart
    └── route_constants.dart
```

#### 1.1.3 代码注释规范
```dart
/// 学习路线服务
/// 
/// 负责学习路线的创建、查询、更新等操作
class LearningRouteService {
  /// 创建学习路线
  /// 
  /// [userId] 用户ID
  /// [topic] 学习主题
  /// [level] 当前水平
  /// 
  /// 返回创建的学习路线对象
  Future<LearningRoute> createRoute({
    required String userId,
    required String topic,
    required String level,
  }) async {
    // 实现逻辑
  }
}
```

#### 1.1.4 代码格式化
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
    - prefer_single_quotes
    - sort_child_properties_last
    - use_key_in_widget_constructors
```

### 1.2 Python代码规范

#### 1.2.1 命名规范
```python
# 类名：大驼峰命名
class LearningService:
    pass

# 函数名：小写+下划线
def create_learning_route(user_id: str) -> dict:
    pass

# 变量名：小写+下划线
user_name = ""
learning_progress = 0

# 常量：全大写+下划线
MAX_RETRY_COUNT = 3
DEFAULT_TIMEOUT = 30

# 私有方法：下划线前缀
def _validate_user_input(data: dict) -> bool:
    pass
```

#### 1.2.2 目录结构
```
backend/
├── main.py                      # 应用入口
├── config/                      # 配置文件
│   ├── __init__.py
│   ├── settings.py
│   └── database.py
├── app/                         # 应用主目录
│   ├── __init__.py
│   ├── api/                     # API路由
│   │   ├── __init__.py
│   │   ├── v1/
│   │   │   ├── __init__.py
│   │   │   ├── auth.py
│   │   │   ├── learning.py
│   │   │   └── review.py
│   ├── models/                  # 数据模型
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── learning.py
│   │   └── review.py
│   ├── schemas/                 # Pydantic模型
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── learning.py
│   │   └── review.py
│   ├── services/                # 业务逻辑
│   │   ├── __init__.py
│   │   ├── user_service.py
│   │   ├── learning_service.py
│   │   └── ai_service.py
│   ├── repositories/            # 数据访问层
│   │   ├── __init__.py
│   │   ├── user_repo.py
│   │   └── learning_repo.py
│   ├── utils/                   # 工具函数
│   │   ├── __init__.py
│   │   ├── logger.py
│   │   ├── validators.py
│   │   └── exceptions.py
│   └── core/                    # 核心功能
│       ├── __init__.py
│       ├── security.py
│       ├── config.py
│       └── dependencies.py
├── tests/                       # 测试文件
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_auth.py
│   └── test_learning.py
├── alembic/                     # 数据库迁移
│   ├── versions/
│   └── env.py
├── requirements.txt             # 依赖管理
├── pyproject.toml              # 项目配置
└── Dockerfile                   # Docker配置
```

#### 1.2.3 代码注释规范
```python
class LearningService:
    """学习服务
    
    负责学习路线的创建、查询、更新等操作
    
    Attributes:
        db: 数据库会话
        cache: 缓存客户端
    """
    
    def create_route(
        self,
        user_id: str,
        topic: str,
        level: str
    ) -> LearningRoute:
        """创建学习路线
        
        Args:
            user_id: 用户ID
            topic: 学习主题
            level: 当前水平
            
        Returns:
            创建的学习路线对象
            
        Raises:
            ValidationError: 参数验证失败
            DatabaseError: 数据库操作失败
        """
        pass
```

#### 1.2.4 类型注解
```python
from typing import Optional, List, Dict, Any
from datetime import datetime

def get_user_routes(
    user_id: str,
    status: Optional[str] = None,
    limit: int = 10
) -> List[Dict[str, Any]]:
    """获取用户学习路线列表"""
    pass

class User:
    def __init__(
        self,
        id: str,
        username: str,
        email: str,
        created_at: datetime
    ) -> None:
        self.id = id
        self.username = username
        self.email = email
        self.created_at = created_at
```

## 二、Git规范

### 2.1 分支管理

#### 2.1.1 分支命名
```
main                    # 主分支（生产环境）
develop                 # 开发分支
feature/功能名称        # 功能分支
bugfix/问题描述         # Bug修复分支
hotfix/紧急修复         # 紧急修复分支
release/版本号          # 发布分支
```

#### 2.1.2 分支策略
```
main (生产)
  ↑
  └── release/v1.0 (发布)
        ↑
        └── develop (开发)
              ↑
              ├── feature/learning-route (功能)
              ├── feature/ai-chat (功能)
              └── bugfix/login-error (修复)
```

### 2.2 提交规范

#### 2.2.1 Commit Message格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

#### 2.2.2 Type类型
```
feat:     新功能
fix:      Bug修复
docs:     文档更新
style:    代码格式调整
refactor: 代码重构
test:     测试相关
chore:    构建/工具相关
perf:     性能优化
revert:   回滚提交
```

#### 2.2.3 Scope范围
```
auth:     认证相关
learning: 学习相关
review:   复习相关
ai:       AI相关
ui:       界面相关
api:      API相关
db:       数据库相关
```

#### 2.2.4 示例
```
feat(learning): 添加学习路线生成功能

- 实现基于用户目标的学习路线生成
- 支持多阶段学习路径规划
- 添加知识点分解功能

Closes #123
```

### 2.3 代码审查

#### 2.3.1 PR规范
```markdown
## 变更说明
简要描述本次变更的内容

## 变更类型
- [ ] 新功能
- [ ] Bug修复
- [ ] 重构
- [ ] 文档更新

## 测试情况
- [ ] 单元测试已通过
- [ ] 集成测试已通过
- [ ] 手动测试已完成

## 影响范围
列出受影响的功能模块

## 截图（如有UI变更）
```

#### 2.3.2 审查清单
- [ ] 代码符合规范
- [ ] 有足够的注释
- [ ] 有单元测试
- [ ] 无安全漏洞
- [ ] 性能可接受
- [ ] 文档已更新

## 三、API设计规范

### 3.1 RESTful API规范

#### 3.1.1 URL设计
```
# 资源命名使用复数
GET    /api/v1/users              # 获取用户列表
GET    /api/v1/users/{id}         # 获取单个用户
POST   /api/v1/users              # 创建用户
PUT    /api/v1/users/{id}         # 更新用户
DELETE /api/v1/users/{id}         # 删除用户

# 子资源
GET    /api/v1/users/{id}/routes  # 获取用户的学习路线

# 过滤、排序、分页
GET    /api/v1/routes?status=active&sort=created_at&page=1&limit=10
```

#### 3.1.2 HTTP方法
```
GET:     查询资源
POST:    创建资源
PUT:     更新资源（完整更新）
PATCH:   更新资源（部分更新）
DELETE:  删除资源
```

#### 3.1.3 状态码
```
200: 成功
201: 创建成功
204: 删除成功（无返回内容）
400: 请求参数错误
401: 未认证
403: 无权限
404: 资源不存在
409: 资源冲突
422: 参数验证失败
500: 服务器内部错误
```

### 3.2 响应格式

#### 3.2.1 成功响应
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "name": "学习路线名称"
  }
}
```

#### 3.2.2 列表响应
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [...],
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

#### 3.2.3 错误响应
```json
{
  "code": 400,
  "message": "参数错误",
  "errors": [
    {
      "field": "email",
      "message": "邮箱格式不正确"
    }
  ]
}
```

### 3.3 接口文档

使用OpenAPI 3.0规范编写接口文档，集成Swagger UI。

```yaml
openapi: 3.0.0
info:
  title: 智学AI API
  version: 1.0.0
paths:
  /api/v1/auth/login:
    post:
      summary: 用户登录
      tags:
        - 认证
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                password:
                  type: string
      responses:
        '200':
          description: 登录成功
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LoginResponse'
```

## 四、数据库规范

### 4.1 表设计规范

#### 4.1.1 表命名
```
# 小写+下划线，复数形式
users
learning_routes
knowledge_points
chat_messages
```

#### 4.1.2 字段命名
```
# 小写+下划线
user_id
created_at
updated_at
is_active
```

#### 4.1.3 必备字段
```sql
CREATE TABLE example (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- 业务字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP  -- 软删除
);
```

### 4.2 索引规范

```sql
-- 主键索引（自动创建）
PRIMARY KEY (id)

-- 唯一索引
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- 普通索引
CREATE INDEX idx_learning_routes_user_id ON learning_routes(user_id);

-- 复合索引
CREATE INDEX idx_chat_messages_session_created 
ON chat_messages(session_id, created_at DESC);
```

### 4.3 查询规范

```sql
-- 避免SELECT *
SELECT id, name, email FROM users WHERE id = ?;

-- 使用参数化查询
SELECT * FROM users WHERE email = %s;

-- 分页查询
SELECT * FROM learning_routes 
WHERE user_id = ? 
ORDER BY created_at DESC 
LIMIT ? OFFSET ?;

-- 批量插入
INSERT INTO users (name, email) VALUES (?, ?), (?, ?);
```

## 五、测试规范

### 5.1 测试类型

| 测试类型 | 覆盖率要求 | 说明 |
|---------|-----------|------|
| 单元测试 | > 80% | 测试单个函数/方法 |
| 集成测试 | > 60% | 测试模块间交互 |
| E2E测试 | 核心流程 | 测试完整业务流程 |

### 5.2 单元测试规范

#### 5.2.1 Flutter测试
```dart
// test/services/learning_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('LearningService', () {
    late LearningService service;
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
      service = LearningService(mockClient);
    });

    test('createRoute should return LearningRoute', () async {
      // Arrange
      when(mockClient.post(any, any))
          .thenAnswer((_) async => {'id': '123', 'title': 'Test'});

      // Act
      final result = await service.createRoute(
        userId: 'user1',
        topic: 'Python',
        level: 'beginner',
      );

      // Assert
      expect(result, isA<LearningRoute>());
      expect(result.id, '123');
    });
  });
}
```

#### 5.2.2 Python测试
```python
# tests/test_learning_service.py
import pytest
from app.services.learning_service import LearningService

@pytest.fixture
def learning_service(db_session):
    return LearningService(db_session)

class TestLearningService:
    def test_create_route(self, learning_service):
        """测试创建学习路线"""
        # Arrange
        user_id = "test-user"
        topic = "Python"
        level = "beginner"
        
        # Act
        route = learning_service.create_route(
            user_id=user_id,
            topic=topic,
            level=level
        )
        
        # Assert
        assert route.id is not None
        assert route.user_id == user_id
        assert route.title == topic
```

### 5.3 测试覆盖率

```bash
# Flutter
flutter test --coverage

# Python
pytest --cov=app --cov-report=html
```

## 六、日志规范

### 6.1 日志级别
```
DEBUG:    调试信息
INFO:     一般信息
WARNING:  警告信息
ERROR:    错误信息
CRITICAL: 严重错误
```

### 6.2 日志格式

#### 6.2.1 Flutter日志
```dart
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
  ),
);

// 使用
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error: e, stackTrace: stackTrace);
```

#### 6.2.2 Python日志
```python
import logging
import json
from datetime import datetime

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_data = {
            'timestamp': datetime.utcnow().isoformat(),
            'level': record.levelname,
            'service': 'learning-service',
            'message': record.getMessage(),
            'extra': getattr(record, 'extra', {})
        }
        return json.dumps(log_data)

# 使用
logger.info(
    "学习路线创建成功",
    extra={'user_id': user_id, 'route_id': route_id}
)
```

## 七、安全规范

### 7.1 敏感信息处理

#### 7.1.1 配置文件
```yaml
# config.yaml (不提交到Git)
database:
  host: localhost
  port: 5432
  username: admin
  password: ${DB_PASSWORD}  # 环境变量

# .env.example (提交到Git)
DB_PASSWORD=your_password_here
OPENAI_API_KEY=your_api_key_here
```

#### 7.1.2 代码中处理
```python
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv('DATABASE_URL')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
```

### 7.2 输入验证

```python
from pydantic import BaseModel, EmailStr, validator

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    
    @validator('password')
    def validate_password(cls, v):
        if len(v) < 8:
            raise ValueError('密码长度至少8位')
        if not any(c.isupper() for c in v):
            raise ValueError('密码必须包含大写字母')
        return v
```

### 7.3 SQL注入防护

```python
# 错误示例
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# 正确示例
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

## 八、性能规范

### 8.1 前端性能

```dart
// 使用const构造函数
const Text('Hello World')

// 列表优化
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]);
  },
)

// 图片优化
Image.network(
  url,
  cacheWidth: 200,  // 限制缓存大小
  cacheHeight: 200,
)
```

### 8.2 后端性能

```python
# 数据库查询优化
# 使用select_related/prefetch_related减少查询次数
routes = LearningRoute.objects.filter(
    user_id=user_id
).select_related('user').prefetch_related('stages')

# 使用索引
# 确保查询字段有索引

# 批量操作
User.objects.bulk_create(users)
```

## 九、文档规范

### 9.1 README规范
```markdown
# 项目名称

## 项目简介
简要描述项目

## 快速开始
### 环境要求
### 安装步骤
### 运行方式

## 项目结构
目录结构说明

## 开发指南
开发规范链接

## 部署说明
部署文档链接

## 贡献指南
如何贡献代码

## 许可证
开源协议
```

### 9.2 API文档规范
- 使用OpenAPI 3.0规范
- 包含请求示例和响应示例
- 说明错误码含义
- 提供认证方式说明

## 十、工具配置

### 10.1 EditorConfig
```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.py]
indent_style = space
indent_size = 4

[*.dart]
indent_style = space
indent_size = 2

[*.{yml,yaml,json}]
indent_style = space
indent_size = 2
```

### 10.2 Git Hooks
```bash
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

# Flutter
flutter analyze
flutter test

# Python
pytest
```

### 10.3 CI配置
```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Install dependencies
        run: flutter pub get
        
      - name: Run tests
        run: flutter test --coverage
        
      - name: Upload coverage
        uses: codecov/codecov-action@v2
```