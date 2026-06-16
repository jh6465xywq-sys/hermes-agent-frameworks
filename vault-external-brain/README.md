# 外部记忆框架 — vault-external-brain

系统入口文件：SKILL.md

**用途：** 用 Obsidian vault 作为多 Agent 共享外脑 — 记忆蒸馏、交接协议、写作规范
**加载：** skill_view(name='vault-external-brain')
**相关：** hermes-agent-onboarding-guide（Agent 初始化引导）

## 一句话

Agent 记忆只有 ~2K 字符？建个 vault 当外存，所有 agent 共享，蒸馏归档无限扩展。

## 核心模块

- 记忆 vs Vault 边界
- Agent 角色分工（Writer / Reader）
- 记忆蒸馏 6 步流程
- 多 Agent 交接协议
- 写作规范与模板

## 文件结构

vault-external-brain/
├── SKILL.md          ← 系统入口
├── README.md         ← 本文件
├── assets/
├── references/
├── scripts/
└── templates/
