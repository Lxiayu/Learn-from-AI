# 部署文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.0
- **文档创建日期**：2026-04-03
- **运维负责人**：运维团队

## 一、部署概述

### 1.1 部署环境

| 环境 | 用途 | 配置 |
|------|------|------|
| 开发环境 | 日常开发 | 本地Docker |
| 测试环境 | 功能测试 | 4核8G × 3 |
| 预发布环境 | 上线前验证 | 4核8G × 3 |
| 生产环境 | 正式服务 | 8核16G × 6（多区域） |

### 1.2 技术栈

| 组件 | 技术 | 版本 |
|------|------|------|
| 容器 | Docker | 24+ |
| 容器编排 | Kubernetes | 1.28+ |
| 服务网格 | Istio | 1.19+ |
| 数据库 | PostgreSQL | 15+ |
| 缓存 | Redis | 7+ |
| 文档数据库 | MongoDB | 7+ |
| 消息队列 | RabbitMQ | 3.12+ |
| 监控 | Prometheus + Grafana | Latest |
| 日志 | ELK Stack | Latest |
| 负载均衡 | Nginx | 1.24+ |

## 二、架构拓扑

### 2.1 生产环境架构图

```
┌─────────────────────────────────────────────────────────────┐
│                         客户端                               │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │
│  │ iOS App │  │Android  │  │ Web App │  │ 小程序   │      │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                       CDN + WAF                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      负载均衡层                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Nginx (主备)                              │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     应用服务层                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  用户服务    │  │  学习服务    │  │  AI服务      │    │
│  │  (3副本)     │  │  (3副本)     │  │  (2副本)     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  复习服务    │  │  数据服务    │  │  通知服务    │    │
│  │  (2副本)     │  │  (2副本)     │  │  (2副本)     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     数据存储层                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ PostgreSQL   │  │    Redis     │  │   MongoDB    │    │
│  │  (主从)      │  │  (集群)      │  │  (副本集)     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │ RabbitMQ     │  │ 对象存储OSS  │                        │
│  │  (集群)      │  │              │                        │
│  └──────────────┘  └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    监控日志层                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Prometheus   │  │   Grafana    │  │  ELK Stack   │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 三、环境准备

### 3.1 服务器要求

#### 生产环境服务器配置

| 节点类型 | CPU | 内存 | 磁盘 | 数量 |
|---------|-----|------|------|------|
| K8s Master | 4核 | 8G | 100G SSD | 3 |
| K8s Worker | 8核 | 16G | 200G SSD | 6 |
| 数据库主 | 8核 | 32G | 500G SSD | 1 |
| 数据库从 | 8核 | 32G | 500G SSD | 2 |
| Redis节点 | 4核 | 16G | 100G SSD | 3 |
| MongoDB节点 | 4核 | 16G | 200G SSD | 3 |
| 日志节点 | 8核 | 32G | 1T SSD | 3 |
| 监控节点 | 4核 | 16G | 500G SSD | 1 |

### 3.2 软件安装

#### 3.2.1 Docker安装

```bash
# 安装Docker
curl -fsSL https://get.docker.com | sh

# 启动Docker
systemctl start docker
systemctl enable docker

# 验证安装
docker --version
```

#### 3.2.2 Kubernetes安装

```bash
# 使用kubeadm安装K8s
kubeadm init --pod-network-cidr=10.244.0.0/16

# 配置kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络插件
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
```

#### 3.2.3 Helm安装

```bash
# 安装Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 验证安装
helm version
```

## 四、容器化部署

### 4.1 Docker镜像构建

#### 4.1.1 后端服务Dockerfile

```dockerfile
# backend/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制代码
COPY . .

# 暴露端口
EXPOSE 8000

# 启动命令
CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:8000", "--workers", "4"]
```

#### 4.1.2 前端应用Dockerfile

```dockerfile
# frontend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

# 安装依赖
COPY package*.json ./
RUN npm ci

# 构建
COPY . .
RUN npm run build

# 生产阶段
FROM nginx:1.24-alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 4.2 Docker Compose（开发环境）

