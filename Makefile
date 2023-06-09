.PHONY: all release debug build production develop test format

BUILD_DIR := build

# brew install make cmake ninja llvm pre-commit clang-format
setup:
	@pre-commit install

release: _prepare
	@echo "Building release..."
	@cd $(BUILD_DIR) && cmake -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && ninja
	@echo "Make a link to compile_commands.json"
	@rm -f compile_commands.json && ln -s build/compile_commands.json compile_commands.json

debug: _prepare
	@echo "Building debug..."
	@cd $(BUILD_DIR) && cmake -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug .. && ninja
	@echo "Make a link to compile_commands.json"
	@rm -f compile_commands.json && ln -s build/compile_commands.json compile_commands.json

all: release
build: release
production: release
develop: debug

test: debug
	@echo "Running tests..."
	@(cd $(BUILD_DIR) && ctest --verbose)

format:
	@clang-format -i -style=file bin/*.c
	@clang-format -i -style=file lib/src/*.c
	@clang-format -i -style=file lib/include/*.h
	@clang-format -i -style=file test/*.c


_prepare:
	@mkdir $(BUILD_DIR) || true