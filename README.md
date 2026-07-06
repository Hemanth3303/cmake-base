# CMake-base
Base configs and presets for C and C++ projects using CMake.

## Usage
- clone as a submodule to `{project_root}/cmake/base`
- include `cmake/base/config.cmake` and `cmake/base/utils.cmake` in `{project_root}/CMakeLists.txt` after `project()` is defined
- include `cmake/base/presets/windows/windows.json` and `cmake/base/presets/linux/linux.json` in `{project_root}/CMakePresets.json`
- on each target, pick a prefix (e.g. `APPLICATION`, `GAME`) and call:
  - `cmake_base_target_platform_definitions(target prefix)`
  - `cmake_base_target_architecture_definitions(target prefix)`
- add config macros per target:
  - Debug: `{PREFIX}_DEBUG_BUILD`, `DEBUG`
  - Profile: `{PREFIX}_PROFILE_BUILD`, `NDEBUG`
  - Release: `{PREFIX}_RELEASE_BUILD`, `NDEBUG`
- build output goes to `build/<os>_<arch>/<Config>/` (example: `build/linux_x86-64/Profile/Game`)
- use `cmake --list-presets` to see available presets, then `cmake --preset=<name>` and `cmake --build build`

## Info
- **Debug** — slow, full debug info. Use `{PREFIX}_DEBUG_BUILD` / `DEBUG` in code.
- **Profile** — optimized with debug symbols (same idea as RelWithDebInfo). Use `{PREFIX}_PROFILE_BUILD` / `NDEBUG`. Mainly for instrumentation + logging.
- **Release** — full optimization, no debug symbols. Use `{PREFIX}_RELEASE_BUILD` / `NDEBUG`. Strip diagnostics in code.
- **Platform macros** (from `cmake_base_target_platform_definitions`): `{PREFIX}_PLATFORM_WINDOWS`, `_LINUX`, `_DARWIN`, or `_UNKNOWN`
- **Arch macros** (from `cmake_base_target_architecture_definitions`): `{PREFIX}_ARCHITECTURE_X86_64`, `_X86_32`, `_AARCH64`, `_AARCH32`, `_RISCV64`, `_RISCV32`, or `_UNKNOWN`
- **Utils**: `print(var ...)` and `print_env(var ...)` for configure-time logging

## Note
- This is meant to be used as submodule in my personal projects and templates.
- As such I cannot provide any guarantee about the stability of this repo.
- Use at your own peril if you wish to do so.

## Warning
- This is my personal opinionated take on "sensible defaults".
- These opinions might not be good in a large scale cross-platform project, I have no idea.
- If you somehow find this repo and submit pull requests, I won't accept them.