```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: learnai
      POSTGRES_USER: learnai
      POSTGRES_PASSWORD: learnai123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U learnai"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  mongodb:
    image: mongo:7
    environment:
      MONGO_INITDB_ROOT_USERNAME: learnai
      MONGO_INITDB_ROOT_PASSWORD: learnai123
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

  rabbitmq:
    image: rabbitmq:3.12-management-alpine
    environment:
      RABBITMQ_DEFAULT_USER: learnai
      RABBITMQ_DEFAULT_PASS: learnai123
    ports:
      - "5672:5672"
      - "15672:15672"
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://learnai:learnai123@postgres:5432/learnai
      - REDIS_URL=redis://redis:6379/0
      - MONGODB_URL=mongodb://learnai:learnai123@mongodb:27017/learnai
      - RABBITMQ_URL=amqp://learnai:learnai123@rabbitmq:5672/
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./backend:/app

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    depends_on:
      - backend

volumes:
  postgres_data:
  redis_data:
  mongo_data:
  rabbitmq_data:
```

## 五、Kubernetes部署

### 5.1 Helm Chart结构

```
learnai-chart/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── ingress.yaml
│   ├── service-user.yaml
│   ├── service-learning.yaml
│   ├── service-ai.yaml
│   ├── deployment-user.yaml
│   ├── deployment-learning.yaml
│   ├── deployment-ai.yaml
│   ├── hpa.yaml
│   └── pdb.yaml
└── charts/
```

### 5.2 部署配置示例

#### 5.2.1 values.yaml

```yaml
# values.yaml
global:
  namespace: learnai
  imagePullPolicy: IfNotPresent

userService:
  replicaCount: 3
  image:
    repository: learnai/user-service
    tag: v1.0.0
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 2000m
      memory: 2Gi
  autoscaling:
    enabled: true
    minReplicas: 3
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70

learningService:
  replicaCount: 3
  image:
    repository: learnai/learning-service
    tag: v1.0.0
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 2000m
      memory: 2Gi

aiService:
  replicaCount: 2
  image:
    repository: learnai/ai-service
    tag: v1.0.0
  resources:
    requests:
      cpu: 1000m
      memory: 1Gi
    limits:
      cpu: 4000m
      memory: 4Gi

database:
  postgres:
    host: postgres-primary
    port: 5432
    database: learnai
  redis:
    host: redis-cluster
    port: 6379
  mongodb:
    host: mongodb-cluster
    port: 27017

ingress:
  enabled: true
  host: api.learnai.com
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
```

### 5.3 部署命令

```bash
# 创建命名空间
kubectl create namespace learnai

# 部署应用
helm install learnai ./learnai-chart \
  --namespace learnai \
  -f values.yaml

# 查看部署状态
kubectl get pods -n learnai
kubectl get services -n learnai
kubectl get ingress -n learnai

# 查看日志
kubectl logs -f deployment/user-service -n learnai

# 升级部署
helm upgrade learnai ./learnai-chart \
  --namespace learnai \
  -f values.yaml

# 回滚部署
helm rollback learnai

# 删除部署
helm uninstall learnai -n learnai
```

## 六、数据库部署

### 6.1 PostgreSQL部署

#### 6.1.1 主从配置

```yaml
# postgresql-values.yaml
primary:
  replicaCount: 1
  persistence:
    size: 500Gi
  resources:
    requests:
      cpu: 4
      memory: 16Gi
    limits:
      cpu: 8
      memory: 32Gi

readReplicas:
  replicaCount: 2
  persistence:
    size: 500Gi
  resources:
    requests:
      cpu: 4
      memory: 16Gi
    limits:
      cpu: 8
      memory: 32Gi
```

#### 6.1.2 数据库初始化

```sql
-- init.sql
CREATE DATABASE learnai;
CREATE USER learnai WITH PASSWORD 'learnai123';
GRANT ALL PRIVILEGES ON DATABASE learnai TO learnai;

-- 创建表（参考数据库设计文档）
```

### 6.2 Redis集群部署

