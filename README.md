# CMake-base
Base configs and presets for C and C++ projects using CMake.

## Usage: 
- clone as a submodule to {project_root}/cmake/base.
- include `cmake/base/config.cmake` and `cmake/base/utils.cmake` in `{project_root}/CMakeLists.txt` after project is defined.
- include `cmake/base/presets/windows/windows.json` and `cmake/base/presets/linux/linux.json` in `{project_root}/CMakePresets.json`

## Note
- Meant to be used as submodule in my personal projects and templates.
- As such I cannot provide any guarantee about the stability of this repo.
- Use at your own peril if you wish to do so.