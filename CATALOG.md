# Hermes Agent Frameworks — Catalog

## 仓库结构

```
hermes-agent-frameworks/
├── README.md                              ← 项目首页（安装说明）
├── CATALOG.md                             ← 本文件
├── LICENSE                                ← MIT 开源协议
├── install.sh                             ← 一键安装脚本
│
├── vault-external-brain/                  ← 外部记忆框架
│   ├── SKILL.md                           ← Hermes skill 入口
│   └── README.md                          ← 概览
│
└── hermes-agent-onboarding-guide/         ← Agent 初始化引导
    ├── SKILL.md
    └── README.md
```

## 框架列表

| 框架 | 技能名 | 说明 |
|------|--------|------|
| 外部记忆框架 | vault-external-brain | Obsidian vault 多 Agent 共享外脑 — 记忆蒸馏、交接协议、写作规范 |
| Agent 初始化引导 | hermes-agent-onboarding-guide | 新 Agent 标准化初始化 — 环境探测、用户画像、Skill 选择、模型分层 |

## 快速加载

```bash
# 在 Hermes 中加载
skill_view(name='vault-external-brain')
skill_view(name='hermes-agent-onboarding-guide')
```

## 一键安装

```bash
curl -sSL https://raw.githubusercontent.com/jh6465xywq-sys/hermes-agent-frameworks/main/install.sh | bash
```
