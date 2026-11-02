---
description: 为单个 feature 新建分支，并在实现过程中分批提交
agent: build
---

严格按 AGENTS.md 的「Git workflow」执行，步骤以该文件为准：

实现这个 feature：$ARGUMENTS

- Lua 改动的检查命令见 AGENTS.md 的「Commands」，不要另外发明 smoke test。
- 结束时报告：分支名、`git log --oneline main..HEAD`、检查结果。