```yaml
# redis-values.yaml
cluster:
  enabled: true
  replicas: 3
master:
  resources:
    requests:
      cpu: 2
      memory: 8Gi
    limits:
      cpu: 4
      memory: 16Gi
slave:
  resources:
    requests:
      cpu: 2
      memory: 8Gi
    limits:
      cpu: 4
      memory: 16Gi
persistence:
  size: 100Gi
```

### 6.3 MongoDB副本集部署

```yaml
# mongodb-values.yaml
replicaSet:
  enabled: true
  replicas: 3
persistence:
  size: 200Gi
resources:
  requests:
    cpu: 2
    memory: 8Gi
  limits:
    cpu: 4
    memory: 16Gi
```

## 七、CI/CD流程

### 7.1 GitHub Actions配置

```yaml
# .github/workflows/deploy.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          cd backend
          pip install -r requirements.txt
      
      - name: Run tests
        run: |
          cd backend
          pytest tests/ --cov=app

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: ./backend
          push: true
          tags: |
            ghcr.io/learnai/backend:latest
            ghcr.io/learnai/backend:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'v1.28.0'
      
      - name: Deploy to Kubernetes
        run: |
          echo "${{ secrets.KUBE_CONFIG }}" > kubeconfig
          export KUBECONFIG=kubeconfig
          helm upgrade --install learnai ./learnai-chart \
            --namespace learnai \
            --set userService.image.tag=${{ github.sha }} \
            --set learningService.image.tag=${{ github.sha }} \
            --set aiService.image.tag=${{ github.sha }}
```

## 八、监控与告警

### 8.1 Prometheus配置

```yaml
# prometheus-values.yaml
prometheus:
  prometheusSpec:
    scrapeInterval: 30s
    evaluationInterval: 30s
    retention: 30d
    resources:
      requests:
        cpu: 2
        memory: 8Gi
      limits:
        cpu: 4
        memory: 16Gi

grafana:
  persistence:
    size: 50Gi
  resources:
    requests:
      cpu: 1
      memory: 2Gi
    limits:
      cpu: 2
      memory: 4Gi

alertmanager:
  config:
    global:
      resolve_timeout: 5m
    route:
      receiver: 'slack-notifications'
    receivers:
      - name: 'slack-notifications'
        slack_configs:
          - api_url: 'https://hooks.slack.com/services/xxx'
            channel: '#alerts'
```

### 8.2 告警规则

```yaml
# alerts.yaml
groups:
  - name: application
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
      
      - alert: HighCPUUsage
        expr: container_cpu_usage_seconds_total{namespace="learnai"} > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage"
      
      - alert: PodRestarting
        expr: rate(kube_pod_container_status_restarts_total[5m]) > 0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Pod is restarting frequently"
      
      - alert: DatabaseConnectionErrors
        expr: rate(database_connection_errors_total[5m]) > 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Database connection errors"
```

### 8.3 Grafana仪表板

- 应用性能仪表板
- 数据库性能仪表板
- 系统资源仪表板
- 业务指标仪表板
- 错误追踪仪表板

## 九、日志管理

### 9.1 ELK Stack部署

```yaml
# elk-values.yaml
elasticsearch:
  replicas: 3
  minimumMasterNodes: 2
  resources:
    requests:
      cpu: 2
      memory: 4Gi
    limits:
      cpu: 4
      memory: 8Gi
  persistence:
    size: 1Ti

kibana:
  resources:
    requests:
      cpu: 1
      memory: 2Gi
    limits:
      cpu: 2
      memory: 4Gi

logstash:
  replicas: 2
  resources:
    requests:
      cpu: 2
      memory: 4Gi
    limits:
      cpu: 4
      memory: 8Gi

filebeat:
  enabled: true
```

### 9.2 日志格式

```json
{
  "timestamp": "2026-04-03T10:00:00.000Z",
  "level": "INFO",
  "service": "user-service",
  "trace_id": "abc123",
  "user_id": "uuid",
  "action": "login",
  "duration_ms": 150,
  "status": "success",
  "message": "User login successful",
  "metadata": {}
}
```

