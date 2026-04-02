# AGENTS.md

Agent guidance for `mathmate` (Flutter/Dart).

This file is intended for autonomous coding agents working in this repository.
Follow these conventions unless the user explicitly overrides them.

## Project Snapshot

- Stack: Flutter app (`lib/`, `test/`, platform folders for Android/iOS/Web/Desktop).
- Language: Dart (SDK constraint in `pubspec.yaml`: `^3.11.3`).
- Lint baseline: `flutter_lints` via `analysis_options.yaml`.
- Current scope: early-stage app scaffold with one widget test.

## Rule Sources (Cursor/Copilot)

- Checked for Cursor rules in `.cursor/rules/` and `.cursorrules`: none found.
- Checked for Copilot rules in `.github/copilot-instructions.md`: none found.
- If any of these files are added later, treat them as additional required constraints.
- When rules conflict, prioritize explicit user instructions, then repo rule files, then this document.

## Environment and Setup

- Install Flutter SDK compatible with Dart `^3.11.3`.
- From repo root, run dependency install before analysis/tests/build:
- Command: `flutter pub get`
- Verify toolchain:
- Command: `flutter doctor`

## Core Commands

### Run App

- Debug run on connected device/emulator: `flutter run`
- Select a specific device: `flutter devices` then `flutter run -d <device-id>`

### Format

- Format all Dart code: `dart format .`
- Format a specific file: `dart format lib/main.dart`
- Check-only formatting (CI friendly): `dart format --output=none --set-exit-if-changed .`

### Lint / Static Analysis

- Primary lint/analyzer command: `flutter analyze`
- Analyze a specific path: `flutter analyze lib`

### Tests

- Run all tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Run a single test by name (preferred):
- `flutter test --plain-name "Counter increments smoke test" test/widget_test.dart`
- Alternate name filter (regex): `flutter test --name "Counter.*smoke"`
- Machine output (CI/debugging): `flutter test --machine`

### Builds

- Android APK (debug): `flutter build apk --debug`
- Android APK (release): `flutter build apk --release`
- Android App Bundle: `flutter build appbundle --release`
- iOS (requires macOS/Xcode): `flutter build ios --release`
- Web: `flutter build web --release`
- Linux/macOS/Windows desktop (if enabled):
- `flutter build linux --release`
- `flutter build macos --release`
- `flutter build windows --release`

## Suggested Local Validation Sequence

- 1) `flutter pub get`
- 2) `dart format --output=none --set-exit-if-changed .`
- 3) `flutter analyze`
- 4) `flutter test`
- 5) Run targeted build command for affected platform when relevant.

## Repository Structure Guidance

- App entrypoint: `lib/main.dart`.
- Tests: `test/` (currently widget-test focused).
- Product planning notes: `Plan/Plan.md` (Chinese-language planning doc).
- Keep feature code in `lib/` and mirror tests under `test/`.

## Dart and Flutter Style Guidelines

### Formatting and General Style

- Always run `dart format` after code edits.
- Use trailing commas in multiline widget trees for stable formatting.
- Prefer small, composable widgets over long `build` methods.
- Avoid commented-out dead code and stale TODO blocks.
- Keep files focused; split large UI trees into private widgets/helpers.

### Imports

- Prefer package imports for project files (e.g., `package:mathmate/...`).
- Order imports in groups: Dart SDK, Flutter/package deps, local package imports.
- Keep one import per line.
- Remove unused imports before finalizing changes.
- Avoid relative parent imports like `../` when package import is viable.

### Types and Null Safety

- Use explicit types when they improve readability.
- Use `final` by default; use `const` where values/widgets are compile-time constant.
- Avoid `dynamic` unless truly necessary and documented.
- Respect null safety: model nullable values explicitly (`Type?`).
- Use late variables sparingly and only when initialization cannot happen at declaration.

### Naming Conventions

- Classes/enums/typedefs: `PascalCase`.
- Variables/functions/parameters: `lowerCamelCase`.
- Files/directories: `snake_case`.
- Constants: `lowerCamelCase` for Dart style; avoid Java-style ALL_CAPS.
- Private symbols: prefix with `_`.
- Use clear domain names (e.g., `cameraButton`, not generic `btn1`).

### Widget and UI Patterns

- Prefer `StatelessWidget` unless mutable state is needed.
- Use `const` constructors/widgets whenever possible.
- Keep side effects out of `build`; move to callbacks/controllers/services.
- For async UI actions, handle loading and error states explicitly.
- Keep theme/styling centralized; avoid hardcoded magic numbers repeated across files.

### State and Logic

- Keep business logic outside widget tree where practical.
- Separate pure computation from UI rendering for testability.
- When adding state management libraries, document the chosen pattern in README/AGENTS update.

### Error Handling

- Do not silently swallow exceptions.
- Catch specific exceptions when possible.
- Provide user-safe error messages in UI; keep internals in logs.
- Use `debugPrint` for development diagnostics (instead of `print`).
- For async code, always await futures that must complete and handle failures.

### Testing Standards

- Add or update tests for behavior changes.
- Prefer focused tests with descriptive names.
- Keep widget tests deterministic (avoid real network/time dependencies).
- Use finders/assertions that verify user-visible behavior.
- For bug fixes, include a regression test when practical.

## Lint Notes

- Lints come from `package:flutter_lints/flutter.yaml`.
- Do not add blanket `ignore_for_file` unless absolutely necessary.
- If suppressing a lint on one line, justify it with a short rationale comment.

## Agent Execution Expectations

- Make minimal, targeted changes consistent with existing code patterns.
- Prefer updating existing files over introducing new abstractions too early.
- Before running build tasks or Bash commands, ask the user for confirmation first.
- If a command fails, report the failure and likely cause concisely.
- Do not commit or push unless explicitly requested by the user.
- Before handoff, list changed files and mention which checks were run.

## Known Current Caveat

- `test/widget_test.dart` appears to be the default counter test and may not match current UI in `lib/main.dart`.
- If touching UI/app structure, update this test accordingly so `flutter test` reflects real behavior.

## 代码整合任务规约 (Code Integration Protocol)

### 1. 角色定义

你现在担任“代码整合专家”，负责将多人协作产生的外部修改合并至主代码库中。

### 2. 目录结构规范

- **暂存区 (Source):** `./raw_code_preview/` (包含他人修改后的源文件)
- **正式库 (Destination):** `./lib/` (项目主逻辑代码)

### 3. 执行流程

当用户发出“整合代码”或“同步 [文件夹名]”的指令时，请严格执行以下步骤：

1. **深度读取 (Read):**
   - 进入 `raw_code_preview/` 下指定的子文件夹。
   - 读取该文件夹内所有受影响的源码文件。

2. **变更分析 (Analyze):**
   - 对比暂存区文件与 `lib/` 中对应文件的差异。
   - 提取更新要点，包括：新增功能、修复的 Bug、代码重构或 API 变动。

3. **确认环节 (Confirm):**
   - 在执行写入前，向用户提交一份 **《代码变更概要报告》**。
   - **必须等待用户回复“确认”或“执行”后**，方可进入下一步。

4. **原子化整合 (Write):**
   - 将分析后的代码精准更新至 `lib/` 文件夹下的对应文件中。
   - 确保整合后的代码符合原有的代码风格和架构。

### 4. 注意事项

- 严禁在未获得用户显式确认的情况下覆盖 `lib/` 文件夹。
- 若 `raw_code_preview` 中存在 `lib` 中没有的新文件，需询问用户是否作为新组件引入。
