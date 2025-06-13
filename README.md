# Cross-Platform C/C++ Project Template

This project demonstrates a small mixed C and C++ code base using **CMake** for
its build system.  The original version relied on a custom Makefile, but CMake
provides much better cross-platform support.

## Directory Layout

- `src/`      – source files
- `include/`  – public header files
- `build/`    – directory created by CMake to hold build artefacts

## Building

1. Create a build directory:

   ```bash
   cmake -S . -B build
   cmake --build build
   ```

2. The resulting executable is located in `build/` (or `build/bin/` depending on
   your generator).

## Running

After building, run the executable:

```bash
./build/main
```

## Installing

The project also defines install rules:

```bash
cmake --install build --prefix /desired/prefix
```
