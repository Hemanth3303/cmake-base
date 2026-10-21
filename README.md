# CMake-base
Base configs and presets for C and C++ projects using CMake.

## Usage
- clone as a submodule to `{project_root}/cmake/base`
- include `cmake/base/core/core.cmake` and `cmake/base/utils/print_vars.cmake` in `{project_root}/CMakeLists.txt` after `project()` is defined
- include `cmake/base/presets/windows/windows.json` and `cmake/base/presets/linux/linux.json` in `{project_root}/CMakePresets.json`
- for each target after the target is defined, source files are set and properties are defined, do the following:
  - first pick a prefix (e.g. `APPLICATION`, `GAME`) then call the given functions in order
  - `cmake_base_configure_target(target)`, this sets some common defines like DEBUG/NDEBUG, win32 defines, msvc stuff to enforce standard C++ conformance, linker flags, etc. [call only once]
  - `cmake_base_apply_target_definitions(target prefix)`, this creates defines PREFIX and APP_<Config>_BUILD. can be called multiple times, as same target can have multipe prefixes. example, a target can be APPPLICATION_DEBUG_BUILD as well as ENGINE_CLIENT_DEBUG_BUILD at the same time.
  - `cmake_base_apply_os_definitions_to_target(target prefix)` [call only once]
  - `cmake_base_apply_architecture_definitions_to_target(target prefix)` [call only once]
  - `cmake_base_apply_compiler_definitions_to_target(target prefix)` [call only once]
  - `cmake_base_apply_sanitizers(target SANITIZERS <...> CONFIGS <...>)` [call only once], apply sanitizer compile/link flags per config; incompatible combinations are fatal at configure time; unsupported sanitizers on the current compiler warn and are skipped
- build output goes to `build/<os>_<arch>_<compiler>/<Config>/` (example: `build/linux_x86_64_gnu-gcc/Profile/Game`)
- use `cmake --list-presets` to see available presets, then `cmake --preset=<name>` and `cmake --build build`

## Info
- **Build configs** — defined once as `CMAKE_BASE_CONFIGS` in `config.cmake` (Debug, Profile, Release).
- **Debug** — slow, full debug info. Use `{PREFIX}_DEBUG_BUILD` / `DEBUG` in code.
- **Profile** — optimized with debug symbols (same idea as RelWithDebInfo). Use `{PREFIX}_PROFILE_BUILD` / `NDEBUG`. Mainly for instrumentation + logging.
- **Release** — full optimization, no debug symbols. Use `{PREFIX}_RELEASE_BUILD` / `NDEBUG`. Strip diagnostics in code.
- **Os macros** (from `cmake_base_apply_os_definitions_to_target`): `{PREFIX}_OS_WINDOWS`, `_LINUX`, `_DARWIN`, etc, or `_UNKNOWN`
- **Architecture macros** (from `cmake_base_apply_architecture_definitions_to_target`): `{PREFIX}_ARCHITECTURE_X86_64`, `_X86_32`, `_AARCH64`, `_AARCH32`, `_RISCV64`, `_RISCV32`, or `_UNKNOWN`
- **Compiler Identity macros** (from `cmake_base_apply_compiler_definitions_to_target`): `{PREFIX}_COMPILER_GNU_GCC`, `_MSVC`, etc, or `_UNKNOWN`
- **Utils**: `print_var(var ...)` and `print_env_var(var ...)` for configure-time logging

## Note
- This is meant to be used as submodule in my personal projects and templates.
- As such I cannot provide any guarantee about the stability of this repo.
- Use at your own peril if you wish to do so.

## Warning
- This is my personal opinionated take on "sensible defaults".
- These opinions might not be good in a large scale cross-platform project, I have no idea.
- If you somehow find this repo and submit pull requests, I won't accept them.
