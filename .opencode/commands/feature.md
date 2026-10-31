---
description: 为单个 feature 新建分支，并在实现过程中分批提交
agent: build
---

实现这个 feature：$ARGUMENTS

严格按 AGENTS.md 的「Git workflow」执行：

1. 先运行 `git status --short` 和 `git branch --show-current`。工作区有无关改动时停下来问我怎么处理。
2. 从 `main` 新建分支：`git switch -c feat/<kebab-slug>`（修复用 `fix/`，依赖/工具链用 `chore/`）。已经在该 feature 的分支上就继续用，不要重复建分支。
3. 按自包含的逻辑单元分批修改、分批提交：每批用 `git add <具体路径>` 只暂存这一批的文件，提交信息用 Conventional Commits（`feat(scope): ...`）。
4. 改动 Lua 时，每个提交前跑一次 headless smoke test：`NVIM_APPNAME=lazyvim nvim --headless "+lua print('ok')" +qa`。
5. 不要 amend / rebase / push；不要提交密钥、`.env` 或运行时状态。
6. 结束时报告：分支名、`git log --oneline main..HEAD`、smoke test 结果。