## 十、备份与恢复

### 10.1 备份策略

| 数据类型 | 备份频率 | 保留时间 |
|---------|---------|---------|
| PostgreSQL全量 | 每日凌晨2点 | 30天 |
| PostgreSQL增量 | 每小时 | 7天 |
| Redis RDB | 每日 | 7天 |
| MongoDB快照 | 每日 | 30天 |
| 对象存储 | 实时同步 | 永久 |

### 10.2 备份脚本

```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/data/backups"

# PostgreSQL备份
pg_dump -U learnai -h postgres-primary learnai | gzip > $BACKUP_DIR/postgres_$DATE.sql.gz

# Redis备份
redis-cli --rdb $BACKUP_DIR/redis_$DATE.rdb

# MongoDB备份
mongodump --uri="mongodb://learnai:learnai123@mongodb-cluster:27017/learnai" --out=$BACKUP_DIR/mongo_$DATE

# 上传到对象存储
aws s3 sync $BACKUP_DIR s3://learnai-backups/

# 清理旧备份
find $BACKUP_DIR -type f -mtime +30 -delete
```

### 10.3 恢复流程

```bash
# 恢复PostgreSQL
gunzip -c postgres_20260403_020000.sql.gz | psql -U learnai -h postgres-primary learnai

# 恢复Redis
cp redis_20260403_020000.rdb /var/lib/redis/dump.rdb
systemctl restart redis

# 恢复MongoDB
mongorestore --uri="mongodb://learnai:learnai123@mongodb-cluster:27017/learnai" mongo_20260403_020000/
```

## 十一、灾难恢复

### 11.1 RTO/RPO目标

| 组件 | RTO（恢复时间） | RPO（数据丢失） |
|------|----------------|----------------|
| 应用服务 | 15分钟 | 无 |
| 数据库 | 1小时 | 15分钟 |
| 缓存 | 5分钟 | 可能丢失 |
| 消息队列 | 30分钟 | 可能丢失 |

### 11.2 灾难恢复流程

```
1. 检测到灾难
2. 启动应急预案
3. 切换到备用数据中心
4. 恢复数据
5. 启动应用服务
6. 验证服务可用性
7. 通知相关人员
8. 事后复盘
```

## 十二、安全配置

### 12.1 网络安全

```yaml
# network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: learnai
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
  ingress: []
  egress: []
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-ingress
  namespace: learnai
spec:
  podSelector:
    matchLabels:
      app: ingress
  ingress:
    - from:
        - ipBlock:
            cidr: 0.0.0.0/0
      ports:
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443
```

### 12.2 安全扫描

```yaml
# trivy-scan.yaml
name: Security Scan

on:
  schedule:
    - cron: '0 2 * * *'

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'ghcr.io/learnai/backend:latest'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
```

## 十三、附录

### 13.1 常用命令

```bash
# Kubernetes
kubectl get pods -n learnai
kubectl get services -n learnai
kubectl logs -f <pod-name> -n learnai
kubectl describe pod <pod-name> -n learnai
kubectl exec -it <pod-name> -n learnai -- /bin/bash
kubectl scale deployment <deployment> --replicas=5 -n learnai

# Helm
helm list -n learnai
helm upgrade learnai ./learnai-chart -n learnai
helm rollback learnai
helm uninstall learnai -n learnai

# 数据库
psql -h postgres-primary -U learnai -d learnai
redis-cli -h redis-cluster
mongosh "mongodb://learnai:learnai123@mongodb-cluster:27017/learnai"
```

### 13.2 问题排查清单

- [ ] 检查Pod状态
- [ ] 查看Pod日志
- [ ] 检查服务状态
- [ ] 检查数据库连接
- [ ] 检查Redis连接
- [ ] 检查网络策略
- [ ] 检查资源使用
- [ ] 检查告警信息

### 13.3 联系人

| 角色 | 姓名 | 联系方式 |
|------|------|---------|
| 运维负责人 | - | - |
| DBA | - | - |
| 安全负责人 | - | - |